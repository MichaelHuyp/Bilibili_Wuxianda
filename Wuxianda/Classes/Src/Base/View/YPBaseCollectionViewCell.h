//
//  YPBaseCollectionViewCell.h
//  PhotoDemo1
//
//  Created by 胡云鹏 on 16/5/25.
//  Copyright © 2016年 michaelhuyp. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface YPBaseCollectionViewCell : UICollectionViewCell
+ (instancetype)cellFromNib:(NSString*)nibName andCollectionView:(UICollectionView *)collectionView andIndexPath:(NSIndexPath *)indexPath;
@end
