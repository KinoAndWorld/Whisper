//
//  LoginController.m
//  Whisper
//
//  Created by kino on 14-9-22.
//
//

#import "LoginController.h"
#import "RegisterController.h"

#import "ContactListController.h"
#import "FriendListController.h"
//#import "con"
//
#import "UserMangaer.h"

#import "UIAlertView+Blocks.h"
#import <AMSmoothAlert/AMSmoothAlertView.h>
#import "UIViewController+Display.h"

@interface LoginController()<UITextFieldDelegate>

@property (weak, nonatomic) IBOutlet UITextField *userNameBox;

@property (weak, nonatomic) IBOutlet UITextField *passwordBox;

@property (weak, nonatomic) IBOutlet UIButton *loginButton;

- (IBAction)loginAction:(id)sender;

@end

@implementation LoginController


- (void)viewDidLoad{
    [super viewDidLoad];
    
    [self initView];
}



- (void)initView{
    UITapGestureRecognizer *tapGuset = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapView)];
    [self.view addGestureRecognizer:tapGuset];
}

- (void)tapView{
    [self.view endEditing:YES];
}

- (IBAction)registerAction:(id)sender {
    RegisterController *dest = (RegisterController *)[self controllerFromBoardByClassName:@"RegisterController"];
    dest.parVC = self;
    [self presentViewController:dest animated:YES completion:nil];
    
    
}

- (IBAction)loginAction:(UIButton *)sender {
    [sender setTitle:@"登录中..." forState:UIControlStateNormal];
    sender.enabled = NO;
    
    
    [[UserMangaer sharedInstance] loginByName:_userNameBox.text
                                     password:_passwordBox.text
                                  withSucceed:^{
                                      [self removeFromParentViewController];
                                      [self.view removeFromSuperview];
//                                      [self dismissViewControllerAnimated:YES completion:nil];
                                  } withFail:^(NSError *err) {
                                      
                                      [self showFailureAlertView:@"登录失败"];
                                      
                                      [sender setTitle:@"登录" forState:UIControlStateNormal];
                                      sender.enabled = YES;
                                  }];
}


- (BOOL)textFieldShouldReturn:(UITextField *)textField{
    if ([textField isEqual:_passwordBox]) {
        [self.view endEditing:YES];
        [self loginAction:nil];
    }
    return YES;
}

@end
