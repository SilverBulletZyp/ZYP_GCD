//
//  SerialSyncVC.m
//  ZYP_GCD
//
//  Created by zhaoyunpeng on 17/5/23.
//  Copyright © 2017年 zhaoyunpeng. All rights reserved.
//

#import "SerialSyncVC.h"

@interface SerialSyncVC ()

@end

@implementation SerialSyncVC

- (void)viewDidLoad {
    [super viewDidLoad];
    
}

- (void)onClickButton:(UIButton *)button {
    
    // serial sync 串行同步 - 当前线程 串行 顺序
    dispatch_queue_t queue = dispatch_queue_create("queue", DISPATCH_QUEUE_SERIAL);
    
    dispatch_sync(queue, ^{
        
        for (int i = 0; i < 3; i++) {
            [self currentThreadLog:i];
        }
    });
    
    dispatch_sync(queue, ^{
        for (int i = 3; i < 6; i++) {
            [self currentThreadLog:i];
        }
    });
    
    dispatch_sync(queue, ^{
        for (int i = 6; i < 9; i++) {
            [self currentThreadLog:i];
        }
    });

}





@end
