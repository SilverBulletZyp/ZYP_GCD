//
//  OnceVC.m
//  ZYP_GCD
//
//  Created by zhaoyunpeng on 17/5/24.
//  Copyright © 2017年 zhaoyunpeng. All rights reserved.
//

#import "OnceVC.h"

@interface OnceVC ()

@end

@implementation OnceVC

- (void)viewDidLoad {
    [super viewDidLoad];
    
}

- (void)onClickButton:(UIButton *)button {
    
    // dispatch_once 整个程序运行过程中只执行一次
    
    static OnceVC *onceVc;
    
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        
        // 默认线程安全
        onceVc = [[OnceVC alloc]init];
    });
}


@end
