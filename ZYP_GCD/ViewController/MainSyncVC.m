//
//  MainSyncVC.m
//  ZYP_GCD
//
//  Created by zhaoyunpeng on 17/5/23.
//  Copyright © 2017年 zhaoyunpeng. All rights reserved.
//

#import "MainSyncVC.h"

@interface MainSyncVC ()

@end

@implementation MainSyncVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (void)onClickButton:(UIButton *)button {
    
    // main sync 主队列同步 -
    dispatch_queue_t queue = dispatch_get_main_queue();
    
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
