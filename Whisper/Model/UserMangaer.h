//
//  UserMangaer.h
//  Whisper
//
//  Created by kino on 14-10-11.
//
//

#import <Foundation/Foundation.h>

#import "User.h"
#import "XmppManager.h"


@interface UserMangaer : NSObject

@property (nonatomic, strong) User *user;

@property (nonatomic, strong) User *perpareRegUser;

DECLARE_SINGLETON_FOR_CLASS(UserMangaer)


- (BOOL)isLogin;


- (BOOL)loginByUser:(User *)user
        withSucceed:(LoginSeccessBlock)loginSucceed
           withFail:(LoginFailBlock)loginFail;

- (BOOL)loginByName:(NSString *)name
           password:(NSString *)pwd
        withSucceed:(LoginSeccessBlock)loginSucceed
           withFail:(LoginFailBlock)loginFail;

@end
