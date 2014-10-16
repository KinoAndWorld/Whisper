//
//  RootViewController.m
//  Whisper
//
//  Created by kino on 14-10-11.
//
//

#import "RootViewController.h"

#import "UserMangaer.h"

#import "LoginController.h"

//
#import <AMSmoothAlert/AMSmoothAlertView.h>

@interface RootViewController ()

@end

@implementation RootViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    if ([[UserMangaer sharedInstance] isLogin] == NO) {
        LoginController *loginVC = (LoginController *)[self controllerFromBoardByClassName:@"LoginController"];
        [self addChildViewController:loginVC];
        [self.view addSubview:loginVC.view];
        
//        [self presentViewController:loginVC animated:NO completion:nil];
    }else{
        UIViewController *firstVC = [[self.viewControllers[0] viewControllers] objectAtIndex:0];
        firstVC.title = @"连接中...";
        User *user = [UserMangaer sharedInstance].user;
        
        //连接
        [[UserMangaer sharedInstance] loginByUser:user
                                      withSucceed:^{
                                          UIViewController *firstVC = [[self.viewControllers[0] viewControllers] objectAtIndex:0];
                                          firstVC.title = @"轻语";
                                          
                                      } withFail:^(NSError *err) {
                                          AMSmoothAlertView *alert = [[AMSmoothAlertView alloc]
                                                                      initDropAlertWithTitle:@"提示"
                                                                      andText:@"登录失败"
                                                                      andCancelButton:NO
                                                                      forAlertType:AlertFailure
                                                                      withCompletionHandler:^(AMSmoothAlertView *view, UIButton *button) {}];
                                          alert.cornerRadius = 20;
                                          [alert show];
                                      }];
    }
    
    
}



- (void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
    
    
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
