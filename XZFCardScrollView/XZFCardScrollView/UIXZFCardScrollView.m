//
//  UIXZFCardScrollView.m
//  XZFCardScrollView
//
//  Created by anxindeli on 2017/6/20.
//  Copyright © 2017年 anxindeli. All rights reserved.
//

#import "UIXZFCardScrollView.h"
#define SCREEN_WIDTH [UIScreen mainScreen].bounds.size.width
#define SCREEN_HEIGHT [UIScreen mainScreen].bounds.size.height

static NSInteger visibleNum = 5;//不重用的最大个数，即可以看到4个，1个多出来用于切换时

@interface UIXZFCardScrollView ()<UIScrollViewDelegate,CardViewCellEditDelegate>
{
    CGFloat currentContent_x;//当前滚动的x偏移量，用于判断方向（左右滑动）
    NSInteger currentIndex;//当前展示的view的index。
    NSInteger allCount;//cell的总个数
}
@property (nonatomic, strong) UIImageView *wallpaperImageView;//背景壁纸，用于毛玻璃化
@property (nonatomic, strong) UIScrollView *bgScrollView;
@end

@implementation UIXZFCardScrollView

- (instancetype)initWithFrame:(CGRect)frame{
    
    if (self = [super initWithFrame:frame]) {
        
        self.backgroundColor = [UIColor whiteColor];
        [self addSubview:self.wallpaperImageView];
        [self addSubview:self.bgScrollView];
        self.allViews = [NSMutableArray array];
    }
    return self;
}
- (UIImageView *)wallpaperImageView{
    
    if (!_wallpaperImageView) {
        _wallpaperImageView = [[UIImageView alloc] initWithFrame:self.bounds];
        _wallpaperImageView.image = [UIImage imageNamed:@"wallpaper.jpg"];
//        毛玻璃效果
        UIBlurEffect *effect = [UIBlurEffect effectWithStyle:UIBlurEffectStyleLight];
        UIVisualEffectView *effectView = [[UIVisualEffectView alloc] initWithEffect:effect];
        effectView.frame = _wallpaperImageView.bounds;
        [_wallpaperImageView addSubview:effectView];

    }
    return _wallpaperImageView;
}
#pragma mark - bgScrollView
//背景可横向滑动的scrollView，card布局的背景。
- (UIScrollView *)bgScrollView{
    
    if (!_bgScrollView) {
        _bgScrollView = [[UIScrollView alloc] initWithFrame:self.bounds];
        _bgScrollView.delegate = self;
        _bgScrollView.pagingEnabled = YES;
        _bgScrollView.autoresizingMask = UIViewAutoresizingFlexibleHeight|UIViewAutoresizingFlexibleHeight;
        _bgScrollView.showsHorizontalScrollIndicator=NO;
        _bgScrollView.showsVerticalScrollIndicator=NO;
        _bgScrollView.directionalLockEnabled = YES;
        _bgScrollView.backgroundColor = [UIColor clearColor];
    }
    return _bgScrollView;
    
}
#pragma mark - 重用
//
- (__kindof CardViewCell *)dequeueReusableCardViewWithIndex:(NSInteger)index{

    return nil;
    if (index<=visibleNum) {
        return nil;
    }
    
    NSInteger tempTeg = index % visibleNum;//取余
    CardViewCell *cell = self.bgScrollView.subviews[tempTeg];
    cell.editDelegate = self;
    return cell;
    
}
#pragma mark - 刷新数据
- (void)reloadData{
    
    //移除之前的所有子view
    for (UIView *view in self.bgScrollView.subviews) {
        
        [view removeFromSuperview];
        [self.allViews removeAllObjects];
    }
    
    allCount = [self.dataSource numberCardScrollView];
    CGFloat viewWidth = SCREEN_WIDTH / 10 * 7.2;
    CGFloat width = allCount*viewWidth/2.0+SCREEN_WIDTH - viewWidth/2.0;
    _bgScrollView.contentSize = CGSizeMake(width, 0);
//    allCount = MIN(allCount, visibleNum);

    //创建新的子view,从右往左创建，还要将view bring到最上层
    for (int i=0; i<allCount; i++) {
        
        CardViewCell *cell = [self.dataSource cardScrollView:self cellForRowAtIndex:i];
        cell.editDelegate = self;
        cell.center = [self centerForViewAtIndex:i+1];

        [self.allViews addObject:cell];
        [self.bgScrollView addSubview:cell];
        CGFloat percent = (cell.center.x - (_bgScrollView.contentSize.width-SCREEN_WIDTH/2.0))/(viewWidth/2.0);
        [self.delegate updateView:cell withProgress:percent scrollDirection:self.direction];

    }
    
}

