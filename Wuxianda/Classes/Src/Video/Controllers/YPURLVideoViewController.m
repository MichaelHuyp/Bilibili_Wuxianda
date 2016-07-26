//
//  YPURLVideoViewController.m
//  Wuxianda
//
//  Created by 胡云鹏 on 16/5/15.
//  Copyright © 2016年 michaelhuyp. All rights reserved.
//

#import "YPURLVideoViewController.h"
#import "YPMoviePlayerViewController.h"
#import <AVFoundation/AVFoundation.h>
#import <MediaPlayer/MediaPlayer.h>

@interface YPURLVideoViewController ()

@property (nonatomic, strong) AVPlayer *player;

@property (nonatomic, strong) MPMoviePlayerController *playerController;

@property (nonatomic, strong) MPMoviePlayerViewController *playerVc;
 
@end

@implementation YPURLVideoViewController

- (MPMoviePlayerViewController *)playerVc
{
    if (!_playerVc) {
        
        // 1.获取url(远程/本地)
        NSURL *url = [NSURL URLWithString:@"http:v1.mukewang.com/a45016f4-08d6-4277-abe6-bcfd5244c201/L.mp4"];
        
        _playerVc = [[MPMoviePlayerViewController alloc] initWithContentURL:url];
    }
    return _playerVc;
}

- (MPMoviePlayerController *)playerController
{
    if (!_playerController) {
        // 1.获取url(远程/本地)
        NSURL *url = [NSURL URLWithString:@"http:v1.mukewang.com/a45016f4-08d6-4277-abe6-bcfd5244c201/L.mp4"];
        
        // 2.创建控制器
        _playerController = [[MPMoviePlayerController alloc] initWithContentURL:url];
        
        // 3.设置控制器view的位置
        _playerController.view.frame = CGRectMake(0, 0, self.view.width, self.view.width * 9 / 16);
        
        // 4.将view添加到控制器上
        [self.view addSubview:_playerController.view];
    }
    return _playerController;
}

- (AVPlayer *)player
{
    if (!_player) {
        
        // 1.获取url(远程/本地)
        NSURL *url = [NSURL URLWithString:@"http:v1.mukewang.com/a45016f4-08d6-4277-abe6-bcfd5244c201/L.mp4"];
        // 2.创建AVPlayerItem
        AVPlayerItem *item = [AVPlayerItem playerItemWithURL:url];
        // 3.创建AVPlayer
        _player = [AVPlayer playerWithPlayerItem:item];
        
        // 4.添加AVPlayerLayer
        AVPlayerLayer *layer = [AVPlayerLayer playerLayerWithPlayer:_player];
        layer.frame = CGRectMake(0, 0, self.view.bounds.size.width, self.view.bounds.size.width * 9 / 16);
        [self.view.layer addSublayer:layer];
    }
    return _player;
}

- (void)viewDidLoad {
    [super viewDidLoad];
}


- (IBAction)play:(id)sender {

//    [self.player play];
    
//    [self.playerController play];
    
//    [self presentViewController:self.playerVc animated:YES completion:nil];
    
    [self ijkPlayer];
}

- (void)ijkPlayer
{
    //    NSURL *url = [NSURL URLWithString:@"http://175.25.168.26/live-play.acgvideo.com/live/324/live_437038_4368633.flv?1988&wshc_tag=0&wsts_tag=57381fcc&wsid_tag=65fe8c63&wsiphost=ipdbm"];
    
    NSURL *url = [NSURL URLWithString:@"http://cn-tj1-cu.acgvideo.com/vg119/4/fe/8041661-1.flv?expires=1466618400&ssig=OT6lPUVTwqnS2_6bQ271_w&oi=3733182991&appkey=f3bb208b3d081dc8&or=2099709835&rate=0"];
    
//    NSURL *url = [NSURL URLWithString:@"http://cn-hbyc8-dx.acgvideo.com/vg5/5/47/8041661-1.flv?expires=1466597400&ssig=aUsXl6xF5aa0mLmggdq2uQ&oi=2034572434&appkey=f3bb208b3d081dc8&or=2081295465&rate=0"];
    
    NSString *scheme = [[url scheme] lowercaseString];
    if ([scheme isEqualToString:@"http"] || [scheme isEqualToString:@"https"]) {
        [YPMoviePlayerViewController presentFromViewController:self URL:url animated:YES];
    }
}


@end
































