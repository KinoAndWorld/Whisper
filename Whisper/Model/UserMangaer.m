//
//  UserMangaer.m
//  Whisper
//
//  Created by kino on 14-10-11.
//
//

#import "UserMangaer.h"

#import "MJExtension.h"

NSString *const kSavedUser = @"savedUser";


@interface UserMangaer()

//@property (copy, nonatomic) LoginFailBlock failBlock;
//@property (copy, nonatomic) LoginSeccessBlock succeedBlock;

@end

@implementation UserMangaer

SYNTHESIZE_SINGLETON_FOR_CLASS(UserMangaer)

- (BOOL)isLogin{
    NSData *userData = [USER_DEFAULT objectForKey:kSavedUser];
    User *user = [NSKeyedUnarchiver unarchiveObjectWithData:userData];
//    NSLog(@"%@",user.name);
    if (user) {
        if (!_user) {
            _user = user;
        }
        return YES;
    }
    return NO;
}

- (BOOL)loginByUser:(User *)user
        withSucceed:(LoginSeccessBlock)loginSucceed
           withFail:(LoginFailBlock)loginFail{
    if (!user) {
        return NO;
    }
    
    [[XmppManager sharedInstance] connectWithSuccess:^{
        self.user = user;
        
        [self saveUserLoginInfo];
        
        if (loginSucceed) {
            loginSucceed();
        }
    } withFail:loginFail];
    
    return NO;
}

- (void)saveUserLoginInfo{
    if (self.user) {
        NSData *udObject = [NSKeyedArchiver archivedDataWithRootObject:_user];
        [USER_DEFAULT setObject:udObject forKey:kSavedUser];
        [USER_DEFAULT synchronize];
    }
}

- (BOOL)loginByName:(NSString *)name
           password:(NSString *)pwd
        withSucceed:(LoginSeccessBlock)loginSucceed
           withFail:(LoginFailBlock)loginFail{
    User *user = [User userByName:name password:pwd];
    return  [self loginByUser:user withSucceed:loginSucceed withFail:loginFail];
}

@end
