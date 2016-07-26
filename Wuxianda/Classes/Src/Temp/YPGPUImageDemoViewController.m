//
//  YPGPUImageDemoViewController.m
//  Wuxianda
//
//  Created by MichaelPPP on 16/6/20.
//  Copyright © 2016年 michaelhuyp. All rights reserved.
//

#import "YPGPUImageDemoViewController.h"
#import "GPUImage.h"
#import "UIImageView+WebCache.h"

#define kImageUrl @"http://i0.hdslb.com/bfs/bangumi/d4746cb87f321ecc211c8047df9d64fe33f7ffd3.jpg"

@interface YPGPUImageDemoViewController ()

@property (nonatomic, weak) IBOutlet UIImageView *imageView;
@property (weak, nonatomic) IBOutlet UISlider *slider;

@property (nonatomic, weak) UIVisualEffectView *visualEffectView;

@end

@implementation YPGPUImageDemoViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [_imageView setImageURL:[NSURL URLWithString:kImageUrl]];
    
    UIBlurEffect *effect = [UIBlurEffect effectWithStyle:UIBlurEffectStyleLight];
    UIVisualEffectView *effectView = [[UIVisualEffectView alloc] initWithEffect:effect];
    _visualEffectView = effectView;
    effectView.frame = CGRectMake(0, 0, _imageView.frame.size.width, _imageView.frame.size.height);
    [_imageView addSubview:effectView];
    
#if 0
    @weakify(self);
    [_imageView sd_setImageWithURL:[NSURL URLWithString:kImageUrl] placeholderImage:nil options:SDWebImageAvoidAutoSetImage completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
        @strongify(self);
        UIImage *resultImage = [self blurryGPUImage:image withBlurLevel:0];
        _imageView.image = resultImage;
    }];
#endif
    
}
- (IBAction)valueChange:(id)sender {
    _visualEffectView.contentView.alpha = _slider.value;
}

- (UIImage *)blurryGPUImage:(UIImage *)image {
    GPUImageGaussianBlurFilter *blurFilter = [[GPUImageGaussianBlurFilter alloc] init];
    blurFilter.texelSpacingMultiplier = 1.0f;
    blurFilter.blurRadiusInPixels = 20.0f;
    UIImage *result = [blurFilter imageByFilteringImage:image];
    return result;
}

@end
