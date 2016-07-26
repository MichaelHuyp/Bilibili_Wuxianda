//
//  YPWebViewController.m
//  Wuxianda
//
//  Created by MichaelPPP on 16/5/23.
//  Copyright © 2016年 michaelhuyp. All rights reserved.
//

#import "YPWebViewController.h"
#import <WebKit/WebKit.h>
#import "WKWebViewJavascriptBridge.h"
#import "YPAlertView.h"

@interface YPWebViewController () <WKNavigationDelegate,WKUIDelegate,WKScriptMessageHandler>

@property (nonatomic, weak) WKWebView *webView;

@property (nonatomic, weak) UIProgressView *progressView;

@property (nonatomic, strong) WKWebViewJavascriptBridge *bridge;


@end

@implementation YPWebViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [YPProgressHUD show];
    
    self.automaticallyAdjustsScrollViewInsets = NO;
    
    
    @weakify(self);
    
    // webView的偏好设置
    WKPreferences *preferences = [[WKPreferences alloc] init];
    preferences.minimumFontSize = 10;
    preferences.javaScriptEnabled = YES;
    preferences.javaScriptCanOpenWindowsAutomatically = NO;
    
    // webView JS与内容交互
    WKUserContentController *userContentController = [[WKUserContentController alloc] init];
    [userContentController addScriptMessageHandler:self name:@"MichaelHuyp"];
    
    // webView配置
    WKWebViewConfiguration *config = [[WKWebViewConfiguration alloc] init];
    config.preferences = preferences;
    config.userContentController = userContentController;
    
    WKWebView *webView = [[WKWebView alloc] initWithFrame:CGRectMake(0, kAppStatusBarHeight + kAppNavigationBarHeight, YPScreenW, YPScreenH - (kAppStatusBarHeight + kAppNavigationBarHeight)) configuration:config];
    self.webView = webView;
    webView.navigationDelegate = self;
    webView.UIDelegate = self;
    [self.view addSubview:webView];
    
    
    NSString *htmlPath = [[NSBundle mainBundle] pathForResource:@"protocol.html" ofType:nil];
    NSString *appHtml = [NSString stringWithContentsOfFile:htmlPath encoding:NSUTF8StringEncoding error:nil];
    NSURL *baseURL = [NSURL fileURLWithPath:htmlPath];
    [webView loadHTMLString:appHtml baseURL:baseURL];
    
    
    UIProgressView *progressView = [[UIProgressView alloc] initWithProgressViewStyle:UIProgressViewStyleDefault];
    self.progressView = progressView;
    progressView.width = YPScreenW;
    progressView.top = kAppStatusBarHeight + kAppNavigationBarHeight;
    progressView.tintColor = YPBlueColor;
    [self.view addSubview:progressView];
    
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"后退" style:UIBarButtonItemStyleDone target:self action:@selector(back)];
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"前进" style:UIBarButtonItemStyleDone target:self action:@selector(next)];
    
    [RACObserve(self.webView, loading) subscribeNext:^(id x) {
        YPLog(@"loading %@",x);
        @strongify(self);
        BOOL loading = [x boolValue];
        
        if (!loading) {
            self.progressView.alpha = 0.0;
            self.progressView.progress = 0.0f;
            
            NSString *js = @"callJsAlert()";
            [self.webView evaluateJavaScript:js completionHandler:^(id a, NSError * _Nullable error) {
            }];
            
        } else {
            self.progressView.alpha = 1.0;
        }
        
    }];
    
    [RACObserve(self.webView, title) subscribeNext:^(id x) {
        YPLog(@"title %@",x);
        @strongify(self);
        self.title = x;
    }];
    
    
    [RACObserve(self.webView, estimatedProgress) subscribeNext:^(id x) {
        YPLog(@"estimatedProgress %@",x);
        @strongify(self);
        [self.progressView setProgress:[x floatValue] animated:YES];
    }];
    
    

}

#pragma mark - Private
- (void)back
{
    if ([self.webView canGoBack]) {
        YPLog(@"后退");
        [self.webView goBack];
    }

}

- (void)next
{
    if ([self.webView canGoForward]) {
        YPLog(@"前进");
        [self.webView goForward];
    }
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


#pragma mark - WKNavigationDelegate
- (void)webView:(WKWebView *)webView didFinishNavigation:(null_unspecified WKNavigation *)navigation
{
    NSString *js = [NSString stringWithFormat:@"getNameAndIDCardFuction('%@','%@');",@"呵呵",@"21003321312321"];
    
    [webView evaluateJavaScript:js completionHandler:nil];
}

@end












































