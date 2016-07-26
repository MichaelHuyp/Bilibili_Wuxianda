//
//  YPCityPickerCollectionViewCell.m
//  Wuxianda
//
//  Created by MichaelPPP on 16/7/1.
//  Copyright © 2016年 michaelhuyp. All rights reserved.
//

#import "YPCityPickerCollectionViewCell.h"
#import "YPCityPickerButton.h"

@interface YPCityPickerCollectionViewCell ()

@property (weak, nonatomic) IBOutlet YPCityPickerButton *cityNameBtn;


@end

@implementation YPCityPickerCollectionViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    
    // self
    self.layer.borderColor = YPLightLineColor.CGColor;
    self.layer.borderWidth = 1;
    self.layer.cornerRadius = 4;
    self.layer.masksToBounds = YES;
    
    [_cityNameBtn setImage:[UIImage imageNamed:@"citypicker_btn_image_selected"] forState:UIControlStateSelected];
}

- (void)setCityName:(NSString *)cityName
{
    _cityName = cityName;
    
    [_cityNameBtn setTitle:cityName forState:UIControlStateNormal];
}

@end
