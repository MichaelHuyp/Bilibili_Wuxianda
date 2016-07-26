//
//  YPBaseCollectionViewCell.m
//  PhotoDemo1
//
//  Created by 胡云鹏 on 16/5/25.
//  Copyright © 2016年 michaelhuyp. All rights reserved.
//

#import "YPBaseCollectionViewCell.h"

@implementation YPBaseCollectionViewCell

+ (instancetype)cellFromNib:(NSString*)nibName andCollectionView:(UICollectionView *)collectionView andIndexPath:(NSIndexPath *)indexPath
{
    NSString* className = NSStringFromClass([self class]);
    
    NSString* ID = nibName == nil ? className : nibName;
    
    UINib* nib = [UINib nibWithNibName:ID bundle:nil];
    
    [collectionView registerNib:nib forCellWithReuseIdentifier:ID];
    
    return [collectionView dequeueReusableCellWithReuseIdentifier:ID forIndexPath:indexPath];
}

@end
