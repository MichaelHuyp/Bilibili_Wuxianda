//
//  YZDisplayViewController.m
//  BuDeJie
//
//  Created by yz on 15/12/1.
//  Copyright © 2015年 yz. All rights reserved.
//

#import "YZDisplayViewController.h"
#import "YZDisplayTitleLabel.h"
#import "YZDisplayViewHeader.h"
#import "YZFlowLayout.h"

@interface YZDisplayViewController ()<UICollectionViewDataSource,UICollectionViewDelegate>

/** 整体内容View 包含标题和内容滚动视图 */
@property (nonatomic, weak) UIView *contentView;

/** 标题滚动视图 */
@property (nonatomic, weak) UIScrollView *titleScrollView;

/** 内容滚动视图 */
@property (nonatomic, weak) UICollectionView *contentScrollView;

/** 所以标题数组 */
@property (nonatomic, strong) NSMutableArray *titleLabels;

/** 所以标题宽度数组 */
@property (nonatomic, strong) NSMutableArray *titleWidths;

/** 下标视图 */
@property (nonatomic, weak) UIView *underLine;

/** 标题遮盖视图 */
@property (nonatomic, weak) UIView *coverView;

/** 记录上一次内容滚动视图偏移量 */
@property (nonatomic, assign) CGFloat lastOffsetX;

/** 记录是否点击 */
@property (nonatomic, assign) BOOL isClickTitle;

/** 记录是否在动画 */
@property (nonatomic, assign) BOOL isAniming;

/* 是否初始化 */
@property (nonatomic, assign) BOOL isInitial;

/** 标题间距 */
@property (nonatomic, assign) CGFloat titleMargin;

/** 计算上一次选中角标 */
@property (nonatomic, assign) NSInteger selIndex;

#pragma mark YPAddStart
/** 底部的线 */
@property (nonatomic, weak) UIView *bottomLine;
#pragma mark YPAddEnd

@end

@implementation YZDisplayViewController

#pragma mark - 初始化方法

- (instancetype)init
{
    if (self = [super init]) {
        [self initial];
    }
    return self;
}

- (void)awakeFromNib
{
    [self initial];
    
}

- (void)initial
{
    // 初始化标题高度
    _titleHeight = YZTitleScrollViewH;
    
    // 初始化是否平分宽度的属性(标题平分+下划线平分)
    _isBisectedWidthUnderLineAndTitle = NO;
    
    // 是否禁止contentView的滚动效果
    _isBanContentViewScroll = NO;
    
    self.automaticallyAdjustsScrollViewInsets = NO;
}

- (void)setUp
{
    if (_isShowTitleGradient && _titleColorGradientStyle == YZTitleColorGradientStyleRGB) {
        
        // 初始化颜色渐变
        if (_endR == 0 && _endG == 0 && _endB == 0) {
            _endR = 1;
        }
    }
}


#pragma mark - 懒加载

#pragma mark YPAddStart

- (UIView *)bottomLine
{
    if (!_bottomLine) {
        
        UIView *bottomLine = [[UIView alloc] init];
        
        bottomLine.backgroundColor = YPMainLineColor;
        
        [self.titleScrollView addSubview:bottomLine];
        
        _bottomLine = bottomLine;
    }
    return _bottomLine;
}

#pragma mark YPAddEnd

- (UIFont *)titleFont
{
    if (_titleFont == nil) {
        _titleFont = YZTitleFont;
    }
    return _titleFont;
}


- (NSMutableArray *)titleWidths
{
    if (_titleWidths == nil) {
        _titleWidths = [NSMutableArray array];
    }
    return _titleWidths;
}

- (UIColor *)norColor
{
    if (_isShowTitleGradient && _titleColorGradientStyle == YZTitleColorGradientStyleRGB) {
         _norColor = [UIColor colorWithRed:_startR green:_startG blue:_startB alpha:1];
    }
    
    if (_norColor == nil){
        _norColor = [UIColor blackColor];
    }
    
    
    return _norColor;
}

- (UIColor *)selColor
{
    if (_isShowTitleGradient && _titleColorGradientStyle == YZTitleColorGradientStyleRGB) {
        _selColor = [UIColor colorWithRed:_endR green:_endG blue:_endB alpha:1];
    }
    
    if (_selColor == nil) _selColor = [UIColor redColor];
    
    return _selColor;
}

