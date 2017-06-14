//
//  MainUpdateUIVC.m
//  ZYP_GCD
//
//  Created by zhaoyunpeng on 17/5/24.
//  Copyright © 2017年 zhaoyunpeng. All rights reserved.
//

#import "MainUpdateUIVC.h"

@interface MainUpdateUIVC ()

@end

@implementation MainUpdateUIVC

- (void)viewDidLoad {
    [super viewDidLoad];
    
}

- (void)onClickButton:(UIButton *)button {
    
    // 主线程刷新UI
    dispatch_queue_t queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
    
    dispatch_async(queue, ^{
        
        [self currentThreadLog:0];
        
        dispatch_async(dispatch_get_main_queue(), ^{
            
            [self currentThreadLog:1];
            
        });
    });
    
}



@end
