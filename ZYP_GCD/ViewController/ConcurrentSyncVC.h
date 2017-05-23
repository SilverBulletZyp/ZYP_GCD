//
//  ConcurrentSyncVC.h
//  ZYP_GCD
//
//  Created by zhaoyunpeng on 17/5/23.
//  Copyright © 2017年 zhaoyunpeng. All rights reserved.
//

#import "BaseViewController.h"

@interface ConcurrentSyncVC : BaseViewController

@end

// dispatch_sync

/*!
 * @function dispatch_sync
 *
 * @abstract
 * Submits a block for synchronous execution on a dispatch queue.
 * 提交一个同步执行的块在调度队列上
 *
 * @discussion
 * Submits a block to a dispatch queue like dispatch_async(), however
 * dispatch_sync() will not return until the block has finished.
 * 提交一个块到调度队列如同异步执行，然而同步执行在block完成前不会返回
 *
 * Calls to dispatch_sync() targeting the current queue will result
 * in dead-lock. Use of dispatch_sync() is also subject to the same
 * multi-party dead-lock problems that may result from the use of a mutex.
 * Use of dispatch_async() is preferred.
 * 在当前队列调用同步执行会造成死锁，使用同步执行也会受到使用互斥锁可能导致的mutex死锁问题的影响
 * 使用异步执行是首选
 *
 * Unlike dispatch_async(), no retain is performed on the target queue. Because
 * calls to this function are synchronous, the dispatch_sync() "borrows" the
 * reference of the caller.
 * 与异步执行不同，在目标队列上没有任何保留地执行
 * 因为对该函数的调用是同步的，同步执行“借用”调用者的引用。
 *
 * As an optimization, dispatch_sync() invokes the block on the current
 * thread when possible.
 * 作为优化，同步执行在可能的情况下调用当前线程上的块。
 *
 * @param queue
 * The target dispatch queue to which the block is submitted.
 * The result of passing NULL in this parameter is undefined.
 * block需要提交的目标队列
 * 在这个参数中传递NULL的结果是未定义的
 *
 * @param block
 * The block to be invoked on the target dispatch queue.
 * The result of passing NULL in this parameter is undefined.
 * 目标调度队列调用的block
 * 在这个参数中传递NULL的结果是未定义的
 */


/*
    #ifdef __BLOCKS__
    __OSX_AVAILABLE_STARTING(__MAC_10_6,__IPHONE_4_0)
    DISPATCH_EXPORT DISPATCH_NONNULL_ALL DISPATCH_NOTHROW
    void
    dispatch_sync(dispatch_queue_t queue, DISPATCH_NOESCAPE dispatch_block_t block);
    #endif
*/

/**************死锁原理详解**************/


