//
//  YPBannerView.m
//  Wuxianda
//
//  Created by MichaelPPP on 16/5/31.
//  Copyright © 2016年 michaelhuyp. All rights reserved.
//

#import "YPBannerView.h"
#import "YPBannerCollectionViewCell.h"

/** 轮播图将要开始拖动发出的通知 */
NSString* const kBannerViewWillBeginDraggingNotification = @"kBannerViewWillBeginDraggingNotification";
/** 轮播图结束滑动发出的通知 */
NSString* const kBannerViewDidEndDeceleratingNotification = @"kBannerViewDidEndDeceleratingNotification";

// 组数
#define kItemGroupCount 4

NSString * const YPBannerCollectionViewCellReuseIdentifier = @"YPBannerCollectionViewCellReuseIdentifier";

@interface YPBannerView () <UICollectionViewDataSource, UICollectionViewDelegate>

/** 轮播图View */
@property (nonatomic, weak) UICollectionView *mainView;

/** 轮播图布局 */
@property (nonatomic, weak) UICollectionViewFlowLayout *flowLayout;

/** 总item的数量 */
@property (nonatomic, assign) NSUInteger totalItemsCount;

/** 轮播定时器 */
@property (nonatomic, weak) NSTimer *timer;

/** 页码控件 */
@property (nonatomic, weak) UIPageControl *mainPageControl;

/** block */
@property (nonatomic, copy) YPBannerViewBlock block;

/** 占位图 */
@property (nonatomic, weak) UIImage *placeholderImage;

@end

@implementation YPBannerView
{
    // item索引
    NSInteger _itemIndex;
}


#pragma mark - Override
- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (!self) return nil;
    [self initialization];
    [self setupUI];
    return self;
}

- (instancetype)initWithCoder:(NSCoder *)aDecoder
{
    self = [super initWithCoder:aDecoder];
    if (!self) return nil;
    [self initialization];
    [self setupUI];
    return self;
}

- (void)initialization
{
    _autoScrollTimeInterval = 5;
}

- (void)setupUI
{
    // Self
    self.backgroundColor = YPMainBgColor;
    
    // FlowLayout
    UICollectionViewFlowLayout *flowLayout = [[UICollectionViewFlowLayout alloc] init];
    _flowLayout = flowLayout;
    flowLayout.minimumLineSpacing = 0;
    flowLayout.scrollDirection = UICollectionViewScrollDirectionHorizontal;
    
    
    // CollectionView
    UICollectionView *mainView = [[UICollectionView alloc] initWithFrame:self.bounds collectionViewLayout:flowLayout];
    _mainView = mainView;
    [self addSubview:mainView];
    mainView.backgroundColor = YPMainBgColor;
    mainView.pagingEnabled = YES;
    mainView.showsVerticalScrollIndicator = NO;
    mainView.showsHorizontalScrollIndicator = NO;
    mainView.scrollsToTop = NO;
    mainView.dataSource = self;
    mainView.delegate = self;
    [mainView registerClass:[YPBannerCollectionViewCell class] forCellWithReuseIdentifier:YPBannerCollectionViewCellReuseIdentifier];
    
    // PageControl
    UIPageControl *mainPageControl = [[UIPageControl alloc] init];
    _mainPageControl = mainPageControl;
    [self addSubview:mainPageControl];
    mainPageControl.hidesForSinglePage = YES;
    mainPageControl.currentPageIndicatorTintColor = YPMainColor;
    mainPageControl.pageIndicatorTintColor = YPWhiteColor;
    mainPageControl.userInteractionEnabled = NO;
    
    [mainPageControl mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(mainPageControl.superview.mas_right).with.offset(-8);
        make.bottom.equalTo(mainPageControl.superview.mas_bottom).with.offset(8);
    }];
    
}





- (void)layoutSubviews
{
    [super layoutSubviews];
    
    _flowLayout.itemSize = self.bounds.size;
    
    _mainView.contentInset = UIEdgeInsetsMake(0, -((_totalItemsCount * 0.5 - 1) * YPScreenW), 0, -((_totalItemsCount * 0.5 - 2) * YPScreenW));
    
    if (_totalItemsCount) {
        NSUInteger targetIndex = _totalItemsCount * 0.5;
        [_mainView scrollToItemAtIndexPath:[NSIndexPath indexPathForItem:targetIndex inSection:0] atScrollPosition:UICollectionViewScrollPositionNone animated:NO];
        [_mainView setContentOffset:CGPointMake(_mainView.contentOffset.x - YPScreenW, 0)];
        _itemIndex = targetIndex;
    }
}


#pragma mark - Public 
+ (instancetype)bannerViewWithFrame:(CGRect)frame placeholderImage:(UIImage *)placeholderImage block:(YPBannerViewBlock)block
{
    YPBannerView *bannerView = [[self alloc] initWithFrame:frame];
    bannerView.block = block;
    bannerView.placeholderImage = placeholderImage;
    return bannerView;
}

