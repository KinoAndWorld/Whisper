//
//  User.m
//  Whisper
//
//  Created by kino on 14-9-22.
//
//

#import "User.h"

@implementation User

MJCodingImplementation;

+ (UserCheckResult *)getValidByUser:(User *)user{
    return [UserCheckResult resultByValue:NO result:@"Just error"];
}

+ (instancetype)userByName:(NSString *)name
                  password:(NSString *)password{
    return [[self alloc] initWithName:name password:password];
}

- (instancetype)initWithName:(NSString *)name
                    password:(NSString *)password{
    if (self = [super init]) {
        self.name = name;
        self.password = password;
    }
    return self;
}

@end

@implementation UserCheckResult


+ (instancetype)resultByValue:(BOOL)value
                                result:(NSString *)resultString{
    UserCheckResult *ucr = [[UserCheckResult alloc] init];
    ucr.value = value;
    ucr.resultString = resultString;
    
    return ucr;
}



@end