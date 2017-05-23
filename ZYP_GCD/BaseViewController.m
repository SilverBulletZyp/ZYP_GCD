//
//  BaseViewController.m
//  ZYP_GCD
//
//  Created by zhaoyunpeng on 17/5/23.
//  Copyright © 2017年 zhaoyunpeng. All rights reserved.
//

#import "BaseViewController.h"

@interface BaseViewController ()

@end

@implementation BaseViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    self.view.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:self.button];
}

- (UIButton *)button {
    if (!_button) {
        _button = [[UIButton alloc]initWithFrame:CGRectMake((self.view.frame.size.width - 120)/2, (self.view.frame.size.width - 60)/2, 120, 60)];
        _button.titleLabel.font = [UIFont boldSystemFontOfSize:17.0];
        [_button setTitle:@"button" forState:UIControlStateNormal];
        [_button setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [_button setBackgroundColor:[UIColor redColor]];
        [_button addTarget:self action:@selector(onClickButton:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _button;
}

- (void)onClickButton:(UIButton *)button {
    
}

- (void)currentThreadLog:(int)i {
    NSLog(@"num%d %@",i,[NSThread currentThread]);
}

@end


/*
 线程是代码执行的路径，队列则是用于保存以及管理任务的，线程负责去队列中取任务进行执行。
 */

/*
 
 GCD 基本使用
 
                并发队列            串行队列            主队列
 ******************************************************************
 同步Sync     没有开启新线程        没有开启新线程      没有开启新线程
              串行执行任务          串行执行任务        串行执行任务
 ******************************************************************
 异步Async     有开启新线程        有开启新线程(1条)    没有开启新线程
               并发执行任务         串行执行任务        串行执行任务
 ******************************************************************

*/











