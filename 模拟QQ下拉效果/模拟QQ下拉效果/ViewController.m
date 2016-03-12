//
//  ViewController.m
//  模拟QQ下拉效果
//
//  Created by 刘鹿杰 on 16/2/20.
//  Copyright © 2016年 刘鹿杰. All rights reserved.
//

#import "ViewController.h"
#import "UIImage+Image.h"

#define ImgaeViewH 230
#define tabBarH 44
#define naviBarH 64

@interface ViewController ()<UITableViewDelegate, UITableViewDataSource>

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *ViewheightH;

@property (weak, nonatomic) IBOutlet UITableView *tableView;

@property(nonatomic, assign)CGFloat lastOffsety;

@property(nonatomic, weak)UILabel * label;


@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
 
    self.tableView.delegate = self;
    self.tableView.dataSource = self;


    _lastOffsety = -(ImgaeViewH + tabBarH);
    
    self.tableView.contentInset = UIEdgeInsetsMake(ImgaeViewH + tabBarH, 0, 0, 0);
    
    // 是否自动调整contentInset
    self.automaticallyAdjustsScrollViewInsets = NO;
    
    [self.navigationController.navigationBar setBackgroundImage:[[UIImage alloc] init] forBarMetrics:UIBarMetricsDefault];
    
    // 设置navigationBar底部的图片
    [self.navigationController.navigationBar setShadowImage:[[UIImage alloc] init]];
    
    UILabel * label = [[UILabel alloc] init];
    label.text = @"我的空间";
    [label sizeToFit];
    self.navigationItem.titleView = label;
    self.label = label;
    
    label.alpha = 0;

}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 100;
}


-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
   static NSString *ID = @"cellID";
    
    UITableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:ID];
    
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:ID];
        cell.backgroundColor = [UIColor redColor];
    }

    cell.textLabel.text = [NSString stringWithFormat:@"%ld",(long)indexPath.row];
    
    return cell;
    
}

-(void)scrollViewDidScroll:(UIScrollView *)scrollView{
    
   CGFloat offset = scrollView.contentOffset.y;
   
   CGFloat hight =  offset - _lastOffsety;
    
//   NSLog(@"%f",hight);
    
// 往上拖动，高度减少。
   CGFloat viewCurentH = ImgaeViewH - hight;
    
    if (viewCurentH < naviBarH) {
        viewCurentH = naviBarH;
    }
    
     self.ViewheightH.constant = viewCurentH;
    
      CGFloat alpha =  hight / (ImgaeViewH - viewCurentH);
    NSLog(@"%f",alpha);
    
    // 当alpha大于1，导航条半透明，因此做处理，大于1，就直接=0.99
    if (alpha > 1) {
        alpha = 0.99;
    }
    _label.alpha = alpha;
    
     UIImage *image = [UIImage imageWithColor:[UIColor colorWithWhite:1 alpha:alpha]];
    
    [self.navigationController.navigationBar setBackgroundImage:image forBarMetrics:UIBarMetricsDefault];
    
}


@end
