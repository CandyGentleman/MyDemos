//
//  HSPopBottomView.m
//  底部弹框封装
//
//  Created by 刘鹿杰的mac on 2018/3/21.
//  Copyright © 2018年 刘鹿杰的mac. All rights reserved.
//

#import "HSPopBottomView.h"

#define ScreenWidth [UIScreen mainScreen].bounds.size.width
#define ScreenHeight [UIScreen mainScreen].bounds.size.height

#define TableHeight  (kCellHeight * _tableData.count)
static CGFloat const kCellHeight = 50;


@interface HSPopBottomViewCell : UITableViewCell

@property (nonatomic, strong) UILabel *titleLabel;

@end

@implementation HSPopBottomViewCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        _titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, (kCellHeight - 16)/2 , ScreenWidth, 16)];
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
        self.backgroundColor = [UIColor colorWithWhite:0 alpha:0.1];
    }else {
        self.backgroundColor = [UIColor whiteColor];
    }
}
@end


@interface HSPopBottomView ()<UITableViewDelegate,UITableViewDataSource,UIGestureRecognizerDelegate>

@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) NSArray *tableData;
@property (nonatomic, copy) void(^action)(NSInteger index);

@end

@implementation HSPopBottomView

- (instancetype)initWithItems:(NSArray <NSString *>*)nameArray
                       action:(void(^)(NSInteger index))action{

    if (nameArray.count == 0) return nil;
    if (self == [super init]) {
        self.frame = [UIScreen mainScreen].bounds;
        self.backgroundColor = [UIColor colorWithWhite:0 alpha:0.2];
        self.alpha = 0;
        _tableData = [nameArray copy];
        self.action = action;
        // 添加手势
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tap)];
        tap.delegate = self;
        [self addGestureRecognizer:tap];
        // 创建tableView
        _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0 ,(ScreenHeight - TableHeight), ScreenWidth, TableHeight) style:UITableViewStylePlain];
        _tableView.delegate = self;
        _tableView.dataSource = self;
        _tableView.scrollEnabled = NO;
        _tableView.rowHeight = kCellHeight;
        _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        [_tableView registerClass:[HSPopBottomViewCell class] forCellReuseIdentifier:@"PopMenuTableViewCell"];
        [self addSubview:_tableView];
    }
    return self;
}

+ (void)showWithItems:(NSArray <NSString *>*)nameArray
               action:(void(^)(NSInteger index))action;
{
    HSPopBottomView *view = [[HSPopBottomView alloc] initWithItems:nameArray action:action];
    [view show];
}

- (void)tap {
    [self hide];
}

#pragma mark - UIGestureRecognizerDelegate
- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldReceiveTouch:(UITouch *)touch {
    if ([touch.view isKindOfClass:NSClassFromString(@"UITableViewCellContentView")]) {
        return NO;
    }
    return YES;
}

#pragma mark - show or hide
- (void)show {
    [[UIApplication sharedApplication].keyWindow addSubview:self];
    _tableView.transform = CGAffineTransformMakeTranslation(0, TableHeight);
    [UIView animateWithDuration:0.2 animations:^{
        self.alpha = 1;
        _tableView.transform = CGAffineTransformMakeTranslation(0, 0);
    }];
}

- (void)hide {
    [UIView animateWithDuration:0.2 animations:^{
        self.alpha = 0;
        _tableView.transform = CGAffineTransformMakeTranslation(0, TableHeight);
    } completion:^(BOOL finished) {
        [_tableView removeFromSuperview];
        [self removeFromSuperview];
    }];
}

#pragma mark - UITableViewDataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.tableData.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    HSPopBottomViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"PopMenuTableViewCell" forIndexPath:indexPath];
    cell.titleLabel.text = _tableData[indexPath.row];
    cell.titleLabel.textColor = [UIColor grayColor];
    if ([_tableData[indexPath.row] isEqualToString:@"取消"]) {
        cell.titleLabel.textColor = [UIColor redColor];
    }
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
