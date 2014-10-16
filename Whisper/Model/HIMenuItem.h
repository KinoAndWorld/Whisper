//
//  HIMenuItem.h
//  HomeInn
//
//  Created by kino on 14-4-15.
//  Copyright (c) 2014年 Kino. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface HIMenuItem : NSObject

KOString cellIndent;

KOImage imageIcon;
KOID userInfo;

+ (instancetype) itemWithIndent:(NSString *)indent
                    contentView:(UIImage *)image
                           info:(id)userInfo;

- (id)initWithIndent:(NSString *)indent
         contentView:(UIImage *)image
                info:(id)userInfo;
@end
