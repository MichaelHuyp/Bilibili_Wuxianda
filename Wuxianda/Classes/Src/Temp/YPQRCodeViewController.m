//
//  YPQRCodeViewController.m
//  Wuxianda
//
//  Created by 胡云鹏 on 16/7/2.
//  Copyright © 2016年 michaelhuyp. All rights reserved.
//

#import "YPQRCodeViewController.h"

@interface YPQRCodeViewController ()


@property (weak, nonatomic) IBOutlet UIImageView *iconImageView;

@end

@implementation YPQRCodeViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.iconImageView.image = [self createQRCodeImage];
}

- (UIImage *)createQRCodeImage
{
    // 1.创建滤镜
    CIFilter *filter = [CIFilter filterWithName:@"CIQRCodeGenerator"];
//    CIFilter *filter = [CIFilter filterWithName:@"CICode128BarcodeGenerator"];
    
    // 2.还原滤镜的默认属性
    [filter setDefaults];
    
    // 3.设置需要生成二维码的数据
    [filter setValue:[@"MichaelHuyp" dataUsingEncoding:NSUTF8StringEncoding] forKey:@"inputMessage"];
    
    // 4.从滤镜中取出生成好的图片
    CIImage *ciImage = [filter outputImage];
    
    UIImage *bgImage = [self createNonInterpolatedUIImageFormCIImage:ciImage size:300];
    
    // 5.创建一个头像
    UIImage *iconImage = [UIImage imageNamed:@"myicon"];
    
    // 6.合成图片（将二维码和头像进行合并）
    UIImage *newImage = [self createImage:bgImage iconImage:nil];
    
    // 7.返回生成好的二维码
    return newImage;
}


- (UIImage *)createImage:(UIImage *)bgImage iconImage:(UIImage *)iconImage
{
    // 1.开启图片上下文
    UIGraphicsBeginImageContext(bgImage.size);
    
    // 2.绘制背景图片
    [bgImage drawInRect:CGRectMake(0, 0, bgImage.size.width, bgImage.size.height)];
    
    // 3.绘制头像
    CGFloat width = 66;
    CGFloat height = width;
    CGFloat x = (bgImage.size.width - width) * 0.5;
    CGFloat y = (bgImage.size.height - height) * 0.5;
    
    [iconImage drawInRect:CGRectMake(x, y, width, height)];
    
    // 4.取出绘制好的图片
    UIImage *newImage = UIGraphicsGetImageFromCurrentImageContext();
    
    // 5.关闭上下文
    UIGraphicsEndImageContext();
    
    // 6.返回合成好的图片
    return newImage;
}


- (UIImage *)createNonInterpolatedUIImageFormCIImage:(CIImage *)image size:(CGFloat)size
{
    CGRect extent = CGRectIntegral(image.extent);
    
    CGFloat scale = MIN(size / CGRectGetWidth(extent), size / CGRectGetHeight(extent));
    
    // 1.创建bitmap
    CGFloat width = CGRectGetWidth(extent) * scale;
    CGFloat height = CGRectGetHeight(extent) * scale;
    CGColorSpaceRef cs = CGColorSpaceCreateDeviceGray();
    CGContextRef bitmapRef = CGBitmapContextCreate(nil, (int)width, (int)height, 8, 0, cs, 0);
 
    CIContext *context = [CIContext contextWithOptions:nil];
    CGImageRef bitmapImage = [context createCGImage:image fromRect:extent];
    
    CGContextSetInterpolationQuality(bitmapRef, kCGInterpolationNone);
    CGContextScaleCTM(bitmapRef, scale, scale);
    CGContextDrawImage(bitmapRef, extent, bitmapImage);
    
    // 2.保存bitmap到图片
    CGImageRef scaledImage = CGBitmapContextCreateImage(bitmapRef);
    
    
    // 3.释放资源
//    CGColorSpaceRelease(cs);
//    CGContextRelease(bitmapRef);
//    CGImageRelease(bitmapImage);
//    CGImageRelease(scaledImage);
    
    return [UIImage imageWithCGImage:scaledImage];
}

@end


























