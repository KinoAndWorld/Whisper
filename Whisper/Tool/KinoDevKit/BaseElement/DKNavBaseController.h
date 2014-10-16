//
//  DKNavBaseController.h
//  KinoDevKitDemo
//
//  Created by kino on 14-9-12.
//  Copyright (c) 2014年 kino. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface DKNavBaseController : UIViewController

@property (strong, nonatomic) UIView *loadingView;
@property (strong, nonatomic) UIImageView *loadingImage;
@property (strong, nonatomic) UIView *loadFailView;

//blank
@property (strong, nonatomic) UIView *blankView;
@property (strong, nonatomic) UIImageView *blankImageView;
@property (strong, nonatomic) UILabel *blankMessageLabel;

@property (assign, nonatomic) BOOL isLoadingData;

- (void)initialize;

#pragma mark - Navgation Item Button

- (void)setLeftBarButtonItem:(UIImage *)buttonImage withSelector:(SEL)sel;
- (void)setRightBarButtonItem:(UIImage *)buttonImage withSelector:(SEL)sel;

- (void)setLeftBarButtonItem:(UIImage *)buttonImage
                 selectImage:(UIImage *)selectedImage
                       title:(NSString *)title
                  titleColor:(UIColor *)color
                    fontSize:(UIFont *)font
                withSelector:(SEL)sel;

- (void)setRightBarButtonItem:(UIImage *)buttonImage
                  selectImage:(UIImage *)selectedImage
                        title:(NSString *)title
                   titleColor:(UIColor *)color
                     fontSize:(UIFont *)font
                 withSelector:(SEL)sel;


#pragma mark - Load View
/**
 *  加载视图
 */
- (void)startLoading;
- (void)startLoadingWithAlpha:(CGFloat)alpha;
- (void)startLoadingWithAlpha:(CGFloat)alpha withFrame:(CGRect)frame;

- (void)stopLoading;

/**
 *  停止加载并且显示错误提示页面
 */
- (void)stopLoadingAndShowError;

/**
 *  重试 调用各自的API
 */
- (void)recallRequest;

- (void)showBlankView:(UIView *)view message:(NSString *)message;
- (void)showBlankViewWithFrame:(CGRect)frame message:(NSString *)message;

- (void)hideBlankView;


@end
