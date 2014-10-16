//
//  XmppManager.h
//  Whisper
//
//  Created by kino on 14-9-23.
//
//

#import <Foundation/Foundation.h>
#import "DKMacro.h"
#import "ChatDelegate.h"
#import <CoreData/CoreData.h>


#import "NotifitionConfig.h"


#define kUSERID         @"admin@kino.local"
#define kPwd            @"dream"
#define kSERVER         @"localhost"//@"kino.local"//localhost



@class NSManagedObjectContext;

@class XMPPStream;
@class User;
@class XMPPvCardTemp;

typedef void(^LoginSeccessBlock)();
typedef void(^LoginFailBlock)(NSError *);

typedef enum {
    ConnectTypeNone = 0,
    ConnectTypeLogin,
    ConnectTypeRegister,
    ConnectTypeFetchUserCard
}ConnectType;

@interface XmppManager : NSObject

DECLARE_SINGLETON_FOR_CLASS(XmppManager)

@property (nonatomic, weak) id<ChatDelegate> chatDeleagte;
@property (nonatomic, weak) id<MessageDelegate> messageDeleagte;

//login
@property (nonatomic, copy) LoginSeccessBlock loginSeccess;
@property (nonatomic, copy) LoginSeccessBlock loginFail;
//register
@property (nonatomic, copy) LoginSeccessBlock registerSeccess;
@property (nonatomic, copy) LoginSeccessBlock registerFail;

@property (nonatomic, assign) ConnectType currentType;


@property (strong, nonatomic) XMPPvCardTemp *vCardTemp;


- (XMPPStream *)xmppStream;

///
- (BOOL)connectWithSuccess:(LoginSeccessBlock)loginSeccess
                  withFail:(LoginFailBlock)loginFail;

- (BOOL)connectWithUser:(User *)user
            withSuccess:(LoginSeccessBlock)loginSeccess
               withFail:(LoginFailBlock)loginFail;


- (void)disconnect;

- (void)setupStream;

- (void)linkOnline;

- (void)outOfLine;

//添加好友
- (void)addFriendSubscribe:(NSString *)name;
//删除好友
- (void)removeBuddy:(NSString *)name;

- (NSManagedObjectContext *)managedObjectContext_roster;
- (NSManagedObjectContext *)managedObjectContext_capabilities;

//注册
- (void)registerWithUser:(User *)user
             withSuccess:(LoginSeccessBlock)regSeccess
                withFail:(LoginFailBlock)regFail;


@end