- (UIView *)coverView
{
    if (_coverView == nil) {
        UIView *coverView = [[UIView alloc] init];
        
        coverView.backgroundColor = _coverColor?_coverColor:[UIColor lightGrayColor];
        
        coverView.layer.cornerRadius = _coverCornerRadius;
        
        [self.titleScrollView insertSubview:coverView atIndex:0];
        
        _coverView = coverView;
    }
    return _isShowTitleCover?_coverView:nil;
}

- (UIView *)underLine
{
    if (_underLine == nil) {
        
        UIView *underLineView = [[UIView alloc] init];
        
        underLineView.backgroundColor = _underLineColor?_underLineColor:[UIColor redColor];
        
        [self.titleScrollView addSubview:underLineView];
        
        _underLine = underLineView;
        
    }
    return _isShowUnderLine?_underLine : nil;
}

- (NSMutableArray *)titleLabels
{
    if (_titleLabels == nil) {
        _titleLabels = [NSMutableArray array];
    }
    return _titleLabels;
}

// 懒加载标题滚动视图
- (UIScrollView *)titleScrollView
{
    if (_titleScrollView == nil) {
        
        UIScrollView *titleScrollView = [[UIScrollView alloc] init];
#pragma mark YPAdd
        titleScrollView.scrollsToTop = NO;
        
        titleScrollView.backgroundColor = _titleScrollViewColor?_titleScrollViewColor:[UIColor colorWithWhite:1 alpha:0.7];
        
        if (_isBisectedWidthUnderLineAndTitle) {
            titleScrollView.bounces = NO;
        }
        
        [self.contentView addSubview:titleScrollView];
        
        _titleScrollView = titleScrollView;
        
    }
    return _titleScrollView;
}

// 懒加载内容滚动视图
- (UIScrollView *)contentScrollView
{
    if (_contentScrollView == nil) {

        // 创建布局
        YZFlowLayout *layout = [[YZFlowLayout alloc] init];
        
        UICollectionView *contentScrollView = [[UICollectionView alloc] initWithFrame:CGRectZero collectionViewLayout:layout];
        _contentScrollView = contentScrollView;
        // 设置内容滚动视图
        _contentScrollView.pagingEnabled = YES;
        _contentScrollView.showsHorizontalScrollIndicator = NO;
        _contentScrollView.bounces = NO;
        _contentScrollView.delegate = self;
        _contentScrollView.dataSource = self;
#pragma mark YPAdd
        _contentScrollView.scrollsToTop = NO;
        [self.contentView insertSubview:contentScrollView belowSubview:self.titleScrollView];
        
    }
    
    return _contentScrollView;
}

// 懒加载整个内容view
- (UIView *)contentView
{
    if (_contentView == nil) {
        
        UIView *contentView = [[UIView alloc] init];
        _contentView = contentView;
        [self.view addSubview:contentView];
        
    }
    
    return _contentView;
}



#pragma mark - 属性setter方法
- (void)setIsShowTitleScale:(BOOL)isShowTitleScale
{
    if (_isShowUnderLine) {
        // 抛异常
        NSException *excp = [NSException exceptionWithName:@"YZDisplayViewControllerException" reason:@"字体放大效果和角标不能同时使用。" userInfo:nil];
        [excp raise];
    }
    
    _isShowTitleScale = isShowTitleScale;
}

- (void)setIsShowUnderLine:(BOOL)isShowUnderLine
{
    if (_isShowTitleScale) {
        // 抛异常
        NSException *excp = [NSException exceptionWithName:@"YZDisplayViewControllerException" reason:@"字体放大效果和角标不能同时使用。" userInfo:nil];
        [excp raise];
    }
    
    _isShowUnderLine = isShowUnderLine;
}

- (void)setTitleScrollViewColor:(UIColor *)titleScrollViewColor
{
    _titleScrollViewColor = titleScrollViewColor;
    
    self.titleScrollView.backgroundColor = titleScrollViewColor;
}

