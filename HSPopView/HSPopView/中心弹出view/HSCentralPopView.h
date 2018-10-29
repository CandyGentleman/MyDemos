//
//  HSCentralPopView.h
//  底部弹框封装
//
//  Created by 刘鹿杰的mac on 2018/3/22.
//  Copyright © 2018年 刘鹿杰的mac. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface HSCentralPopView : UIView

/**
 *  实例化方法
 *
 *  @param nameArray  items，包含字典，字典里面包含标题（title）、图片名（imageName）
 *  @param action 点击回调
 */
- (instancetype)initWithItems:(NSArray <NSString *>*)nameArray
                       action:(void(^)(NSInteger index))action;

/**
 *  类方法展示
 *
 *  @param nameArray  items，包含字典，字典里面包含标题（title）、图片名（imageName）
 *  @param action 点击回调
 */
+ (void)showWithItems:(NSArray <NSString *>*)nameArray
               action:(void(^)(NSInteger index))action;

- (void)show;
- (void)hide;


/** 测试用例

 [HSCentralPopView showWithItems:@[@"期待您的宝贵意见",
 @"使用不方便",
 @"积分增值少",
 @"单纯试试",
 @"想要全部申请积分兑换",
 ] action:^(NSInteger index) {
 NSLog(@"点击了第%ld行",index);
 }];

 */
@end