- (CGPoint)centerForViewAtIndex:(NSInteger)index
{
    CGFloat viewWidth = SCREEN_WIDTH / 10 * 7.2;
    CGFloat y = CGRectGetMidY(self.bounds);
    CGFloat x = (self.bgScrollView.contentSize.width*2 - SCREEN_WIDTH)/2 - viewWidth/2*(allCount - index);
    return CGPointMake(x, y);
}
- (CGPoint)contentOffsetForIndex:(NSInteger)index
{
    CGFloat viewWidth = SCREEN_WIDTH / 10 * 7.2;

    CGFloat x = self.bgScrollView.contentSize.width- SCREEN_WIDTH - viewWidth/2*(allCount - index);
    return CGPointMake(x, 0);
}
#pragma mark - 跳到指定的位置
- (void)scrollToIndex:(NSInteger)index animated:(BOOL)animated{
    
    [_bgScrollView setContentOffset:[self contentOffsetForIndex:index] animated:animated];//跳转到最末尾位置

}
#pragma mark - SETTer && Getter
- (void)setDataSource:(id<UIXZFCardScrollViewDataSource>)dataSource{
    
    _dataSource = dataSource;
    [self reloadData];
    
}
- (void)setDelegate:(id<UIXZFCardScrollViewDelegate>)delegate{
    
    _delegate = delegate;
}
#pragma mark - ScrollViewDelegate
- (void)scrollViewWillBeginDecelerating:(UIScrollView *)scrollView{//开始减速
    CGPoint offset = scrollView.contentOffset;
    CGFloat viewWidth = SCREEN_WIDTH / 10 * 7.2/2.0;
    if (offset.x>0&&offset.x<=scrollView.contentSize.width-SCREEN_WIDTH) {
        CGPoint point = CGPointMake(viewWidth*round(offset.x/viewWidth), 0);
        [scrollView setContentOffset:point animated:YES];

    }
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView{
    
    CGFloat viewWidth = SCREEN_WIDTH / 10 * 7.2;

    for (UIView *view in self.bgScrollView.subviews) {
        
        CGFloat percent = (view.center.x - scrollView.contentOffset.x-SCREEN_WIDTH/2.0)/(viewWidth/2.0);
        if (self.delegate && [self.delegate respondsToSelector:@selector(updateView:withProgress:scrollDirection:)]) {
            
            if (currentContent_x>=scrollView.contentOffset.x) {
                self.direction = ScrollDirectionLeft;
            }else{
                self.direction = ScrollDirectionRight;
            }
            NSLog(@"1=========%f",percent);

            [self.delegate updateView:view withProgress:percent scrollDirection:self.direction];
            
        }
    }
    
    currentContent_x = scrollView.contentOffset.x;

}
#pragma mark - CardViewEditDelegate
- (void)cardViewCellEdit:(CardViewCell *)cell{
    
    NSInteger index = [self.allViews indexOfObject:cell];
    BOOL isEdit = [self.delegate cardScrollView:self canEditRowAtIndex:index];
    if (isEdit) {
        [UIView animateWithDuration:0.25 animations:^{
            
            cell.frame = CGRectMake(CGRectGetMinX(cell.frame), -SCREEN_HEIGHT, SCREEN_WIDTH, SCREEN_HEIGHT);
            
        } completion:^(BOOL finished) {
//            [self.allViews removeObject:cell];
//            [cell removeFromSuperview];

            
            if (finished && self.delegate && [self.delegate respondsToSelector:@selector(deleteRowsAtIndexPaths:)]) {
                [self.delegate deleteRowsAtIndexPaths:[NSArray arrayWithObject:[NSNumber numberWithInteger:index]]];
            }

            
        }];
//        [_bgScrollView setContentOffset:CGPointMake(width - SCREEN_WIDTH, 0) animated:NO];//跳转到最末尾位置
    }
    
    
}
@end