- (void)setIsfullScreen:(BOOL)isfullScreen
{
    _isfullScreen = isfullScreen;
    
    self.contentView.frame = CGRectMake(0, 0, YZScreenW, YZScreenH);
    
}

// 设置整体内容的尺寸
- (void)setUpContentViewFrame:(void (^)(UIView *))contentBlock
{
    if (contentBlock) {
        contentBlock(self.contentView);
    }
}

// 一次性设置所有颜色渐变属性
- (void)setUpTitleGradient:(void (^)(BOOL *, YZTitleColorGradientStyle *, CGFloat *, CGFloat *, CGFloat *, CGFloat *, CGFloat *, CGFloat *))titleGradientBlock
{
    if (titleGradientBlock) {
        titleGradientBlock(&_isShowTitleGradient,&_titleColorGradientStyle,&_startR,&_startG,&_startB,&_endR,&_endG,&_endB);
    }
}

// 一次性设置所有遮盖属性
- (void)setUpCoverEffect:(void (^)(BOOL *, UIColor **, CGFloat *))coverEffectBlock
{
    UIColor *color;
    
    if (coverEffectBlock) {
        
        coverEffectBlock(&_isShowTitleCover,&color,&_coverCornerRadius);
        
        if (color) {
            _coverColor = color;
        }
        
    }
}

// 一次性设置所有字体缩放属性
- (void)setUpTitleScale:(void(^)(BOOL *isShowTitleScale,CGFloat *titleScale))titleScaleBlock
{
    if (titleScaleBlock) {
        titleScaleBlock(&_isShowTitleScale,&_titleScale);
    }
}

// 一次性设置所有下标属性
- (void)setUpUnderLineEffect:(void(^)(BOOL *isShowUnderLine,BOOL *isDelayScroll,CGFloat *underLineH,UIColor **underLineColor))underLineBlock
{
    UIColor *underLineColor;
    
    if (underLineBlock) {
        underLineBlock(&_isShowUnderLine,&_isDelayScroll,&_underLineH,&underLineColor);
        
        _underLineColor = underLineColor;
    }
    
}

// 一次性设置所有标题属性
- (void)setUpTitleEffect:(void(^)(UIColor **titleScrollViewColor,UIColor **norColor,UIColor **selColor,UIFont **titleFont,CGFloat *titleHeight))titleEffectBlock{
    UIColor *titleScrollViewColor;
    UIColor *norColor;
    UIColor *selColor;
    UIFont *titleFont;
    if (titleEffectBlock) {
        titleEffectBlock(&titleScrollViewColor,&norColor,&selColor,&titleFont,&_titleHeight);
        _norColor = norColor;
        _selColor = selColor;
        _titleScrollViewColor = titleScrollViewColor;
        _titleFont = titleFont;
    }
}

#pragma mark YPAddStart
- (void)setIsBanContentViewScroll:(BOOL)isBanContentViewScroll
{
    _isBanContentViewScroll = isBanContentViewScroll;
    
    self.contentScrollView.scrollEnabled = !_isBanContentViewScroll;
}
#pragma mark YPAddEnd


#pragma mark - 控制器view生命周期方法

- (void)viewDidLayoutSubviews
{
    [super viewDidLayoutSubviews];
    
    CGFloat contentY = self.navigationController?YZNavBarH : [UIApplication sharedApplication].statusBarFrame.size.height;
    CGFloat contentW = YZScreenW;
    CGFloat contentH = YZScreenH - contentY;
    // 设置整个内容的尺寸
    if (self.contentView.height == 0) {
        // 没有设置内容尺寸，才需要设置内容尺寸
        self.contentView.frame = CGRectMake(0, contentY, contentW, contentH);
    }
    
    // 设置标题滚动视图frame
    // 计算尺寸
    CGFloat titleH = _titleHeight?_titleHeight:YZTitleScrollViewH;
    CGFloat titleY = _isfullScreen?contentY:0;
    self.titleScrollView.frame = CGRectMake(0, titleY, contentW, titleH);

    // 设置内容滚动视图frame
    CGFloat contentScrollY = CGRectGetMaxY(self.titleScrollView.frame);
    self.contentScrollView.frame = _isfullScreen?CGRectMake(0, 0, contentW, YZScreenH) :CGRectMake(0, contentScrollY, contentW, self.contentView.height - contentScrollY);
    
#pragma mark YPAddStart
    // 设置底部的线
    self.bottomLine.frame = CGRectMake(0, self.underLine.bottom - 0.5, self.titleScrollView.width, 0.5);
#pragma mark YPAddEnd

}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    if (_isInitial == NO) {
        
         _isInitial = YES;
        
        // 注册cell
        [self.contentScrollView registerClass:[UICollectionViewCell class] forCellWithReuseIdentifier:ID];
        self.contentScrollView.backgroundColor = self.view.backgroundColor;
        
        // 初始化
        [self setUp];
        
        // 没有子控制器，不需要设置标题
        if (self.childViewControllers.count == 0) return;
        
        [self setUpTitleWidth];
        
        [self setUpAllTitle];
        
    }
    
    
}

