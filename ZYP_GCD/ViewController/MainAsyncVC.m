//
//  MainAsyncVC.m
//  ZYP_GCD
//
//  Created by zhaoyunpeng on 17/5/23.
//  Copyright © 2017年 zhaoyunpeng. All rights reserved.
//

#import "MainAsyncVC.h"

@interface MainAsyncVC ()

@end

@implementation MainAsyncVC

- (void)viewDidLoad {
    [super viewDidLoad];
    
}

- (void)onClickButton:(UIButton *)button {
    
    // main async 主队列异步 - 当前线程 串行
    dispatch_queue_t queue = dispatch_get_main_queue();
    
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