/*
 
 source/queue.c
 
 // 1.dispatch_sync将block函数指针进行了一些转换后，直接传给了dispatch_sync_f()去处理
 
 void
 dispatch_sync(dispatch_queue_t dq, void (^work)(void))
 {
    struct Block_basic *bb = (void *)work;
    dispatch_sync_f(dq, work, (dispatch_function_t)bb->Block_invoke);
 }
 
 DISPATCH_NOINLINE
 void
 dispatch_sync_f(dispatch_queue_t dq, void *ctxt, dispatch_function_t func)
 {
    typeof(dq->dq_running) prev_cnt;
    dispatch_queue_t old_dq;
 
 // 2.dispatch_sync_f首先检查传入的队列宽度（dq_width）
 //   由于我们传入的main queue为串行队列，队列宽度为1，因此接下来会调用dispatch_barrier_sync_f
 //   传入3个参数:dispatch_sync中的目标queue、上下文信息和由我们block函数指针转化过后的func结构体
 
    if (dq->dq_width == 1) {
        return dispatch_barrier_sync_f(dq, ctxt, func);
    }
 
    // 1) ensure that this thread hasn't enqueued anything ahead of this call
    // 2) the queue is not suspended
    
    if (slowpath(dq->dq_items_tail) || slowpath(DISPATCH_OBJECT_SUSPENDED(dq))) {
        _dispatch_sync_f_slow(dq);
    } 
    else {
        prev_cnt = dispatch_atomic_add(&dq->dq_running, 2) - 2;
 
        if (slowpath(prev_cnt & 1)) {
            if (dispatch_atomic_sub(&dq->dq_running, 2) == 0) {
                _dispatch_wakeup(dq);
            }
            _dispatch_sync_f_slow(dq);
        }
    }
 
    old_dq = _dispatch_thread_getspecific(dispatch_queue_key);
    _dispatch_thread_setspecific(dispatch_queue_key, dq);
    func(ctxt);
    _dispatch_workitem_inc();
    _dispatch_thread_setspecific(dispatch_queue_key, old_dq);
 
    if (slowpath(dispatch_atomic_sub(&dq->dq_running, 2) == 0)) {
        _dispatch_wakeup(dq);
    }
 }
 
 
 // 3.dispatch_barrier_sync_f的实现
 
 void
 dispatch_barrier_sync_f(dispatch_queue_t dq, void *ctxt, dispatch_function_t func)
 {
    dispatch_queue_t old_dq = _dispatch_thread_getspecific(dispatch_queue_key);
 
    // 1) ensure that this thread hasn't enqueued anything ahead of this call
    // 2) the queue is not suspended
    // 3) the queue is not weird
 
    // 队列存在尾部节点状态（判断当前是不是处于队列尾部）
    // 队列不为暂停状态
    // 使用_dispatch_queue_trylock检查队列能被正常加锁。
 
    if (slowpath(dq->dq_items_tail)
        || slowpath(DISPATCH_OBJECT_SUSPENDED(dq))
        || slowpath(!_dispatch_queue_trylock(dq))) {
        return _dispatch_barrier_sync_f_slow(dq, ctxt, func);
    }
 
    // 满足所有条件则不执行if语句内的内容，执行下面代码，简单解释为：
    // 使用mutex锁，获取到当前进程资源锁。
    // 直接执行我们block函数指针的具体内容。
    // 然后释放锁，整个调用结束。
 
    _dispatch_thread_setspecific(dispatch_queue_key, dq);
    func(ctxt);
    _dispatch_workitem_inc();
    _dispatch_thread_setspecific(dispatch_queue_key, old_dq);
    _dispatch_queue_unlock(dq);
 }
 
 
 // 4.我们的流程进入_dispatch_barrier_aync_f_slow()函数体中
 
 static void
 _dispatch_barrier_sync_f_slow(dispatch_queue_t dq, void *ctxt, dispatch_function_t func)
 {
 
    // It's preferred to execute synchronous blocks on the current thread
    // due to thread-local side effects, garbage collection, etc. However,
    // blocks submitted to the main thread MUST be run on the main thread
 
    struct dispatch_barrier_sync_slow2_s dbss2 = {
        .dbss2_dq = dq,
 #if DISPATCH_COCOA_COMPAT
        .dbss2_func = func,
        .dbss2_ctxt = ctxt,
 #endif
        .dbss2_sema = _dispatch_get_thread_semaphore(),
    };
    struct dispatch_barrier_sync_slow_s {
        DISPATCH_CONTINUATION_HEADER(dispatch_barrier_sync_slow_s);
    } 
    dbss = {
        .do_vtable = (void *)DISPATCH_OBJ_BARRIER_BIT,
        .dc_func = _dispatch_barrier_sync_f_slow_invoke,
        .dc_ctxt = &dbss2,
    };
 
 //---------------重点是这里---------------
 
    _dispatch_queue_push(dq, (void *)&dbss);
    dispatch_semaphore_wait(dbss2.dbss2_sema, DISPATCH_TIME_FOREVER);
    _dispatch_put_thread_semaphore(dbss2.dbss2_sema);
 
 #if DISPATCH_COCOA_COMPAT
    // Main queue bound to main thread
    if (dbss2.dbss2_func == NULL) {
        return;
    }
 #endif
    dispatch_queue_t old_dq = _dispatch_thread_getspecific(dispatch_queue_key);
    _dispatch_thread_setspecific(dispatch_queue_key, dq);
    func(ctxt);
    _dispatch_workitem_inc();
    _dispatch_thread_setspecific(dispatch_queue_key, old_dq);
    dispatch_resume(dq);
 }
 
 // 5.既然我们上面已经判断了，main queue中还有其他任务，现在不能直接执行这个block，跳入到_dispatch_barrier_sync_f_slow函数体，那它怎么处理我们加入的block呢？
 
    在_dispatch_barrier_sync_f_slow中，使用_dispatch_queue_push将我们的block压入main queue的FIFO队列中，然后等待信号量，ready后被唤醒。
 
    然后dispatch_semaphore_wait返回_dispatch_semaphore_wait_slow(dsema, timeout)函数，持续轮训并等待，直到条件满足。
 
 
 *********************************************************************************
 所以在此过程中，我们最初调用的dispatch_sync函数一直得不到返回，main queue被阻塞，而我们的block又需要等待main queue来执行它。死锁愉快的产生了。
 *********************************************************************************
 
 
 1.由于main queue执行到这个位置，会等待dispatch_sync()的block返回
 
 dispatch_sync(dispatch_get_main_queue(), ^{
 
 });
 
 2.同时dispatch_sync()必须要等到block执行完才能返回
   而main queue是串行队列，FIFO方式执行任务，block为新增任务，为队列后面，因此进入等待执行
 
 3.所以变成相互等待...
 
 */






