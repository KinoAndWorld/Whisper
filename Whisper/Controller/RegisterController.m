//
//  RegisterController.m
//  Whisper
//
//  Created by kino on 14-10-13.
//
//

#import "RegisterController.h"

#import "XmppManager.h"
#import "XMPPFramework.h"

#import "User.h"

#import <AMSmoothAlert/AMSmoothAlertView.h>

@interface RegisterController ()

@property (weak, nonatomic) IBOutlet UITextField *userNameBox;
@property (weak, nonatomic) IBOutlet UITextField *pwdBox;


@end

@implementation RegisterController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (IBAction)confirmRegisterAction:(UIButton *)sender {
    [self.view endEditing:YES];
    
    [sender setTitle:@"注册中..." forState:UIControlStateNormal];
    sender.enabled = NO;
    
    User *user = [User userByName:_userNameBox.text password:_pwdBox.text];
    
    [[XmppManager sharedInstance] registerWithUser:user
                                       withSuccess:^{
                                           [self finishRegister];
                                       } withFail:^(NSError *err) {
                                           [self showFailureAlertView:err.domain];
                                           
                                           [sender setTitle:@"确定注册" forState:UIControlStateNormal];
                                           sender.enabled = YES;
                                       }];
}

- (void)finishRegister{
//    UIViewController *firstVC = [[self.tabBarController.viewControllers[0] viewControllers] objectAtIndex:0];
//    firstVC.title = @"轻语";
    
    self.parVC.view.hidden = YES;
    [self dismissViewControllerAnimated:YES completion:^{
        [self.parVC removeFromParentViewController];
        [self.parVC.view removeFromSuperview];
    }];
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
