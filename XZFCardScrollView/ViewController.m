//
//  ViewController.m
//  XZFCardScrollView
//
//  Created by anxindeli on 2017/6/20.
//  Copyright © 2017年 anxindeli. All rights reserved.
//

#import "ViewController.h"
#import "UIXZFCardScrollView.h"
#import "CardViewCell.h"
#define SCREEN_WIDTH [UIScreen mainScreen].bounds.size.width
#define SCREEN_HEIGHT [UIScreen mainScreen].bounds.size.height

@interface ViewController ()<UIXZFCardScrollViewDelegate,UIXZFCardScrollViewDataSource>
@property (nonatomic, strong) NSMutableArray *appDataSource;//数据源
@property (nonatomic, strong) UIXZFCardScrollView *cardScrollView;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self.view addSubview:self.cardScrollView];
}
- (UIXZFCardScrollView *)cardScrollView{
    if (!_cardScrollView) {
        _cardScrollView = [[UIXZFCardScrollView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, CGRectGetHeight(self.view.frame))];
        _cardScrollView.delegate = self;
        _cardScrollView.dataSource = self;
        [_cardScrollView scrollToIndex:self.appDataSource.count animated:YES];
    }
    return _cardScrollView;
}
#pragma mark - UIXZFCardScrollViewDataSource 
- (NSInteger)numberCardScrollView{
    
    return self.appDataSource.count;
}
- (CardViewCell *)cardScrollView:(UIXZFCardScrollView *)cardView cellForRowAtIndex:(NSInteger)index{
    
    CardViewCell *cell = (CardViewCell *)[cardView dequeueReusableCardViewWithIndex:index];
    if (!cell) {
        CGFloat width =  SCREEN_WIDTH / 10 * 7.2;
        cell = [[CardViewCell alloc] initWithFrame:CGRectMake(0, 0, width, 500)];
    }
    cell.tag = index;
    cell.appInfo = self.appDataSource[index];

    return cell;
    
}
- (void)updateView:(UIView *)view withProgress:(CGFloat)progress scrollDirection:(ScrollDirection)direction{
    
    
    if (progress+1>=0) {
        view.alpha = 1;
    }else{
        view.alpha = 1 - fabs(progress+1) * 0.2;
    }
    CGFloat width =  SCREEN_WIDTH / 10 *7.2;
    CGAffineTransform transform = CGAffineTransformIdentity;
    // scale缩放
    CGFloat scale = 1 + (progress) * 0.03;
    transform = CGAffineTransformScale(transform, scale, scale);
    // translate平移
    CGFloat translation = 0;
    if (progress > 0) {
        translation = fabs(progress) * width / 4.0*1.5;
    } else {
        translation = fabs(progress) * width / 8.0;
    }
    
    transform = CGAffineTransformTranslate(transform, translation, 0);
    view.transform = transform;
    
    
}
- (BOOL)cardScrollView:(UIXZFCardScrollView *)cardView canEditRowAtIndex:(NSInteger)index{
    
    return YES;
}
- (void)deleteRowsAtIndexPaths:(NSArray<NSNumber *> *)indexs {
    
    for (int i=0; i<indexs.count; i++) {
        
        NSNumber *number = indexs[i];
        [self.appDataSource removeObjectAtIndex:[number integerValue]];
        
    }
    [self.cardScrollView reloadData];
}
- (NSMutableArray *)appDataSource{
    
    if (!_appDataSource) {
        _appDataSource = [NSMutableArray arrayWithCapacity:10];
        [_appDataSource addObject:@{@"appThumb":@"wx.png",@"appName":@"微信",@"appIcon":@"icon.png"}];
        [_appDataSource addObject:@{@"appThumb":@"zfb.png",@"appName":@"支付宝",@"appIcon":@"icon.png"}];
        [_appDataSource addObject:@{@"appThumb":@"qq.png",@"appName":@"QQ",@"appIcon":@"icon.png"}];
        [_appDataSource addObject:@{@"appThumb":@"wb.png",@"appName":@"微博",@"appIcon":@"icon.png"}];
        [_appDataSource addObject:@{@"appThumb":@"wzry.png",@"appName":@"王者荣耀",@"appIcon":@"icon.png"}];
        [_appDataSource addObject:@{@"appThumb":@"elm.png",@"appName":@"饿了么",@"appIcon":@"icon.png"}];
        [_appDataSource addObject:@{@"appThumb":@"mt.png",@"appName":@"美团外卖",@"appIcon":@"icon.png"}];
        [_appDataSource addObject:@{@"appThumb":@"ofo.png",@"appName":@"ofo共享单车",@"appIcon":@"icon.png"}];
        [_appDataSource addObject:@{@"appThumb":@"mb.png",@"appName":@"摩拜单车",@"appIcon":@"icon.png"}];

    }
    return _appDataSource;
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
