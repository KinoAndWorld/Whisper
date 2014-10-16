//
//  UIViewController+MethodSwizzling.m
//  iOS7-NavigationController-Sample
//
//  Created by 魏哲 on 14-5-16.
//
//

#import "UIViewController+MethodSwizzling.h"
#import <objc/runtime.h>

#ifndef kCFCoreFoundationVersionNumber_iOS_6_1
#define kCFCoreFoundationVersionNumber_iOS_6_1 793.00
#endif

#if __IPHONE_OS_VERSION_MAX_ALLOWED > __IPHONE_6_1
#define IF_IOS7_OR_GREATER(...) \
if (kCFCoreFoundationVersionNumber > kCFCoreFoundationVersionNumber_iOS_6_1) \
{ \
__VA_ARGS__ \
}
#else
#define IF_IOS7_OR_GREATER(...)
#endif

@implementation UIViewController (MethodSwizzling)

+ (void)load
{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        {
            Method originMethod = class_getInstanceMethod([self class], @selector(viewDidAppear:));
            Method swizzledMethod = class_getInstanceMethod([self class], @selector(swizzling_viewDidAppear:));
            method_exchangeImplementations(originMethod, swizzledMethod);
        }
    });
}

- (void)swizzling_viewDidAppear:(BOOL)animated
{
    [self swizzling_viewDidAppear:animated];
    IF_IOS7_OR_GREATER(
        self.navigationController.interactivePopGestureRecognizer.enabled = YES;
    );
    
}

@end
