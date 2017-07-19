//
//  CardViewCell.m
//  XZFCardScrollView
//
//  Created by anxindeli on 2017/7/13.
//  Copyright © 2017年 anxindeli. All rights reserved.
//

#import "CardViewCell.h"
static CGFloat swipeHeight = 40;
@interface CardViewCell ()<UIScrollViewDelegate>
@end
@implementation CardViewCell

- (instancetype)initWithFrame:(CGRect)frame{
    if (self = [super initWithFrame:frame]) {
        [self addSubview:self.iconView];
        [self addSubview:self.appThumbImageView];
        self.bounces = YES;
        self.layer.masksToBounds = NO;
        self.delegate = self;
        self.contentSize = CGSizeMake(0, frame.size.height+0.5);

    }
    return self;
}
- (UIView *)iconView{
    
    if (!_appIconView) {
        _appIconView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 200, 60)];
        [_appIconView addSubview:self.appIconImageView];
        [_appIconView addSubview:self.appName];

    }
    return _appIconView;
}
//应用图标icon
- (UIImageView *)appIconImageView{
    if (!_appIconImageView) {
        _appIconImageView = [[UIImageView alloc] initWithFrame:CGRectMake(10, 10, 40, 40)];
        _appIconImageView.layer.cornerRadius = 5.0f;
        _appIconImageView.layer.masksToBounds = YES;
    }
    return _appIconImageView;
}
//应用名称
- (UILabel *)appName{
    if (!_appName) {
        _appName = [[UILabel alloc] initWithFrame:CGRectMake(60, 20, 80, 20)];
        _appName.textColor = [UIColor whiteColor];
        _appName.font = [UIFont systemFontOfSize:14];
    }
    return _appName;
}
#pragma mark - app页面view缩略图
- (UIImageView *)appThumbImageView{
    
    CGFloat width =  CGRectGetWidth(self.bounds);

    if (!_appThumbImageView) {
        _appThumbImageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 60, width, 400)];
        _appThumbImageView.backgroundColor = [UIColor whiteColor];
        _appThumbImageView.layer.cornerRadius = 5;
        //阴影
        _appThumbImageView.layer.shadowColor = [UIColor blackColor].CGColor;
        UIBezierPath *shadowPath = [UIBezierPath bezierPathWithRect:_appThumbImageView.bounds];
        _appThumbImageView.layer.shadowOffset = CGSizeMake(2.0f, 2.0f);
        _appThumbImageView.layer.shadowOpacity = .3;
        _appThumbImageView.layer.shadowPath = shadowPath.CGPath;
        _appThumbImageView.layer.masksToBounds = YES;
        
    }
    return _appThumbImageView;
}
#pragma mark - SETTER
//利用setter方法，填充数据
- (void)setAppInfo:(NSDictionary *)appInfo{
    _appInfo = appInfo;
    
    if (appInfo) {
        _appName.text = appInfo[@"appName"];
        _appThumbImageView.image = [UIImage imageNamed:appInfo[@"appThumb"]];
        _appIconImageView.image = [UIImage imageNamed:appInfo[@"appIcon"]];
    }
    
}
#pragma mark - UIScrollViewDelegate
- (void)scrollViewDidScroll:(UIScrollView *)scrollView{
    
    //滑动距离 和 是否还在拖拽
    if (scrollView.contentOffset.y>swipeHeight&&!scrollView.isDragging) {
        //删除本视图
        if (self.editDelegate&&[self.editDelegate respondsToSelector:@selector(cardViewCellEdit:)]) {
            [self.editDelegate cardViewCellEdit:self];
        }
    }
}
@end
