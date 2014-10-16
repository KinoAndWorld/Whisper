//
//  UIViewController+Display.m
//  Whisper
//
//  Created by kino on 14-10-11.
//
//

#import "UIViewController+Display.h"

#import <AMSmoothAlert/AMSmoothAlertView.h>


#define kBlankViewTag 7000

@implementation UIViewController (Display)

- (UIViewController *)controllerFromBoardByClassName:(NSString *)name{
    id dest = [[UIStoryboard storyboardWithName:@"Main" bundle:nil]
               instantiateViewControllerWithIdentifier:name];
    
    return dest;
}

- (UILabel *)blankMsgLabel:(NSString *)text{
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectZero];
    label.font = [UIFont systemFontOfSize:15.f];
    label.textColor = [UIColor grayColor];
    label.text = text;
    label.textAlignment = NSTextAlignmentCenter;
    [label sizeToFit];
    
    return label;
}

- (UIView *)blankViewByString:(NSString *)text{
    UIView *blankView = [self.view viewWithTag:kBlankViewTag];
    if (!blankView) {
        blankView = [[UIView alloc] initWithFrame:self.view.bounds];
        blankView.backgroundColor = [UIColor colorWithWhite:0.8 alpha:1.0];
        blankView.center = self.view.center;
        
        UILabel *msgLabel = [self blankMsgLabel:text];
        msgLabel.center = blankView.center;
        
        [blankView addSubview:msgLabel];
    }
    
    return blankView;
}

- (void)showBlankView:(NSString *)title{
    [self showBlankView:title image:nil];
}

- (void)showBlankView:(NSString *)title image:(UIImage *)image{
    
    UIView *blankView = [self blankViewByString:title];
    [self.view addSubview:blankView];
}

- (void)showBlankView:(NSString *)title customV:(UIView *)customView{
    UIView *blankView = [self blankViewByString:title];
    [self.view addSubview:blankView];
}

- (void)hideBlankView{
    UIView *blankView = [self.view viewWithTag:kBlankViewTag];
    if (blankView) {
        [blankView removeFromSuperview];
    }
}

#pragma mark - 

- (void)showFailureAlertView:(NSString *)msg{
    AMSmoothAlertView *alert = [[AMSmoothAlertView alloc]
                                initDropAlertWithTitle:@"提示"
                                andText:msg
                                andCancelButton:NO
                                forAlertType:AlertFailure
                                withCompletionHandler:^(AMSmoothAlertView *view, UIButton *button) {}];
    alert.cornerRadius = 20;
    [alert show];
}

@end
