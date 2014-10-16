//
//  HIMenuItem.m
//  HomeInn
//
//  Created by kino on 14-4-15.
//  Copyright (c) 2014年 Kino. All rights reserved.
//

#import "HIMenuItem.h"

@implementation HIMenuItem

+ (instancetype) itemWithIndent:(NSString *)indent
                    contentView:(UIImage *)image
                           info:(id)userInfo{
    return [[self alloc] initWithIndent:indent contentView:image info:userInfo];
}

- (id)initWithIndent:(NSString *)indent
         contentView:(UIImage *)image
                info:(id)userInfo{
    if (self = [super init]) {
        self.cellIndent = indent;
        self.imageIcon = image;
        self.userInfo = userInfo;
    }
    return self;
}

@end
