
//
//  YPBilibiliWebViewController.m
//  Wuxianda
//
//  Created by MichaelPPP on 16/6/16.
//  Copyright © 2016年 michaelhuyp. All rights reserved.
//

#import "YPBilibiliWebViewController.h"
#import <WebKit/WebKit.h>
#import "YPBannerModel.h"
#import "YPAlertView.h"
#import "YPSocialShareView.h"
#import "UMSocialDataService.h"
#import "UMSocialSnsPlatformManager.h"
#import "YPToastView.h"


@interface YPBilibiliWebViewController () <WKNavigationDelegate,WKUIDelegate,WKScriptMessageHandler>

@property (nonatomic, weak) WKWebView *webView;

@property (nonatomic, weak) WKUserContentController *userContentController;

@end

@implementation YPBilibiliWebViewController


- (void)viewDidLoad {
    [super viewDidLoad];
    [self createUI];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    [YPApplication setStatusBarStyle:UIStatusBarStyleDefault animated:YES];
}

- (void)viewDidDisappear:(BOOL)animated
{
    [super viewDidDisappear:animated];
    
    [_userContentController removeScriptMessageHandlerForName:@"MichaelHuyp"];
}



- (void)viewDidLayoutSubviews
{
    [super viewDidLayoutSubviews];
    
    self.navigationController.navigationBar.alpha = 1.0f;
    
    [self.navigationController.navigationBar.superview bringSubviewToFront:self.navigationController.navigationBar];
}

- (void)createUI
{
    // self
    self.automaticallyAdjustsScrollViewInsets = NO;
    self.view.backgroundColor = YPClearColor;
    
    /********* WebView ***********/
    
    // webView的偏好设置
    WKPreferences *preferences = [[WKPreferences alloc] init];
    preferences.minimumFontSize = 10;
    preferences.javaScriptEnabled = YES;
    preferences.javaScriptCanOpenWindowsAutomatically = NO;
    
    // webView JS与内容交互
    WKUserContentController *userContentController = [[WKUserContentController alloc] init];
    _userContentController = userContentController;
    [userContentController addScriptMessageHandler:self name:@"MichaelHuyp"];
    
    // webView配置
    WKWebViewConfiguration *config = [[WKWebViewConfiguration alloc] init];
    config.preferences = preferences;
    config.userContentController = userContentController;
    
    WKWebView *webView = [[WKWebView alloc] initWithFrame:CGRectMake(0, kAppStatusBarHeight + kAppNavigationBarHeight, YPScreenW, YPScreenH - (kAppStatusBarHeight + kAppNavigationBarHeight)) configuration:config];
    _webView = webView;
    webView.navigationDelegate = self;
    webView.UIDelegate = self;
    NSURLRequest *request = [NSURLRequest requestWithURL:[NSURL URLWithString:_model.value]];
    [webView loadRequest:request];
    [self.view addSubview:webView];
    
    /********* navigationItem ***********/
    
    // title
    @weakify(self);
    RAC(self.navigationItem,title) = [RACObserve(webView, title) map:^id(NSString *value) {
        @strongify(self);
        if ([value isNotBlank]) {
            return value;
        }
        return self.model.value;
    }];
    
    // rightBarButtonItem
    UIButton *rightBarButton = [UIButton buttonWithType:UIButtonTypeCustom];
    rightBarButton.titleLabel.font = [UIFont boldSystemFontOfSize:17];
    rightBarButton.contentEdgeInsets = UIEdgeInsetsMake(0, 0, 0, -10);
    [rightBarButton setTitle:@"分享" forState:UIControlStateNormal];
    [rightBarButton sizeToFit];
    [rightBarButton setTitleColor:YPMainColor forState:UIControlStateNormal];
    [rightBarButton setTitleColor:YPMainColor forState:UIControlStateHighlighted];
    
    [[rightBarButton rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(id x) {
        
        @strongify(self);
        
        @weakify(self);
        [YPSocialShareView showWithBlock:^(NSInteger selectItemIndex) {
            @strongify(self);
            switch (selectItemIndex) {
                case YPSocialShareTypeSina:
                {
                    [self shareWithType:UMShareToSina content:self.model.value image:nil];
                    break;
                }
                case YPSocialShareTypeWechatSession:
                {
                    [self shareWithType:UMShareToWechatSession content:self.model.value image:nil];
                    break;
                }
                case YPSocialShareTypeWechatTimeline:
                {
                    [self shareWithType:UMShareToWechatTimeline content:self.model.value image:nil];
                    break;
                }
                case YPSocialShareTypeQQ:
                {
                    [self shareWithType:UMShareToQQ content:self.model.value image:nil];
                    break;
                }
                case YPSocialShareTypeQzone:
                {
                    [self shareWithType:UMShareToQzone content:self.model.value image:[UIImage imageNamed:@"bilibili_splash_default_2"]];
                    break;
                }
                case YPSocialShareTypeCopy:
                {
                    YPLog(@"粘贴板");
                    UIPasteboard *pasteboard = [UIPasteboard generalPasteboard];
                    [pasteboard setString:self.model.value];
                    [YPSocialShareView dismiss];
                    [YPToastView showWithTitle:@"复制成功"];
                    break;
                }
                default:
                    break;
            }
            
        }];
    }];
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:rightBarButton];
}

