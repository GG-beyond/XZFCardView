//
//  UIXZFCardScrollView.h
//  XZFCardScrollView
//
//  Created by anxindeli on 2017/6/20.
//  Copyright © 2017年 anxindeli. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CardViewCell.h"
typedef enum ScrollDirection {
    ScrollDirectionRight,
    ScrollDirectionLeft,
} ScrollDirection;

@class UIXZFCardScrollView;
@protocol UIXZFCardScrollViewDataSource<NSObject>
@required
/*
    cardview
    return 返回个数
 */
- (NSInteger)numberCardScrollView;
/*
    返回对应每一个小cell
 */
- (__kindof CardViewCell *)cardScrollView:(UIXZFCardScrollView *)cardView cellForRowAtIndex:(NSInteger)index;
@end
//===================================================
@protocol UIXZFCardScrollViewDelegate<NSObject>
@optional
/*
    是否可以编辑
 */
- (BOOL)cardScrollView:(UIXZFCardScrollView *)cardView canEditRowAtIndex:(NSInteger)index;
/*
    删除的位置
 */
- (void)deleteRowsAtIndexPaths:(NSArray<NSNumber *> *)indexs;

/*
    每次滑动改变位置
 */
- (void)updateView:(UIView *)view withProgress:(CGFloat)progress scrollDirection:(ScrollDirection)direction;
@end
@interface UIXZFCardScrollView : UIView
@property (nonatomic, weak) id <UIXZFCardScrollViewDataSource> dataSource;
@property (nonatomic, weak) id <UIXZFCardScrollViewDelegate> delegate;
@property (nonatomic, assign) ScrollDirection direction;//滑动方向
@property (nonatomic, strong) NSMutableArray *allViews;//所有子view集合

/*
    重用机制
 */
- (UIView *)dequeueReusableCardViewWithIndex:(NSInteger)index;

/*
    刷新数据
 */
- (void)reloadData;
/*
    跳转到指定位置
 */
- (void)scrollToIndex:(NSInteger)index animated:(BOOL)animated;
@end
