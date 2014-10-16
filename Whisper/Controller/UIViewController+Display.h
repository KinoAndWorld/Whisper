//
//  UIViewController+Display.h
//  Whisper
//
//  Created by kino on 14-10-11.
//
//

#import <UIKit/UIKit.h>

@interface UIViewController (Display)

- (UIViewController *)controllerFromBoardByClassName:(NSString *)name;

- (void)showBlankView:(NSString *)title;

- (void)showBlankView:(NSString *)title image:(UIImage *)image;

- (void)showBlankView:(NSString *)title customV:(UIView *)customView;

- (void)hideBlankView;

#pragma mark - alert

- (void)showFailureAlertView:(NSString *)msg;

@end