#pragma mark - Private
- (void)shareWithType:(NSString *)type content:(NSString *)content image:(UIImage *)image
{
    [[UMSocialDataService defaultDataService]  postSNSWithTypes:@[type] content:[NSString stringWithFormat:@"分享 %@",content] image:image location:nil urlResource:nil presentedController:self completion:^(UMSocialResponseEntity *response){
        if (response.responseCode == UMSResponseCodeSuccess) {
            YPLog(@"分享成功！");
        }
    }];
    
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.1f * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [YPSocialShareView dismiss];
    });
}

#pragma mark - WKScriptMessageHandler
- (void)userContentController:(WKUserContentController *)userContentController didReceiveScriptMessage:(WKScriptMessage *)message
{
    YPLog(@"%@",NSStringFromSelector(_cmd));
    if ([message.name isEqualToString:@"MichaelHuyp"]) {
        YPLog(@"%@",message.body);
    }
}

#pragma mark - WKUIDelegate
#pragma mark Alert交互
- (void)webView:(WKWebView *)webView runJavaScriptAlertPanelWithMessage:(NSString *)message initiatedByFrame:(WKFrameInfo *)frame completionHandler:(void (^)(void))completionHandler
{
    [YPAlertView showWithTitle:@"温馨提示" message:@"a" cancelButtonTitle:@"取消" otherButtonTitles:@[@"确定"] andAction:^(NSInteger buttonIndex) {
        if (buttonIndex == 1) {
            completionHandler();
        }
    } andParentView:self.view];
}

#pragma mark Confirm交互
- (void)webView:(WKWebView *)webView runJavaScriptConfirmPanelWithMessage:(NSString *)message initiatedByFrame:(WKFrameInfo *)frame completionHandler:(void (^)(BOOL))completionHandler
{
    [YPAlertView showWithTitle:@"温馨提示" message:@"a" cancelButtonTitle:@"取消" otherButtonTitles:@[@"确定"] andAction:^(NSInteger buttonIndex) {
        if (buttonIndex == 1) {
            completionHandler(YES);
        } else {
            completionHandler(NO);
        }
    } andParentView:self.view];
}

#pragma mark Prompt交互
- (void)webView:(WKWebView *)webView runJavaScriptTextInputPanelWithPrompt:(NSString *)prompt defaultText:(NSString *)defaultText initiatedByFrame:(WKFrameInfo *)frame completionHandler:(void (^)(NSString * _Nullable))completionHandler
{
    UIAlertController *alertVc = [UIAlertController alertControllerWithTitle:prompt message:defaultText preferredStyle:UIAlertControllerStyleAlert];
    [alertVc addTextFieldWithConfigurationHandler:^(UITextField * _Nonnull textField) {
        textField.textColor = YPRedColor;
    }];
    
    UIAlertAction *action = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        completionHandler(alertVc.textFields[0].text);
    }];
    
    [alertVc addAction:action];
    
    [self presentViewController:alertVc animated:YES completion:nil];
}


@end
