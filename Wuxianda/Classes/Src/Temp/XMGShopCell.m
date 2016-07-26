//
//  XMGShopCell.m
//  04-瀑布流
//
//  Created by apple on 14/12/4.
//  Copyright (c) 2014年 小码哥. All rights reserved.
//

#import "XMGShopCell.h"
#import "XMGShop.h"
#import "UIImageView+WebCache.h"

@interface XMGShopCell()
@property (weak, nonatomic) IBOutlet UIImageView *imageView;
@property (weak, nonatomic) IBOutlet UILabel *priceLabel;
@end

@implementation XMGShopCell

- (void)setShop:(XMGShop *)shop
{
    _shop = shop;
    
    // 1.图片
    [self.imageView sd_setImageWithURL:[NSURL URLWithString:shop.img] placeholderImage:[UIImage imageNamed:@"loading"]];
    
    // 2.价格
    self.priceLabel.text = shop.price;
}
@end
