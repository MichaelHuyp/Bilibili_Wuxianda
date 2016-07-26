//
//  YPSocialShareView.m
//  Wuxianda
//
//  Created by MichaelPPP on 16/6/16.
//  Copyright © 2016年 michaelhuyp. All rights reserved.
//

#import "YPSocialShareView.h"
#import "YPSocialShareCollectionViewCell.h"
#import "YPSocialShareLayout.h"
#import "YPSocialShareModel.h"

@interface YPSocialShareView () <UICollectionViewDataSource, UICollectionViewDelegate>

@property (weak, nonatomic) IBOutlet UICollectionView *collectionView;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *shareViewBottomCons;

/** 取消按钮 */
@property (weak, nonatomic) IBOutlet UIButton *cancleBtn;

/** 分享数据源 */
@property (nonatomic, strong) NSMutableArray *shareDataSource;

/** 模型数据源数组 */
@property (nonatomic, strong) NSMutableArray *modelArr;

@property (nonatomic, copy) YPSocialShareViewBlock block;

@end

@implementation YPSocialShareView

static NSString * const cellID = @"YPSocialShareCollectionViewCell";

#pragma mark - Lazy
- (NSMutableArray *)modelArr
{
    if (!_modelArr) {
        _modelArr = [YPSocialShareModel mj_objectArrayWithKeyValuesArray:self.shareDataSource];
    }
    return _modelArr;
}

- (NSMutableArray *)shareDataSource
{
    if (!_shareDataSource) {
        _shareDataSource = [NSMutableArray array];
        
        _shareDataSource = [@[
                              @{
                                  @"image" : @"misc_share_sina",
                                  @"title" : @"新浪微博"
                                },
                              @{
                                  @"image" : @"misc_share_wechat",
                                  @"title" : @"微信"
                                  },
                              @{
                                  @"image" : @"misc_share_friends",
                                  @"title" : @"朋友圈"
                                  },
                              @{
                                  @"image" : @"misc_share_qq",
                                  @"title" : @"QQ"
                                  },
                              @{
                                  @"image" : @"player_live_share_qqzone",
                                  @"title" : @"QQ空间"
                                  },
                              @{
                                  @"image" : @"misc_share_copy",
                                  @"title" : @"复制链接"
                                  }
                              ] mutableCopy];
        
        
    }
    return _shareDataSource;
}

#pragma mark - Public

+ (instancetype)socialShareView
{
    static dispatch_once_t once;
    static id instance;
    dispatch_once(&once, ^{
        instance = [self viewFromXib];
    });
    return instance;
}

+ (void)showWithBlock:(YPSocialShareViewBlock)block
{
    YPSocialShareView *view = [YPSocialShareView socialShareView];
    view.block = block;
    
    UIWindow *window = [[UIApplication sharedApplication].windows lastObject];
    
    [window addSubview:view];
    
    
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.1f * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        view.shareViewBottomCons.constant = 0;
        [UIView animateWithDuration:0.25f animations:^{
            view.backgroundColor = [[UIColor alloc] initWithRed:0 green:0 blue:0 alpha:0.25];
            [view layoutIfNeeded];
        } completion:nil];
    });
}

+ (void)dismiss
{
    YPSocialShareView *view = [YPSocialShareView socialShareView];
    
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.1f * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        view.shareViewBottomCons.constant = -220;
        [UIView animateWithDuration:0.25f animations:^{
            view.backgroundColor = YPClearColor;
            [view layoutIfNeeded];
        } completion:^(BOOL finished) {
            [view removeFromSuperview];
        }];
    });
}

#pragma mark - Life Cycle
- (instancetype)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame]) {
        [self setup];
    }
    return self;
}

- (instancetype)initWithCoder:(NSCoder *)aDecoder
{
    if (self = [super initWithCoder:aDecoder]) {
        [self setup];
    }
    return self;
}

- (void)setup
{
    self.backgroundColor = YPClearColor;
}

- (void)awakeFromNib
{
    [super awakeFromNib];
    
    // FlowLayout
    YPSocialShareLayout *flowLayout = [[YPSocialShareLayout alloc] init];
    _collectionView.collectionViewLayout = flowLayout;
    _collectionView.backgroundColor = YPWhiteColor;
    
    UINib *nib = [UINib nibWithNibName:cellID bundle:nil];
    [_collectionView registerNib:nib forCellWithReuseIdentifier:cellID];
    
    [[_cancleBtn rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(id x) {
        [YPSocialShareView dismiss];
    }];
}

- (void)willMoveToSuperview:(UIView *)newSuperview
{
    [super willMoveToSuperview:newSuperview];
    
    self.frame = newSuperview.bounds;
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    [YPSocialShareView dismiss];
}

#pragma mark - UICollectionViewDataSource
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return self.modelArr.count;
}
- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    YPSocialShareCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:cellID forIndexPath:indexPath];
    cell.model = self.modelArr[indexPath.item];
    return cell;
}

#pragma mark - UICollectionViewDelegate

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    if (_block) {
        _block(indexPath.item);
    }
}

@end
