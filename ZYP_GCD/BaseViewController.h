//
//  BaseViewController.h
//  ZYP_GCD
//
//  Created by zhaoyunpeng on 17/5/23.
//  Copyright © 2017年 zhaoyunpeng. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface BaseViewController : UIViewController

@property (nonatomic, strong) UIButton *button;

- (void)onClickButton:(UIButton *)button;
- (void)currentThreadLog:(int)i;
- (void)currentThreadLogWithTime:(int)i;

@end