#pragma mark - 添加标题方法
// 计算所有标题宽度
- (void)setUpTitleWidth
{
    // 判断是否能占据整个屏幕
    NSUInteger count = self.childViewControllers.count;
    
    NSArray *titles = [self.childViewControllers valueForKeyPath:@"title"];
    
    CGFloat totalWidth = 0;
    
    // 计算所有标题的宽度
    for (NSString *title in titles) {
        
        if ([title isKindOfClass:[NSNull class]]) {
            // 抛异常
            NSException *excp = [NSException exceptionWithName:@"YZDisplayViewControllerException" reason:@"没有设置Controller.title属性，应该把子标题保存到对应子控制器中" userInfo:nil];
            [excp raise];
            
        }
        
        CGRect titleBounds = [title boundingRectWithSize:CGSizeMake(MAXFLOAT, 0) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:self.titleFont} context:nil];
        
        CGFloat width = titleBounds.size.width;
        
        [self.titleWidths addObject:@(width)];
        
        totalWidth += width;
    }
    
    if (totalWidth > YZScreenW) {
        
        _titleMargin = margin;
        
        if (_isBisectedWidthUnderLineAndTitle) {
            self.titleScrollView.contentInset = UIEdgeInsetsMake(0, 0, 0, 0);
        } else {
            self.titleScrollView.contentInset = UIEdgeInsetsMake(0, 0, 0, _titleMargin);
        }
        
        return;
    }
    
    CGFloat titleMargin = (YZScreenW - totalWidth) / (count + 1);
    
    _titleMargin = titleMargin < margin? margin: titleMargin;
    
    if (_isBisectedWidthUnderLineAndTitle) {
        self.titleScrollView.contentInset = UIEdgeInsetsMake(0, 0, 0, 0);
    } else {
        self.titleScrollView.contentInset = UIEdgeInsetsMake(0, 0, 0, _titleMargin);
    }
}


// 设置所有标题
- (void)setUpAllTitle
{
    
    // 遍历所有的子控制器
    NSUInteger count = self.childViewControllers.count;
    
    // 添加所有的标题
    CGFloat labelW = 0;
    CGFloat labelH = self.titleHeight;
    CGFloat labelX = 0;
    CGFloat labelY = 0;
    
    for (int i = 0; i < count; i++) {
        
        UIViewController *vc = self.childViewControllers[i];
        
        UILabel *label = [[YZDisplayTitleLabel alloc] init];
        
        label.tag = i;
        
        // 设置按钮的文字颜色
        label.textColor = self.norColor;
        
        label.font = self.titleFont;
        
        // 设置按钮标题
        label.text = vc.title;
        
        if (_isBisectedWidthUnderLineAndTitle) {
            labelW = YPScreenW / count;
        } else {
            labelW = [self.titleWidths[i] floatValue];
        }
        
        
        // 设置按钮位置
        UILabel *lastLabel = [self.titleLabels lastObject];
        
        if (_isBisectedWidthUnderLineAndTitle) {
            labelX =  CGRectGetMaxX(lastLabel.frame);
        } else {
            labelX = _titleMargin + CGRectGetMaxX(lastLabel.frame);
        }
        
        
        label.frame = CGRectMake(labelX, labelY, labelW, labelH);
        
        // 监听标题的点击
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(titleClick:)];
        [label addGestureRecognizer:tap];
        
        // 保存到数组
        [self.titleLabels addObject:label];
        
        [_titleScrollView addSubview:label];
        
        if (i == _selectIndex) {
            [self titleClick:tap];
        }
    }
    
    // 设置标题滚动视图的内容范围
    UILabel *lastLabel = self.titleLabels.lastObject;
    
    if (_isBisectedWidthUnderLineAndTitle) {
        _titleScrollView.contentSize = CGSizeMake(YPScreenW, 0);
    } else {
        _titleScrollView.contentSize = CGSizeMake(CGRectGetMaxX(lastLabel.frame), 0);
    }
    
    _titleScrollView.showsHorizontalScrollIndicator = NO;
    _contentScrollView.contentSize = CGSizeMake(count * YZScreenW, 0);
    
}

