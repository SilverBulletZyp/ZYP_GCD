//
//  AfterTimeVC.m
//  ZYP_GCD
//
//  Created by zhaoyunpeng on 17/5/24.
//  Copyright © 2017年 zhaoyunpeng. All rights reserved.
//

#import "AfterTimeVC.h"

@interface AfterTimeVC ()

@end

@implementation AfterTimeVC

- (void)viewDidLoad {
    [super viewDidLoad];

}

- (void)onClickButton:(UIButton *)button {
    
    // dispatch_after 延时调用
    
    dispatch_time_t time = dispatch_time(DISPATCH_TIME_NOW, (int64_t)NSEC_PER_SEC * 5);
    
    [self currentThreadLogWithTime:0];
    
    dispatch_after(time, dispatch_get_main_queue(), ^{
        [self currentThreadLogWithTime:1];
    });
    
}


@end
