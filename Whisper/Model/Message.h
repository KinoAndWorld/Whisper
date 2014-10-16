//
//  Message.h
//  Whisper
//
//  Created by kino on 14-10-15.
//
//

#import <Foundation/Foundation.h>

@interface Message : NSObject

KOString from;
KOString content;


- (instancetype)initWithFrom:(NSString *)from content:(NSString *)content;

+ (instancetype)messageWithFrom:(NSString *)from content:(NSString *)content;

@end