#pragma mark - UICollectionViewDataSource
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return _totalItemsCount;
}
- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    YPBannerCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:YPBannerCollectionViewCellReuseIdentifier forIndexPath:indexPath];
    
    NSUInteger itemIndex = indexPath.item % _models.count;
    
    cell.vm = _models[itemIndex];
    
    return cell;
}

#pragma mark - UICollectionViewDelegate

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    if (_block) {
        _block(indexPath.item % _models.count);
    }
}

#pragma mark - UIScrollViewDelegate
- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView
{
    // 发送开始拖拽的通知
    [YPNotificationCenter postNotificationName:kBannerViewWillBeginDraggingNotification object:nil];
    
    // 取消定时器
    [self invalidateTimer];
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    _itemIndex = [self currentIndex];
    
    _mainPageControl.currentPage = [self currentIndex] % _models.count;
}

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView
{
    NSUInteger halfTotalItemsCount = _totalItemsCount * 0.5;
    NSUInteger padding = _itemIndex % (_totalItemsCount / kItemGroupCount);
    CGFloat leftInset = (halfTotalItemsCount + padding - 1) * YPScreenW;  // 1875 2250 2626
    CGFloat rightInset = (halfTotalItemsCount + padding - 1) * YPScreenW - (YPScreenW * (padding * 2 + 1)); // 1500 1125 750
    
    // 根据当前索引变换contentInset
    _mainView.contentInset = UIEdgeInsetsMake(0, -leftInset, 0, -rightInset);
    
    // 结束滑动应该 默认滚动到中间位置
    NSUInteger targetIndex = _totalItemsCount * 0.5;
    [_mainView scrollToItemAtIndexPath:[NSIndexPath indexPathForItem:targetIndex inSection:0] atScrollPosition:UICollectionViewScrollPositionNone animated:NO];
    [_mainView setContentOffset:CGPointMake(_mainView.contentOffset.x - YPScreenW, 0)];
    
    
    // 发送结束滚动的通知
    [YPNotificationCenter postNotificationName:kBannerViewDidEndDeceleratingNotification object:nil];
    
    // 设置定时器
    [self setupTimerWithTimeInterval:_autoScrollTimeInterval];
    
}

#pragma mark - Setter

- (void)setModels:(NSArray *)models
{
    _models = models;
    
    // 停止计时器器
    [self invalidateTimer];
    
    // 重新计算数据源
    _totalItemsCount = models.count * kItemGroupCount;
    _mainPageControl.numberOfPages = models.count;

    // 刷新页面
    [_mainView reloadData];
    [self setNeedsLayout];
    
    if (_models.count <= 1) {
        _mainView.scrollEnabled = NO;
    } else {
        _mainView.scrollEnabled = YES;
        // 开启定时器
        [self setupTimerWithTimeInterval:_autoScrollTimeInterval];
    }
}


#pragma mark - Private
- (void)setupTimerWithTimeInterval:(NSTimeInterval)timeInterval
{
    NSTimer *timer = [NSTimer scheduledTimerWithTimeInterval:timeInterval target:self selector:@selector(automaticScroll) userInfo:nil repeats:YES];
    _timer = timer;
    
    /**
     *  NSDefaultRunLoopMode 滚动视图的模式无效
     *  UITrackingRunLoopMode 滚动视图的模式才有效
     *  NSRunLoopCommonModes 两者兼容
     */
    [[NSRunLoop mainRunLoop] addTimer:timer forMode:NSDefaultRunLoopMode];
}



- (void)invalidateTimer
{
    [_timer invalidate];
    _timer = nil;
}


- (void)automaticScroll
{
    if (0 == _totalItemsCount) return;
    
    
    _mainView.contentInset = UIEdgeInsetsMake(0, 0, 0, 0);
    
    NSUInteger currentIndex = [self currentIndex];
    NSUInteger targetIndex = currentIndex + 1;
    if (targetIndex >= _totalItemsCount) {
        targetIndex = _totalItemsCount * 0.5;
        [_mainView scrollToItemAtIndexPath:[NSIndexPath indexPathForItem:targetIndex - 1 inSection:0] atScrollPosition:UICollectionViewScrollPositionNone animated:NO];
        // 立即调用定时器
        [_timer fire];
        return;
    }
    [_mainView scrollToItemAtIndexPath:[NSIndexPath indexPathForItem:targetIndex inSection:0] atScrollPosition:UICollectionViewScrollPositionNone animated:YES];
    
}

- (NSUInteger)currentIndex
{
    if (_mainView.width == 0 || _mainView.height == 0) {
        return 0;
    }
    NSUInteger index = 0;
    index = (_mainView.contentOffset.x + _flowLayout.itemSize.width * 0.5) / _flowLayout.itemSize.width;
    return MAX(0, index);
}

@end


















































