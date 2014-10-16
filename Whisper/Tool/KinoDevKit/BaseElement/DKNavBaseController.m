//
//  DKNavBaseController.m
//  KinoDevKitDemo
//
//  Created by kino on 14-9-12.
//  Copyright (c) 2014年 kino. All rights reserved.
//

#import "DKNavBaseController.h"

@interface DKNavBaseController()

@property (assign, nonatomic) CGRect targetFrame;

@end

@implementation DKNavBaseController

- (void)initialize{
    
}

- (void)viewDidLoad{
    [super viewDidLoad];
    [self initialize];
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
}

- (void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
}

- (void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
}


#pragma mark - Navgation Item Button

#define kDefaultFont  [UIFont boldSystemFontOfSize:15.f]
#define kDefaultColor [UIColor blackColor]

- (void)setLeftBarButtonItem:(UIImage *)buttonImage withSelector:(SEL)sel{
    [self setLeftBarButtonItem:buttonImage
                   selectImage:buttonImage
                         title:@""
                    titleColor:kDefaultColor
                      fontSize:kDefaultFont
                  withSelector:sel];
}


- (void)setLeftBarButtonItem:(UIImage *)buttonImage
                 selectImage:(UIImage *)selectedImage
                       title:(NSString *)title
                  titleColor:(UIColor *)color
                    fontSize:(UIFont *)font
                withSelector:(SEL)sel{
    UIButton *btnLeft = [UIButton buttonWithType:UIButtonTypeCustom];
    
    [btnLeft setBackgroundImage:buttonImage forState:UIControlStateNormal];
    [btnLeft setBackgroundImage:selectedImage forState:UIControlStateHighlighted];
    
    [btnLeft setTitle:title forState:UIControlStateNormal];
    [btnLeft setTitleColor:color forState:UIControlStateNormal];
    [btnLeft.titleLabel setFont:font];
    btnLeft.frame = CGRectMake(0, 0, buttonImage.size.width, buttonImage.size.height);
    
    UIBarButtonItem *barItemLeft =[[UIBarButtonItem alloc] initWithCustomView:btnLeft];
    [btnLeft addTarget:self action:sel forControlEvents:UIControlEventTouchUpInside];
    self.navigationItem.leftBarButtonItem = barItemLeft;
}


- (void)setRightBarButtonItem:(UIImage *)buttonImage withSelector:(SEL)sel{
    //nav bar item
    [self setRightBarButtonItem:buttonImage
                    selectImage:buttonImage
                          title:@""
                     titleColor:kDefaultColor
                       fontSize:kDefaultFont
                   withSelector:sel];
}

- (void)setRightBarButtonItem:(UIImage *)buttonImage
                  selectImage:(UIImage *)selectedImage
                        title:(NSString *)title
                   titleColor:(UIColor *)color
                     fontSize:(UIFont *)font
                 withSelector:(SEL)sel{
    //nav bar item
    UIButton *btnRight = [UIButton buttonWithType:UIButtonTypeCustom];
    
    [btnRight setBackgroundImage:buttonImage forState:UIControlStateNormal];
    [btnRight setBackgroundImage:selectedImage forState:UIControlStateHighlighted];
    
    [btnRight setTitle:title forState:UIControlStateNormal];
    [btnRight setTitleColor:color forState:UIControlStateNormal];
    [btnRight.titleLabel setFont:font];
    btnRight.frame = CGRectMake(0, 0, buttonImage.size.width, buttonImage.size.height);
    
    UIBarButtonItem *barItemRight =[[UIBarButtonItem alloc] initWithCustomView:btnRight];
    [btnRight addTarget:self action:sel forControlEvents:UIControlEventTouchUpInside];
    self.navigationItem.rightBarButtonItem = barItemRight;
}

#pragma mark - Load View

/**
 *  common show
 */

- (UIView *)loadingView{
//    if (!_loadingView) {
//        _loadingView = [[UIView alloc] initWithFrame:self.targetFrame];
//        _loadingView.backgroundColor = [UIColor backgroundLightColor];
//        [_loadingView addSubview:self.loadingImage];
//        //
//        UILabel *lbl = [[UILabel alloc] initWithFrame:CGRectMake(5, 0, _loadingView.width, 30)];
//        lbl.text = @"正在加载中...";
//        lbl.top = _loadingImage.bottom + 5;
//        lbl.backgroundColor = [UIColor clearColor];
//        lbl.textColor = [UIColor darkGrayColor];
//        lbl.font = [UIFont systemFontOfSize:15.f];
//        lbl.textAlignment = NSTextAlignmentCenter;
//        [_loadingView addSubview:lbl];
//        
//    }else{
//        [self.loadingImage removeFromSuperview];
//        [_loadingView addSubview:self.loadingImage];
//    }
    return _loadingView;
}

- (UIImageView *)loadingImage{
    if (!_loadingImage) {
        _loadingImage = [[UIImageView alloc] initWithFrame:CGRectMake(_targetFrame.size.width/2 - 45, _targetFrame.size.height/2 - 80, 90, 90)];
        NSMutableArray *tmpArr = [NSMutableArray array];
        for (int i = 0; i < 2; i++) {
            UIImage *image = [UIImage imageNamed:[NSString stringWithFormat:@"c%d",i+1]];
            [tmpArr addObject:image];
        }
        [_loadingImage setAnimationImages:[NSArray arrayWithArray:tmpArr]];
        _loadingImage.animationDuration = 0.3;
    }
    return _loadingImage;
}

