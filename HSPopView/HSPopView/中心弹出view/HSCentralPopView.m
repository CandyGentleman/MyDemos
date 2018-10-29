//
//  HSCentralPopView.m
//  底部弹框封装
//
//  Created by 刘鹿杰的mac on 2018/3/22.
//  Copyright © 2018年 刘鹿杰的mac. All rights reserved.
//

#import "HSCentralPopView.h"

#define ScreenWidth [UIScreen mainScreen].bounds.size.width
#define ScreenHeight [UIScreen mainScreen].bounds.size.height

static CGFloat const kCellHeight = 50;
#define KContentViewHeight  ((kCellHeight * _tableData.count) + 80)
#define KContentViewWidth  (ScreenWidth * 0.8)


@interface HSCentralPopViewCell :UITableViewCell
@property (nonatomic, strong) UILabel *titleLabel;
@end

@implementation HSCentralPopViewCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        _titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, (kCellHeight - 16)/2 , KContentViewWidth, 16)];
        _titleLabel.font = [UIFont systemFontOfSize:15];
        _titleLabel.textAlignment = NSTextAlignmentCenter;
        // 添加分界线
        UIView *lineView = [[UIView alloc] initWithFrame:CGRectMake(0, kCellHeight - 1, ScreenWidth, 1)];
        lineView.backgroundColor = [UIColor colorWithRed:242/255.0 green:242/255.0 blue:242/255.0 alpha:1];
        [self.contentView addSubview:lineView];
        [self.contentView addSubview:_titleLabel];
    }
    return self;
}

- (void)setHighlighted:(BOOL)highlighted animated:(BOOL)animated {
    [super setHighlighted:highlighted animated:animated];
    if (highlighted) {
//        self.backgroundColor = [UIColor colorWithWhite:0 alpha:0.1];
        self.titleLabel.textColor = [UIColor redColor];

    }else {
//        self.backgroundColor = [UIColor whiteColor];
        self.titleLabel.textColor = [UIColor grayColor];
    }
}
@end

@interface HSCentralPopView ()<UITableViewDelegate,UITableViewDataSource>

@property (nonatomic, strong) UIView *contentView;
@property (nonatomic, strong) NSArray *tableData;
@property (nonatomic, copy) void(^action)(NSInteger index);

@end



@implementation HSCentralPopView

- (instancetype)initWithItems:(NSArray <NSString *>*)nameArray
                       action:(void(^)(NSInteger index))action{

    if (nameArray.count == 0) return nil;
    if (self == [super init]) {
        self.frame = [UIScreen mainScreen].bounds;
        self.backgroundColor = [UIColor colorWithWhite:0 alpha:0.4];
        self.alpha = 0;
        _tableData = [nameArray copy];
        self.action = action;

        // 中心的View
        _contentView = [[UIView alloc] initWithFrame:CGRectMake((ScreenWidth - KContentViewWidth) / 2, (ScreenHeight - KContentViewHeight)/2, KContentViewWidth, KContentViewHeight)];
        // 创建tableView
        UITableView *tableView = [[UITableView alloc] initWithFrame:CGRectMake(0,0, KContentViewWidth, (kCellHeight * _tableData.count)) style:UITableViewStylePlain];
        UILabel *titlelabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, KContentViewWidth, 50)];
        titlelabel.textAlignment = NSTextAlignmentCenter;
        titlelabel.text = nameArray.firstObject;
        titlelabel.textColor = [UIColor grayColor];
        titlelabel.backgroundColor = [UIColor colorWithRed:242/255.0 green:242/255.0 blue:242/255.0 alpha:1];
        tableView.tableHeaderView = titlelabel;
        tableView.delegate = self;
        tableView.dataSource = self;
        tableView.scrollEnabled = NO;
        tableView.layer.masksToBounds = YES;
        tableView.layer.cornerRadius = 10;
        tableView.rowHeight = kCellHeight;
        tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        [tableView registerClass:[HSCentralPopViewCell class] forCellReuseIdentifier:@"HSCentralPopViewCell"];
        [_contentView addSubview:tableView];

        // 删除btn
        UIButton *cancleBtn = [[UIButton alloc] initWithFrame:CGRectMake((KContentViewWidth - 30) / 2 , KContentViewHeight - 30, 30, 30)];
        [cancleBtn addTarget:self action:@selector(hide) forControlEvents:UIControlEventTouchUpInside];
        [cancleBtn setImage:[UIImage imageNamed:@"icon-shanchu"] forState:UIControlStateNormal];
        [_contentView addSubview:cancleBtn];

        [self addSubview:_contentView];
    }
    return self;
}

+ (void)showWithItems:(NSArray <NSString *>*)nameArray
               action:(void(^)(NSInteger index))action;
{
    HSCentralPopView *view = [[HSCentralPopView alloc] initWithItems:nameArray action:action];
    [view show];
}

#pragma mark - show or hide
- (void)show {
    [[UIApplication sharedApplication].keyWindow addSubview:self];

    _contentView.transform = CGAffineTransformMakeScale(0.0001, 0.0001);
    [UIView animateWithDuration:0.2 animations:^{
        self.alpha = 1;
         _contentView.transform = CGAffineTransformMakeScale(1, 1);
    }];
}

- (void)hide {
    [UIView animateWithDuration:0.2 animations:^{
        self.alpha = 0;
        _contentView.transform = CGAffineTransformMakeScale(0, 0);
    } completion:^(BOOL finished) {
        [_contentView removeFromSuperview];
        [self removeFromSuperview];
    }];
}

#pragma mark - UITableViewDataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.tableData.count - 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    HSCentralPopViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"HSCentralPopViewCell" forIndexPath:indexPath];
    cell.titleLabel.text = _tableData[indexPath.row + 1];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [self hide];
    if (_action) {
        _action(indexPath.row);
    }
}

@end
