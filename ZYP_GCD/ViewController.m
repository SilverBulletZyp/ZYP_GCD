//
//  ViewController.m
//  ZYP_GCD
//
//  Created by zhaoyunpeng on 17/5/23.
//  Copyright © 2017年 zhaoyunpeng. All rights reserved.
//

#import "ViewController.h"
#import "BaseViewController.h"
#import "SerialSyncVC.h"
#import "SerialAsyncVC.h"

@interface ViewController () <UITableViewDelegate,UITableViewDataSource>
@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) NSArray *array;
@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = @"GCD_Study";
    
    UIBarButtonItem * backButtonItem = [[UIBarButtonItem alloc] init];
    backButtonItem.title = @"back";
    self.navigationItem.backBarButtonItem = backButtonItem;

    // serial sync                  串行同步
    // serial async                 串行异步
    // concurrent sync              并发同步
    // concurrent async             并发异步
    // main sync                    主队列同步
    // main async                   主队列异步
    // main updateUI                主线程刷新UI
    // barrier async                栅栏异步
    // after time                   延时调用
    // once                         执行一次
    // apply                        快速迭代
    // group                        队列组
    
    self.array = @[@{@"name":@"serial sync",@"vc":@"SerialSyncVC"},
                   @{@"name":@"serial async",@"vc":@"SerialAsyncVC"},
                   @{@"name":@"concurrent sync",@"vc":@"ConcurrentSyncVC"},
                   @{@"name":@"concurrent async",@"vc":@"ConcurrentAsyncVC"},
                   @{@"name":@"main sync",@"vc":@"MainSyncVC"},
                   @{@"name":@"main async",@"vc":@"MainAsyncVC"},
                   @{@"name":@"main updateUI",@"vc":@"MainUpdateUIVC"},
                   @{@"name":@"barrier async",@"vc":@"BarrierAsyncVC"},
                   @{@"name":@"after time",@"vc":@"AfterTimeVC"},
                   @{@"name":@"once",@"vc":@"OnceVC"},
                   @{@"name":@"apply",@"vc":@"ApplyVC"},
                   @{@"name":@"group",@"vc":@"GroupVC"},];
    
    self.tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height) style:UITableViewStyleGrouped];
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    [self.view addSubview:self.tableView];
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.array.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:@"cell"];
    if (!cell) {
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"cell"];
        cell.textLabel.text = self.array[indexPath.row][@"name"];
        cell.textLabel.textColor = [UIColor blackColor];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        cell.accessoryType = UITableViewCellAccessoryNone;
    }
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 1;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    [tableView deselectRowAtIndexPath:indexPath animated:NO];
    
    NSString *vcClassName = self.array[indexPath.row][@"vc"];
    Class vcClass = NSClassFromString(vcClassName);
    if (vcClass) {
        BaseViewController *vc = [[vcClass alloc]init];
        vc.title = self.array[indexPath.row][@"name"];
        [self.navigationController pushViewController:vc animated:YES];
    }
    
}


@end
