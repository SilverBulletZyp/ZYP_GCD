//
//  BarrierAsyncVC.m
//  ZYP_GCD
//
//  Created by zhaoyunpeng on 17/5/24.
//  Copyright © 2017年 zhaoyunpeng. All rights reserved.
//

#import "BarrierAsyncVC.h"

@interface BarrierAsyncVC ()

@end

@implementation BarrierAsyncVC

- (void)viewDidLoad {
    [super viewDidLoad];
    
}

- (void)onClickButton:(UIButton *)button {
    
    // dispatch_barrier_async 栅栏函数
    
    dispatch_queue_t queue = dispatch_queue_create("queue", DISPATCH_QUEUE_CONCURRENT);
    
    dispatch_async(queue, ^{
        for (int i = 0; i < 3; i++) {
            [self currentThreadLog:i];
        }
    });
    
    dispatch_barrier_async(queue, ^{
        for (int i = 3; i < 6; i++) {
            [self currentThreadLog:i];
        }
    });
    
    dispatch_async(queue, ^{
        for (int i = 6; i < 9; i++) {
            [self currentThreadLog:i];
        }
    });

}

// dispatch_barrier_async 栅栏函数

/*
 在进程管理中起到一个栅栏的作用,它等待所有位于barrier函数之前的操作执行完毕后执行
 并且在barrier函数执行完成后,barrier函数之后的操作才会得到执行
 该函数需要同dispatch_queue_create函数生成的concurrent Dispatch Queue队列一起使用
 */

/*
 作用
 1.实现高效率的数据库访问和文件访问
 2.避免数据竞争
 */


@end