#pragma mark - 标题效果渐变方法
// 设置标题颜色渐变
- (void)setUpTitleColorGradientWithOffset:(CGFloat)offsetX rightLabel:(YZDisplayTitleLabel *)rightLabel leftLabel:(YZDisplayTitleLabel *)leftLabel
{
    if (_isShowTitleGradient == NO) return;
    
    // 获取右边缩放
    CGFloat rightSacle = offsetX / YZScreenW - leftLabel.tag;
    
    // 获取左边缩放比例
    CGFloat leftScale = 1 - rightSacle;
    
    // RGB渐变
    if (_titleColorGradientStyle == YZTitleColorGradientStyleRGB) {
        
        CGFloat r = _endR - _startR;
        CGFloat g = _endG - _startG;
        CGFloat b = _endB - _startB;
        
        // rightColor
        // 1 0 0
        UIColor *rightColor = [UIColor colorWithRed:_startR + r * rightSacle green:_startG + g * rightSacle blue:_startB + b * rightSacle alpha:1];
        
        // 0.3 0 0
        // 1 -> 0.3
        // leftColor
        UIColor *leftColor = [UIColor colorWithRed:_startR +  r * leftScale  green:_startG +  g * leftScale  blue:_startB +  b * leftScale alpha:1];
        
        // 右边颜色
        rightLabel.textColor = rightColor;
        
        // 左边颜色
        leftLabel.textColor = leftColor;
        
        return;
    }
    
    // 填充渐变
    if (_titleColorGradientStyle == YZTitleColorGradientStyleFill) {
        
        // 获取移动距离
        CGFloat offsetDelta = offsetX - _lastOffsetX;
        
        if (offsetDelta > 0) { // 往右边
            
            
            rightLabel.fillColor = self.selColor;
            rightLabel.progress = rightSacle;
            
            leftLabel.fillColor = self.norColor;
            leftLabel.progress = rightSacle;
            
        } else if(offsetDelta < 0){ // 往左边

            rightLabel.textColor = self.norColor;
            rightLabel.fillColor = self.selColor;
            rightLabel.progress = rightSacle;
            
            leftLabel.textColor = self.selColor;
            leftLabel.fillColor = self.norColor;
            leftLabel.progress = rightSacle;
            
        }
    }
}

// 标题缩放
- (void)setUpTitleScaleWithOffset:(CGFloat)offsetX rightLabel:(UILabel *)rightLabel leftLabel:(UILabel *)leftLabel
{
    if (_isShowTitleScale == NO) return;
    
    // 获取右边缩放
    CGFloat rightSacle = offsetX / YZScreenW - leftLabel.tag;
    
    CGFloat leftScale = 1 - rightSacle;
    
    CGFloat scaleTransform = _titleScale?_titleScale:YZTitleTransformScale;
    
    scaleTransform -= 1;
    
    // 缩放按钮
    leftLabel.transform = CGAffineTransformMakeScale(leftScale * scaleTransform + 1, leftScale * scaleTransform + 1);
    
    // 1 ~ 1.3
    rightLabel.transform = CGAffineTransformMakeScale(rightSacle * scaleTransform + 1, rightSacle * scaleTransform + 1);
}

