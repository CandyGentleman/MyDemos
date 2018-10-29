//
//  ViewController.m
//  HSPopView
//
//  Created by 刘鹿杰的mac on 2018/3/22.
//  Copyright © 2018年 刘鹿杰的mac. All rights reserved.
//

#import "ViewController.h"
#import "HSqqPopMenuView.h"
#import "HSPopBottomView.h"
#import "HSCentralPopView.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (IBAction)pop0:(id)sender {

    [HSqqPopMenuView showWithItems:@[@{@"title":@"自动转入设置",@"imageName":@"popMenu_createChat"},
                                     @{@"title":@"常见问题",@"imageName":@"popMenu_scanCard"}
                                     ]
                             width:160
                  triangleLocation:CGPointMake([UIScreen mainScreen].bounds.size.width-60, 64+5)
                            action:^(NSInteger index) {
                                NSLog(@"点击了第%ld行",index);
                            }];

}
- (IBAction)pop1:(id)sender {
    NSArray *array = @[@"积分+增值年化利率约6%，你真的要关闭吗？",@"确认关闭",@"取消"];
    [HSPopBottomView showWithItems:array action:^(NSInteger index) {
                                         NSLog(@"点击了第%ld行",index);
                                     }];
}
- (IBAction)pop2:(id)sender {
    [HSCentralPopView showWithItems:@[@"期待您的宝贵意见",
                                      @"使用不方便",
                                      @"积分增值少",
                                      @"单纯试试",
                                      @"想要全部申请积分兑换",
                                      ] action:^(NSInteger index) {
                                          NSLog(@"点击了第%ld行",index);
                                      }];
}


@end
