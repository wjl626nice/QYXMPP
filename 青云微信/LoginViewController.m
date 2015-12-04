//
//  LoginViewController.m
//  青云微信
//
//  Created by 青云-wjl on 15/11/29.
//  Copyright (c) 2015年 河南青云信息技术有限公司. All rights reserved.
//

#import "LoginViewController.h"

@interface LoginViewController ()
@property (weak, nonatomic) IBOutlet UITextField *userName;
@property (weak, nonatomic) IBOutlet UITextField *passWord;
@property (weak, nonatomic) IBOutlet UITextField *server;

@end

@implementation LoginViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}
- (IBAction)done:(id)sender {
    
    //保存用户名、密码、服务器
    [[NSUserDefaults standardUserDefaults] setObject:_userName.text forKey:@"wxID"];
    [[NSUserDefaults standardUserDefaults] setObject:_passWord.text forKey:@"wxPWD"];
    [[NSUserDefaults standardUserDefaults] setObject:_server.text forKey:@"wxServer"];
    
    //同步用户配置
    [[NSUserDefaults standardUserDefaults] synchronize];
    
    [self dismissViewControllerAnimated:YES completion:^{
        if (_login) {
            _login();
        }
    }];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
    
    
}
*/



@end