// 获取两个标题按钮宽度差值
- (CGFloat)widthDeltaWithRightLabel:(UILabel *)rightLabel leftLabel:(UILabel *)leftLabel
{
    CGRect titleBoundsR = [rightLabel.text boundingRectWithSize:CGSizeMake(MAXFLOAT, 0) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:self.titleFont} context:nil];
    
    CGRect titleBoundsL = [leftLabel.text boundingRectWithSize:CGSizeMake(MAXFLOAT, 0) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:self.titleFont} context:nil];
    
    return titleBoundsR.size.width - titleBoundsL.size.width;
}

// 设置下标偏移
- (void)setUpUnderLineOffset:(CGFloat)offsetX rightLabel:(UILabel *)rightLabel leftLabel:(UILabel *)leftLabel
{
    if (_isClickTitle) return;
    
    // 获取两个标题中心点距离
    CGFloat centerDelta = rightLabel.left - leftLabel.left;
    
    // 标题宽度差值
    CGFloat widthDelta = [self widthDeltaWithRightLabel:rightLabel leftLabel:leftLabel];
    
    // 获取移动距离
    CGFloat offsetDelta = offsetX - _lastOffsetX;
    
    // 计算当前下划线偏移量
    CGFloat underLineTransformX = offsetDelta * centerDelta / YZScreenW;
    
    // 宽度递增偏移量
    CGFloat underLineWidth = offsetDelta * widthDelta / YZScreenW;
    
    if (_isBisectedWidthUnderLineAndTitle) {
        
        NSUInteger count = self.childViewControllers.count;
        
        self.underLine.width = YPScreenW / count;
        self.underLine.left += underLineTransformX;
    } else {
        self.underLine.width += underLineWidth;
        self.underLine.left += underLineTransformX;
    }
    


}

// 设置遮盖偏移
- (void)setUpCoverOffset:(CGFloat)offsetX rightLabel:(UILabel *)rightLabel leftLabel:(UILabel *)leftLabel
{
    if (_isClickTitle) return;
    
    // 获取两个标题中心点距离
    CGFloat centerDelta = rightLabel.left - leftLabel.left;
    
    // 标题宽度差值
    CGFloat widthDelta = [self widthDeltaWithRightLabel:rightLabel leftLabel:leftLabel];
    
    // 获取移动距离
    CGFloat offsetDelta = offsetX - _lastOffsetX;
    
    // 计算当前下划线偏移量
    CGFloat coverTransformX = offsetDelta * centerDelta / YZScreenW;
    
    // 宽度递增偏移量
    CGFloat coverWidth = offsetDelta * widthDelta / YZScreenW;
    
    self.coverView.width += coverWidth;
    self.coverView.left += coverTransformX;
    
}

#pragma mark - 标题点击处理
- (void)setSelectIndex:(NSInteger)selectIndex
{
    _selectIndex = selectIndex;
    if (self.titleLabels.count) {
        
        UILabel *label = self.titleLabels[selectIndex];
        
        [self titleClick:[label.gestureRecognizers lastObject]];
    }
}

// 标题按钮点击
- (void)titleClick:(UITapGestureRecognizer *)tap
{
    // 记录是否点击标题
    _isClickTitle = YES;
    
    // 获取对应标题label
    UILabel *label = (UILabel *)tap.view;
    
    // 获取当前角标
    NSInteger i = label.tag;
    
    // 选中label
    [self selectLabel:label];
    
    // 内容滚动视图滚动到对应位置
    CGFloat offsetX = i * YZScreenW;
    
    self.contentScrollView.contentOffset = CGPointMake(offsetX, 0);
    
    // 记录上一次偏移量,因为点击的时候不会调用scrollView代理记录，因此需要主动记录
    _lastOffsetX = offsetX;
    
    // 添加控制器
    UIViewController *vc = self.childViewControllers[i];
    
    // 判断控制器的view有没有加载，没有就加载，加载完在发送通知
    if (vc.view) {
        // 发出通知点击标题通知
        [[NSNotificationCenter defaultCenter] postNotificationName:YZDisplayViewClickOrScrollDidFinshNote  object:vc];
        
        // 发出重复点击标题通知
        if (_selIndex == i) {
            [[NSNotificationCenter defaultCenter] postNotificationName:YZDisplayViewRepeatClickTitleNote object:vc];
        }
    }
    
    _selIndex = i;
    
    // 点击事件处理完成
    _isClickTitle = NO;
}

