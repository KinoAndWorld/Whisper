//
//  BaseViewController.m
//  Whisper
//
//  Created by kino on 14-10-12.
//
//

#import "BaseViewController.h"

@interface BaseViewController ()

@end

@implementation BaseViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self configNavgation];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    
    [self checkTabBarHidden:YES];
}

- (void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    
    [self checkTabBarHidden:NO];
}


- (void)checkTabBarHidden:(BOOL)isAppear{
    NSArray *mainVCs = @[@"ContactListController",
                         @"FriendListController",
                         @"RootViewController"];
    
    __block BOOL isMainVC = NO;
    [mainVCs enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
        if ([NSStringFromClass([self class]) isEqualToString:obj]) {
            isMainVC = YES;
            *stop = YES;
        }
    }];
    if (isAppear) {
        if (isMainVC == NO) {
            self.tabBarController.tabBar.hidden = YES;
        }
    }else{
        if (isMainVC == NO) {
            self.tabBarController.tabBar.hidden = NO;
        }
    }
}


- (void)configNavgation{
    // 导航栏
    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleLightContent];
    
    if([UINavigationBar instancesRespondToSelector:@selector(barTintColor)]){ //iOS7
        self.navigationController.navigationBar.barTintColor = [UIColor blackColor];
        [self.navigationController.navigationBar setTitleTextAttributes:
         @{NSForegroundColorAttributeName : [UIColor whiteColor],
           NSFontAttributeName : [UIFont systemFontOfSize:18]}
         ];
        //返回按钮 颜色
        self.navigationController.navigationBar.tintColor = [UIColor orangeColor];
    }else{
        
        self.navigationController.navigationBar.tintColor = [UIColor blackColor];
        
        NSDictionary *textTitleOptions = [NSDictionary dictionaryWithObjectsAndKeys:
                                          [UIColor whiteColor], UITextAttributeTextColor,
                                          [UIFont systemFontOfSize:18], UITextAttributeFont,nil];
        [self.navigationController.navigationBar setTitleTextAttributes:textTitleOptions];
    }
}


@end
