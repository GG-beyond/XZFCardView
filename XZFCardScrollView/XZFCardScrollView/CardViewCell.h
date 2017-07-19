//
//  CardViewCell.h
//  XZFCardScrollView
//
//  Created by anxindeli on 2017/7/13.
//  Copyright © 2017年 anxindeli. All rights reserved.
//

#import <UIKit/UIKit.h>
@class CardViewCell;
@protocol CardViewCellEditDelegate<NSObject>
- (void)cardViewCellEdit:(CardViewCell *)cell;
@end
@interface CardViewCell : UIScrollView
@property (nonatomic, strong) NSDictionary *appInfo;//app相关数据
@property (nonatomic, strong) UIView *appIconView;//整个iconview
@property (nonatomic, strong) UIImageView *appIconImageView;//app图标
@property (nonatomic, strong) UILabel *appName;//app名称
@property (nonatomic, strong) UIImageView *appThumbImageView;//app页面缩略图
@property (nonatomic, assign) id<CardViewCellEditDelegate> editDelegate;

@end
