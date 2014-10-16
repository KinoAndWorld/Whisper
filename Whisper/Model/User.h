//
//  User.h
//  Whisper
//
//  Created by kino on 14-9-22.
//
//

#import <Foundation/Foundation.h>

#import "KinoDevKit.h"
#import "MJExtension.h"

@class UserCheckResult;

@interface User : NSObject

KOString name;
KOString password;
KOString authToken;



+ (UserCheckResult *)getValidByUser:(User *)user;

+ (instancetype)userByName:(NSString *)name
                  password:(NSString *)password;


@end

@interface UserCheckResult : NSObject

KOBool value;
KOString resultString;

+ (instancetype)resultByValue:(BOOL)value
                       result:(NSString *)resultString;

@end
