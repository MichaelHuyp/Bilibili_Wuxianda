//
//  YPCityPickerHeaderView.m
//  YPCityPickerViewController
//
//  Created by MichaelPPP on 16/7/1.
//  Copyright © 2016年 MichaelHuyp. All rights reserved.
//

#import "YPCityPickerHeaderView.h"
#import "YPCityPickerCollectionViewCell.h"
#import "YPCityPickerButton.h"


@interface YPCityPickerHeaderView () <UICollectionViewDelegate,UICollectionViewDataSource,UICollectionViewDelegateFlowLayout>

/** 当前定位城市按钮 */
@property (weak, nonatomic) IBOutlet YPCityPickerButton *currentLocateCityBtn;

/** 热门城市collectionView */
@property (weak, nonatomic) IBOutlet UICollectionView *collectionView;

/** collectionViewHeight约束 */
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *collectionViewHeightCons;

@property (nonatomic, copy) YPCityPickerHeaderViewCallBack callBack;

@end

@implementation YPCityPickerHeaderView

static NSString * const CollectionViewCellID = @"YPCityPickerCollectionViewCell";

#pragma mark - Public
+ (instancetype)cityPickerHeaderViewWithCallBack:(YPCityPickerHeaderViewCallBack)callBack
{
    YPCityPickerHeaderView *view = [YPCityPickerHeaderView viewFromXib];
    view.callBack = callBack;
    return view;
}

#pragma mark - Override
- (void)awakeFromNib
{

    [super awakeFromNib];
    
    // 当前定位城市按钮
    _currentLocateCityBtn.layer.borderColor = YPLightLineColor.CGColor;
    _currentLocateCityBtn.layer.borderWidth = 1;
    _currentLocateCityBtn.layer.cornerRadius = 4;
    _currentLocateCityBtn.layer.masksToBounds = YES;
    
    [_currentLocateCityBtn setImage:[UIImage imageNamed:@"citypicker_btn_image_selected"] forState:UIControlStateSelected];
    
    @weakify(self);
    [[_currentLocateCityBtn rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(id x) {
        @strongify(self);
        if (self.callBack) {
            self.callBack(self.currentLocateCityBtn.titleLabel.text);
        }
    }];
    
    
    [_collectionView rac_observeKeyPath:@"contentSize" options:NSKeyValueObservingOptionNew observer:self block:^(id value, NSDictionary *change, BOOL causedByDealloc, BOOL affectedOnlyLastComponent) {
        
        @strongify(self);
        
        CGSize size = [change[@"new"] CGSizeValue];
        
        self.collectionViewHeightCons.constant = size.height;
        
        [self layoutIfNeeded];
        
    }];
    
    
    // layout
    UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc] init];
    layout.itemSize = CGSizeMake(75, 36);
    layout.minimumInteritemSpacing = (YPScreenW - 32 - 15 - 75 * 4) / 3;
    layout.minimumLineSpacing = (YPScreenW - 32 - 15 - 75 * 4) / 3;
    layout.sectionInset = UIEdgeInsetsMake(16, 16, 16, 16);
    
    // collectionView
    _collectionView.collectionViewLayout = layout;
    
    // register cell
    UINib *cellNib = [UINib nibWithNibName:CollectionViewCellID bundle:nil];
    [_collectionView registerNib:cellNib forCellWithReuseIdentifier:CollectionViewCellID];

}


- (void)layoutSubviews
{
    [super layoutSubviews];
    
    _viewH = 106 + _collectionViewHeightCons.constant;
}



- (void)dealloc
{
//    YPLog(@"城市选择控制器header被销毁了");
}

#pragma mark - UICollectionViewDataSource
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return _hotCityNames.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    
    YPCityPickerCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:CollectionViewCellID forIndexPath:indexPath];
    
    cell.cityName = _hotCityNames[indexPath.item];
    
    
    return cell;
}

#pragma mark - UICollectionViewDelegate
- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    NSString *selectedCityName = _hotCityNames[indexPath.item];
    
    if (_callBack) {
        _callBack(selectedCityName);
    }
    
}

#pragma mark - Setter

- (void)setCurrentCityName:(NSString *)currentCityName
{
    _currentCityName = currentCityName;
 
    [_currentLocateCityBtn setTitle:currentCityName forState:UIControlStateNormal];
    [_currentLocateCityBtn setTitle:currentCityName forState:UIControlStateSelected];
}

@end
































