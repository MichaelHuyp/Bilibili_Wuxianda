//
//  YPRSALoginViewController.m
//  Wuxianda
//
//  Created by MichaelPPP on 16/5/23.
//  Copyright © 2016年 michaelhuyp. All rights reserved.
//

#import "YPRSALoginViewController.h"

#define ServerURL @"http://192.168.18.110:8080/xfbInterface_test"
#define login ServerURL@"/customer/login.do"

@interface YPRSALoginViewController ()
/** 用户名输入框 */
@property (weak, nonatomic) IBOutlet UITextField *usernameTextField;
/** 用户名输入框 */
@property (weak, nonatomic) IBOutlet UITextField *passwordTextField;

@end

@implementation YPRSALoginViewController

- (void)viewDidLoad {
    [super viewDidLoad];

}


- (IBAction)loginAciton:(id)sender {
    
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    params[@"loginName"] = self.usernameTextField.text;
    params[@"passWord"] = self.passwordTextField.text;
    
    
    [YPRequestTool POST:login parameters:params progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        YPLog(@"%@",responseObject);
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        YPLog(@"%@",error);
    }];
    
}



@end





























































