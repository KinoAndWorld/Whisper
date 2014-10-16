//
//  Message.m
//  Whisper
//
//  Created by kino on 14-10-15.
//
//

#import "Message.h"

@implementation Message


- (instancetype)initWithFrom:(NSString *)from content:(NSString *)content{
    if (self = [super init]) {
        self.from = from;
        self.content = content;
    }
    return self;
}

+ (instancetype)messageWithFrom:(NSString *)from content:(NSString *)content{
    return [[self alloc] initWithFrom:from content:content];
}

@end