- (void)selectLabel:(UILabel *)label
{

    for (YZDisplayTitleLabel *labelView in self.titleLabels) {
        
        if (label == labelView) continue;
        
        if (_isShowTitleGradient && _titleColorGradientStyle == YZTitleColorGradientStyleRGB) {
            
            labelView.transform = CGAffineTransformIdentity;
        }
        
        labelView.textColor = self.norColor;
        
        if (_isShowTitleGradient && _titleColorGradientStyle == YZTitleColorGradientStyleFill) {
            
            labelView.fillColor = self.norColor;
            
            labelView.progress = 1;
        }
        
    }
    
    // 标题缩放
    if (_isShowTitleScale && _titleColorGradientStyle == YZTitleColorGradientStyleRGB) {
        
        CGFloat scaleTransform = _titleScale?_titleScale:YZTitleTransformScale;
        
        label.transform = CGAffineTransformMakeScale(scaleTransform, scaleTransform);
    }
    
    // 修改标题选中颜色
    label.textColor = self.selColor;
    
    // 设置标题居中
    [self setLabelTitleCenter:label];
    
    // 设置下标的位置
    [self setUpUnderLine:label];
    
    // 设置cover
    [self setUpCoverView:label];
    
}

// 设置蒙版
- (void)setUpCoverView:(UILabel *)label
{
    // 获取文字尺寸
    CGRect titleBounds = [label.text boundingRectWithSize:CGSizeMake(MAXFLOAT, 0) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:self.titleFont} context:nil];
    
    CGFloat border = 5;
    CGFloat coverH = titleBounds.size.height + 2 * border;
    CGFloat coverW = titleBounds.size.width + 2 * border;
    
    self.coverView.top = (label.height - coverH) * 0.5;
    self.coverView.height = coverH;
    
    
    // 最开始不需要动画
    if (self.coverView.left == 0) {
        self.coverView.width = coverW;
        
        self.coverView.left = label.left - border;
        return;
    }
    
    // 点击时候需要动画
    [UIView animateWithDuration:0.25 animations:^{
        self.coverView.width = coverW;
        
        self.coverView.left = label.left - border;
    }];
    

    
}

// 设置下标的位置
- (void)setUpUnderLine:(UILabel *)label
{
    // 获取文字尺寸
    CGRect titleBounds = [label.text boundingRectWithSize:CGSizeMake(MAXFLOAT, 0) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:self.titleFont} context:nil];
    
    CGFloat underLineH = _underLineH?_underLineH:YZUnderLineH;
    
    self.underLine.top = label.height - underLineH;
    self.underLine.height = underLineH;

#warning 此处我觉得去掉交互比较好~~
#if 0
    // 最开始不需要动画
    if (self.underLine.left == 0) {
        
        if (_isBisectedWidthUnderLineAndTitle) {
            NSUInteger count = self.childViewControllers.count;
            self.underLine.width = YPScreenW / count;
            self.underLine.left = label.left;
        } else {
            self.underLine.width = titleBounds.size.width;
            self.underLine.left = label.left;
        }
        return;
    }
#endif
    
    // 点击时候需要动画
    [UIView animateWithDuration:0.25 animations:^{
        
        if (_isBisectedWidthUnderLineAndTitle) {
            NSUInteger count = self.childViewControllers.count;
            self.underLine.width = YPScreenW / count;
            self.underLine.left = label.left;
        } else {
            self.underLine.width = titleBounds.size.width;
            self.underLine.left = label.left;
        }
    }];
    
}

// 让选中的按钮居中显示
- (void)setLabelTitleCenter:(UILabel *)label
{
    
    // 设置标题滚动区域的偏移量
    CGFloat offsetX = label.center.x - YZScreenW * 0.5;
    
    if (offsetX < 0) {
        offsetX = 0;
    }
    
    // 计算下最大的标题视图滚动区域
    CGFloat maxOffsetX = self.titleScrollView.contentSize.width - YZScreenW + _titleMargin;
    
    if (maxOffsetX < 0) {
        maxOffsetX = 0;
    }
    
    if (offsetX > maxOffsetX) {
        offsetX = maxOffsetX;
    }
    
    // 滚动区域
    
    if (_isBisectedWidthUnderLineAndTitle) {
        [self.titleScrollView setContentOffset:CGPointMake(0, 0) animated:YES];
    } else {
        [self.titleScrollView setContentOffset:CGPointMake(offsetX, 0) animated:YES];
    }
    
    
}

