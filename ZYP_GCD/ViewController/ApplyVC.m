//
//  ApplyVC.m
//  ZYP_GCD
//
//  Created by zhaoyunpeng on 17/5/24.
//  Copyright © 2017年 zhaoyunpeng. All rights reserved.
//

#import "ApplyVC.h"

@interface ApplyVC ()

@end

@implementation ApplyVC

- (void)viewDidLoad {
    [super viewDidLoad];
    
}

- (void)onClickButton:(UIButton *)button {
    
    // dispatch_apply 快速迭代 开辟多线程同时执行
    
    dispatch_queue_t queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
    
    // iterations 迭代次数
    
    dispatch_apply(6, queue, ^(size_t index) {
        [self currentThreadLogWithTime:(int)index];
    });
    
    
    
    
    // iOS中的各种遍历方法
    // http://blog.sunnyxx.com/2014/04/30/ios_iterator/
}


@end



/*!
 * @function dispatch_apply
 *
 * @abstract
 * Submits a block to a dispatch queue for multiple invocations.
 * 提交一个块到调度队列去多次调用
 *
 * @discussion
 * Submits a block to a dispatch queue for multiple invocations. This function
 * waits for the task block to complete before returning. If the target queue
 * is concurrent, the block may be invoked concurrently, and it must therefore
 * be reentrant safe.
 * 提交一个块到调度队列去多次调用，此函数在返回之前等待任务块完成
 * 如果目标队列是并发，该块可以同时调用，因此它必须是可重入安全的
 *
 * Each invocation of the block will be passed the current index of iteration.
 * 每个对块的调用都将通过当前的迭代索引
 *
 * @param iterations
 * The number of iterations to perform.
 *
 * @param queue
 * The target dispatch queue to which the block is submitted.
 * The result of passing NULL in this parameter is undefined.
 *
 * @param block
 * The block to be invoked the specified number of iterations.
 * The result of passing NULL in this parameter is undefined.
 */


/*
    #ifdef __BLOCKS__
    __OSX_AVAILABLE_STARTING(__MAC_10_6,__IPHONE_4_0)
    DISPATCH_EXPORT DISPATCH_NONNULL3 DISPATCH_NOTHROW
    void
    dispatch_apply(size_t iterations, dispatch_queue_t queue,
                   DISPATCH_NOESCAPE void (^block)(size_t));
    #endif
 */

