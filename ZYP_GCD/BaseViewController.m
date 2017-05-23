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