#pragma mark - 刷新界面方法
// 更新界面
- (void)refreshDisplay
{
    // 清空之前所有标题
    [self.titleLabels makeObjectsPerformSelector:@selector(removeFromSuperview)];
    [self.titleLabels removeAllObjects];
    
    // 刷新表格
    [self.contentScrollView reloadData];
    
    // 重新设置标题
    [self setUpTitleWidth];
    
    [self setUpAllTitle];
    
}

#pragma mark - UICollectionViewDataSource
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return self.childViewControllers.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    UICollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:ID forIndexPath:indexPath];
    
    // 移除之前的子控件
    [cell.contentView.subviews makeObjectsPerformSelector:@selector(removeFromSuperview)];
    
    // 添加控制器
    UIViewController *vc = self.childViewControllers[indexPath.row];
    
    vc.view.frame = CGRectMake(0, 0, self.contentScrollView.width, self.contentScrollView.height);
    
    [cell.contentView addSubview:vc.view];
    
    return cell;
}

#pragma mark - UIScrollViewDelegate

// 减速完成
- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView
{
    CGFloat offsetX = scrollView.contentOffset.x;
    NSInteger offsetXInt = offsetX;
    NSInteger screenWInt = YZScreenW;
    
    NSInteger extre = offsetXInt % screenWInt;
    if (extre > YZScreenW * 0.5) {
        // 往右边移动
        offsetX = offsetX + (YZScreenW - extre);
        _isAniming = YES;
        [self.contentScrollView setContentOffset:CGPointMake(offsetX, 0) animated:YES];
    }else if (extre < YZScreenW * 0.5 && extre > 0){
        _isAniming = YES;
        // 往左边移动
        offsetX =  offsetX - extre;
        [self.contentScrollView setContentOffset:CGPointMake(offsetX, 0) animated:YES];
    }
    
    // 获取角标
    NSInteger i = offsetX / YZScreenW;
    
    // 选中标题
    [self selectLabel:self.titleLabels[i]];
    
    // 取出对应控制器发出通知
    UIViewController *vc = self.childViewControllers[i];
    
    // 发出通知
    [[NSNotificationCenter defaultCenter] postNotificationName:YZDisplayViewClickOrScrollDidFinshNote object:vc];
}


// 监听滚动动画是否完成
- (void)scrollViewDidEndScrollingAnimation:(UIScrollView *)scrollView
{
    _isAniming = NO;
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    // 点击和动画的时候不需要设置
    if (_isAniming || self.titleLabels.count == 0) return;
    
    // 获取偏移量
    CGFloat offsetX = scrollView.contentOffset.x;
    
    // 获取左边角标
    NSInteger leftIndex = offsetX / YZScreenW;
    
    // 左边按钮
    YZDisplayTitleLabel *leftLabel = self.titleLabels[leftIndex];
    
    // 右边角标
    NSInteger rightIndex = leftIndex + 1;
    
    // 右边按钮
    YZDisplayTitleLabel *rightLabel = nil;
    
    if (rightIndex < self.titleLabels.count) {
        rightLabel = self.titleLabels[rightIndex];
    }
    
    // 字体放大
    [self setUpTitleScaleWithOffset:offsetX rightLabel:rightLabel leftLabel:leftLabel];
    
    // 设置下标偏移
    if (_isDelayScroll == NO) { // 延迟滚动，不需要移动下标
        
        [self setUpUnderLineOffset:offsetX rightLabel:rightLabel leftLabel:leftLabel];
    }
    
    // 设置遮盖偏移
    [self setUpCoverOffset:offsetX rightLabel:rightLabel leftLabel:leftLabel];
    
    // 设置标题渐变
    [self setUpTitleColorGradientWithOffset:offsetX rightLabel:rightLabel leftLabel:leftLabel];
    
    // 记录上一次的偏移量
    _lastOffsetX = offsetX;
}

@end
