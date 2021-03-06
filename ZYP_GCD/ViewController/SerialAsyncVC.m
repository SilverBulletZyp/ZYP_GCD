//
//  SerialAsyncVC.m
//  ZYP_GCD
//
//  Created by zhaoyunpeng on 17/5/23.
//  Copyright © 2017年 zhaoyunpeng. All rights reserved.
//

#import "SerialAsyncVC.h"

@interface SerialAsyncVC ()

@end

@implementation SerialAsyncVC

- (void)viewDidLoad {
    [super viewDidLoad];
    
}

- (void)onClickButton:(UIButton *)button {
    
    // serial async 串行异步 - 开启1条新线程 串行 顺序
    dispatch_queue_t queue = dispatch_queue_create("queue", DISPATCH_QUEUE_SERIAL);
    
    dispatch_async(queue, ^{
        
        for (int i = 0; i < 3; i++) {
            [self currentThreadLog:i];
        }
    });
    
    dispatch_async(queue, ^{
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

@end