- (UIView *)loadFailView{
//    if (!_loadFailView) {
//        _loadFailView = [[UIView alloc] initWithFrame:self.view.frame];
//        _loadFailView.backgroundColor = [UIColor colorWithWhite:1.000 alpha:1];
//        
//        UIImageView *netErrImageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 89, 69)];//178 138
//        netErrImageView.image = [UIImage imageNamed:@"networkError"];
//        netErrImageView.center = CGPointMake(_loadFailView.centerX , _loadFailView.centerY - 100);
//        [_loadFailView addSubview:netErrImageView];
//        //
//        UILabel *lbl = [[UILabel alloc] initWithFrame:CGRectMake(0, netErrImageView.bottom + 20,
//                                                                 _loadFailView.width, 30)];
//        lbl.text = @"当前网络状态异常或无网络";
//        lbl.textColor = [UIColor grayColor];
//        lbl.font = [UIFont systemFontOfSize:12.f];
//        lbl.textAlignment = NSTextAlignmentCenter;
//        lbl.backgroundColor = [UIColor clearColor];
//        [_loadFailView addSubview:lbl];
//        //button
//        UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
//        btn.frame = CGRectMake(_loadFailView.width/2 - 100, lbl.bottom + 20, 200, 35);
//        btn.titleLabel.font = [UIFont systemFontOfSize:16.f];
//        [btn setTitle:@"点击重试" forState:UIControlStateNormal];
//        [btn setBackgroundImage:[UIImage imageNamed:@"mainOKButton"]
//                       forState:UIControlStateNormal];
//        [btn setBackgroundImage:[UIImage imageNamed:@"mainOKButton_selected"]
//                       forState:UIControlStateHighlighted];
//        
//        //[btn setBackgroundImage:[UIImage imageNamed:@"mainOKButton"] forState:UIControlStateNormal];
//        [btn addTarget:self action:@selector(recallRequest) forControlEvents:UIControlEventTouchUpInside];
//        [_loadFailView addSubview:btn];
//    }
    return _loadFailView;
}

- (UIView *)blankView{
//    if (!_blankView) {
//        _blankView = [[UIView alloc] initWithFrame:_targetFrame];
//        _blankView.top = 0;
//        _blankView.left = 0;
//        _blankView.backgroundColor = [UIColor backgroundLightColor];
//        _blankImageView = [[UIImageView alloc] initWithFrame:CGRectMake(_blankView.width/2 - 45, _blankView.height/2 - 60, 89, 69)];//178 138
//        _blankImageView.image = [UIImage imageNamed:@"myOrderBlank"];
//        //_blankImageView.center = CGPointMake(_blankView.centerX , _blankView.centerY - 150);
//        [_blankView addSubview:_blankImageView];
//        //
//        _blankMessageLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, _blankImageView.bottom + 20,
//                                                                       _blankView.width, 30)];
//        _blankMessageLabel.text = @"暂时没有任何数据";
//        _blankMessageLabel.textColor = [UIColor grayColor];
//        _blankMessageLabel.font = [UIFont systemFontOfSize:15.f];
//        _blankMessageLabel.textAlignment = NSTextAlignmentCenter;
//        _blankMessageLabel.backgroundColor = [UIColor clearColor];
//        
//        [_blankView addSubview:_blankMessageLabel];
//    }
//    
//    _blankView.frame = _targetFrame;
//    _blankImageView.frame = CGRectMake(_blankView.width/2 - 45, _blankView.height/2 - 60, 89, 69);
//    _blankMessageLabel.frame = CGRectMake(0, _blankImageView.bottom + 20,
//                                          _blankView.width, 30);
    
    return _blankView;
}

- (void)startLoading{
    self.targetFrame = self.view.frame;
    [self.view addSubview:self.loadingView];
    [self.loadingImage startAnimating];
    
    _isLoadingData = YES;
}

- (void)startLoadingWithAlpha:(CGFloat)alpha{
    
    [self startLoading];
    if (alpha >0 && alpha<=1.0) {
        _loadingView.alpha = alpha;
    }
}

- (void)startLoadingWithAlpha:(CGFloat)alpha withFrame:(CGRect)frame{
    self.targetFrame = frame;
    [self.view addSubview:self.loadingView];
    [self.loadingImage startAnimating];
    
    if (alpha >0 && alpha<1.0) {
        _loadingView.alpha = alpha;
    }
    _isLoadingData = YES;
}


- (void)stopLoading{
    _isLoadingData = NO;
    
    [self.loadingImage stopAnimating];
    [self.loadingView removeFromSuperview];
    [self.loadFailView removeFromSuperview];
}

/**
 *  停止加载并且显示错误提示页面
 */
- (void)stopLoadingAndShowError{
    [self stopLoading];
    [self.view addSubview:self.loadFailView];
}

/**
 *  重试 调用各自的API
 */
- (void)recallRequest{
    [self.loadFailView removeFromSuperview];
    //will call continue.
}

//空白视图
- (void)showBlankView:(UIView *)view message:(NSString *)message{
    UIView *targetView =  view ? view : self.view;
    //    targetView.backgroundColor = [UIColor yellowColor];
    _targetFrame = targetView.frame;
    _targetFrame.origin.x = 0;
    _targetFrame.origin.y = 0;
    [self.view addSubview:self.blankView];
    
    _blankMessageLabel.text = message;
}

- (void)showBlankViewWithFrame:(CGRect)frame message:(NSString *)message{
    _targetFrame = frame;
    [self.view addSubview:self.blankView];
    
    _blankMessageLabel.text = message;
}

- (void)hideBlankView{
    [self.blankView removeFromSuperview];
}

@end
