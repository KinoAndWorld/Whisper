//
//  XmppManager.m
//  Whisper
//
//  Created by kino on 14-9-23.
//
//

#import "XmppManager.h"
#import "XMPPFramework.h"


#import "User.h"
#import "UserMangaer.h"
#import "Message.h"


#import "DDXML.h"

@interface XmppManager()<XMPPStreamDelegate,XMPPRosterDelegate>

@property (strong , nonatomic) XMPPStream *xmppStream;
@property (copy, nonatomic) NSString *pwd;
@property (nonatomic) BOOL isOpen;

@property (strong, nonatomic) XMPPJID *queryJid;
//好友

@property (strong, nonatomic) XMPPRoster *xmppRoster;//用户对象
@property (strong, nonatomic) XMPPRosterCoreDataStorage *xmppRosterStorage;
@property (strong, nonatomic) XMPPCapabilitiesCoreDataStorage *xmppCapabilitiesStorage;
@property (strong, nonatomic) XMPPCapabilities *xmppCapabilities;
//资料卡

@property (strong, nonatomic) XMPPvCardTempModule *vCardTempModule;
@property (strong, nonatomic) XMPPvCardCoreDataStorage *vCardStorage;


//
@property (strong, nonatomic) XMPPReconnect *xmppReconnect;

@end

@implementation XmppManager

SYNTHESIZE_SINGLETON_FOR_CLASS(XmppManager)

#pragma mark - XMPP method

- (XMPPStream *)xmppStream{
    if (!_xmppStream) {
        [self setupStream];
    }
    return _xmppStream;
}

- (BOOL)connectWithUser:(User *)user
            withSuccess:(LoginSeccessBlock)loginSeccess
               withFail:(LoginFailBlock)loginFail{
    self.loginFail = loginFail;
    self.loginSeccess = loginSeccess;
    
    if (![_xmppStream isDisconnected]) {
        return YES;
    }
    
    //设置用户
    [_xmppStream setMyJID:[XMPPJID jidWithString:user.name]];
    //设置服务器
    [_xmppStream setHostName:kSERVER];
//    [_xmppStream setHostPort:9090];
    //密码
    _pwd = user.password;
    
    //连接服务器
    NSError *error = nil;
    if (![_xmppStream connectWithTimeout:20 error:&error]) {
        NSLog(@"cant connect %@", kSERVER);
        return NO;
    }
    
    return YES;
}

- (BOOL)connectWithSuccess:(LoginSeccessBlock)loginSeccess
                  withFail:(LoginFailBlock)loginFail{
    return [self connectWithUser:[User userByName:kUSERID password:kPwd]
                       withSuccess:loginSeccess
                        withFail:loginFail];
}

- (void)setupStream{
    _xmppStream = [[XMPPStream alloc] init];
    
    
    _xmppRosterStorage = [[XMPPRosterCoreDataStorage alloc] init];
    //	xmppRosterStorage = [[XMPPRosterCoreDataStorage alloc] initWithInMemoryStore];
    _xmppRoster = [[XMPPRoster alloc] initWithRosterStorage:_xmppRosterStorage];
    
    _xmppRoster.autoFetchRoster = YES;
    _xmppRoster.autoAcceptKnownPresenceSubscriptionRequests = YES;
    
    _xmppCapabilitiesStorage = [XMPPCapabilitiesCoreDataStorage sharedInstance];
    _xmppCapabilities = [[XMPPCapabilities alloc] initWithCapabilitiesStorage:_xmppCapabilitiesStorage];
    
    _xmppCapabilities.autoFetchHashedCapabilities = YES;
    _xmppCapabilities.autoFetchNonHashedCapabilities = NO;
    //card
    _vCardStorage = [XMPPvCardCoreDataStorage sharedInstance];
    _vCardTempModule = [[XMPPvCardTempModule alloc]
                        initWithvCardStorage:_vCardStorage
                        dispatchQueue:dispatch_get_main_queue()];
    
    [_xmppRoster addDelegate:self delegateQueue:dispatch_get_main_queue()];
    [_xmppStream addDelegate:self delegateQueue:dispatch_get_main_queue()];
    
    
    [_xmppRoster            activate:_xmppStream];
    [_xmppCapabilities      activate:_xmppStream];
    
    [_vCardTempModule       activate:_xmppStream];
}

- (void)disconnect{
    [self outOfLine];
    
    [_xmppStream disconnect];
    
    [_xmppStream removeDelegate:self];
    [_xmppRoster removeDelegate:self];
    [_vCardTempModule removeDelegate:self];
    
    [_xmppReconnect         deactivate];
    [_xmppRoster            deactivate];
    
    [_vCardTempModule   deactivate];
//    [_xmppvCardAvatarModule deactivate];
    [_xmppCapabilities      deactivate];

}

- (void)linkOnline{
    //发送在线状态
    XMPPPresence *presence = [XMPPPresence presence];
    [_xmppStream sendElement:presence];
    
    if (_loginSeccess) {
        _loginSeccess();
    }
}

- (void)outOfLine{
    XMPPPresence *presence = [XMPPPresence presenceWithType:@"unavailable"];
    [_xmppStream sendElement:presence];
}

#pragma mark - CoreData

- (NSManagedObjectContext *)managedObjectContext_roster{
    return [_xmppRosterStorage mainThreadManagedObjectContext];
}

- (NSManagedObjectContext *)managedObjectContext_capabilities{
    return [_xmppCapabilitiesStorage mainThreadManagedObjectContext];
}

#pragma mark - XMPPStreamDelegate

//连接服务器
- (void)xmppStreamDidConnect:(XMPPStream *)sender{
    
    _isOpen = YES;
    NSError *error = nil;
    
    //如果是注册，不需要验证密码
    if (self.currentType == ConnectTypeRegister) {
        [self continueRegister];
        return;
    }
//    [_xmppStream registerWithPassword:_pwd error:nil];
    //验证密码
    if ([_xmppStream supportsInBandRegistration]) {
        if (![[self xmppStream] authenticateWithPassword:_pwd error:&error]){
            NSLog(@"Error authenticating: %@", error);
        }
    }
}

- (void)xmppStream:(XMPPStream *)sender didReceiveError:(NSXMLElement *)error{
    NSLog(@"%@",error);
    
    
}


//注册用户
- (void)xmppStreamDidRegister:(XMPPStream *)sender{
    if (_currentType == ConnectTypeRegister) {
        if (self.registerSeccess) {
            self.registerSeccess();
        }
    }
}

- (void)xmppStream:(XMPPStream *)sender didNotRegister:(NSXMLElement *)error{
    
    if (_currentType == ConnectTypeRegister) {
        if (self.registerFail) {
//            [error elementForName:@""];
            NSError *err = [NSError errorWithDomain:@"该用户名已经被注册了噢" code:-2003 userInfo:nil];
            self.registerFail(err);
        }
    }
}


//验证通过
- (void)xmppStreamDidAuthenticate:(XMPPStream *)sender{
    
    [self linkOnline];
}

//不通过
- (void)xmppStream:(XMPPStream *)sender didNotAuthenticate:(NSXMLElement *)error{
    NSLog(@"%@",error);
    
    if (_loginFail) {
        _loginFail([NSError errorWithDomain:error.description code:-1 userInfo:nil]);
    }
    
    [_xmppStream registerWithPassword:_pwd error:nil];
}

#pragma mark - 好友

- (void)queryRoster{
    
    [self.xmppRoster fetchRoster];
//    NSXMLElement *query = [NSXMLElement elementWithName:@"query" xmlns:@"jabber:iq:roster"];
//    NSXMLElement *iq = [NSXMLElement elementWithName:@"iq"];
//    XMPPJID *myJID = self.xmppStream.myJID;
//    [iq addAttributeWithName:@"from" stringValue:myJID.description];
//    [iq addAttributeWithName:@"to" stringValue:myJID.domain];
//    [iq addAttributeWithName:@"id" stringValue:[self generateID]];
//    [iq addAttributeWithName:@"type" stringValue:@"get"];
//    [iq addChild:query];
//    [self.xmppStream sendElement:iq];
}

/// ========  XMPPRosterDelegate  =========
- (BOOL)xmppStream:(XMPPStream *)sender didReceiveIQ:(XMPPIQ *)iq
{
//    DDLogVerbose(@"%@: %@", THIS_FILE, THIS_METHOD);
    NSLog(@"%@",iq);
    DDXMLElement *ele = [[[iq elementForName:@"query"] elementForName:@"item"]elementForName:@"group"];
    if (ele) {
        NSString *name = ele.stringValue;
        if ([name isEqualToString:@"联系人列表"]) {
            [[NSNotificationCenter defaultCenter] postNotificationName:kAllContactHasFetched object:nil];
            return YES;
        }
    }
    
    //联系人资料
    if(_currentType == ConnectTypeFetchUserCard){
        _currentType = ConnectTypeNone;
        ele = [iq elementForName:@"vCard"];
        if (ele) {
            [[NSNotificationCenter defaultCenter] postNotificationName:kFetchUserCard object:@(YES)];
            [self continueAddUser];
        }else{
            [[NSNotificationCenter defaultCenter] postNotificationName:kFetchUserCard object:@(NO)];
        }
        return YES;
    }
    return NO;
}


//收到消息
- (void)xmppStream:(XMPPStream *)sender didReceiveMessage:(XMPPMessage *)message{
    
    //    NSLog(@"message = %@", message);
    
    NSString *msg = [[message elementForName:@"body"] stringValue];
    NSString *from = [[message attributeForName:@"from"] stringValue];
    
    if (!msg && from) {
        //对方正在输入...   暂时不加额外信息
        [[NSNotificationCenter defaultCenter] postNotificationName:kTypingMessage object:nil];
    }
    if(!msg || !from) return;
    
    Message *recMeg = [Message messageWithFrom:from content:msg];
    //发送消息通知
    [[NSNotificationCenter defaultCenter] postNotificationName:kHasRecieveMessage object:recMeg];
    
}

//收到好友状态
- (void)xmppStream:(XMPPStream *)sender didReceivePresence:(XMPPPresence *)presence{
    
    //    NSLog(@"presence = %@", presence);
    //取得好友状态
    NSString *presenceType = [presence type]; //online/offline
    //当前用户
    NSString *userId = [[sender myJID] user];
    //在线用户
    NSString *presenceFromUser = [[presence from] user];
    
    if (![presenceFromUser isEqualToString:userId]) {
        
        //在线状态
//        if ([presenceType isEqualToString:@"available"]) {
//            
//            //用户列表委托(后面讲)
//            [_chatDeleagte fetchBuddyOnline:[NSString stringWithFormat:@"%@@%@", presenceFromUser, @"nqc1338a"]];
//            
//        }else if ([presenceType isEqualToString:@"unavailable"]) {
//            //用户列表委托(后面讲)
//            [_chatDeleagte buddyOutOffline:[NSString stringWithFormat:@"%@@%@", presenceFromUser, @"nqc1338a"]];
//        }
    }
    
    //对方通过了你的好友请求并且添加你为好友
    if ([presenceType isEqualToString:@"subscribed"]) {
        XMPPJID *jid = [XMPPJID jidWithString:[NSString stringWithFormat:@"%@",[presence from]]];
        [_xmppRoster acceptPresenceSubscriptionRequestFrom:jid andAddToRoster:YES];
        
        [[NSNotificationCenter defaultCenter] postNotificationName:kAceptRosterRequest object:jid];
    }
    
}

#pragma mark - 处理加好友回调,加好友
///添加好友
- (void)addFriendSubscribe:(NSString *)name{
    //XMPPHOST 就是服务器名，  主机名
    
    
    //先判断用户是否存在
    [self fetchUserInfoByName:name];
    
    //[presence addAttributeWithName:@"subscription" stringValue:@"好友"];
    //[_xmppRoster subscribePresenceToUser:jid];
}


- (void)xmppRoster:(XMPPRoster *)sender didReceivePresenceSubscriptionRequest:(XMPPPresence *)presence{
    //取得好友状态
    NSString *presenceType = [NSString stringWithFormat:@"%@", [presence type]]; //online/offline
    //请求的用户
    NSString *presenceFromUser =[NSString stringWithFormat:@"%@", [[presence from] user]];
    NSLog(@"presenceType:%@",presenceType);
    
    NSLog(@"presence2:%@  sender2:%@",presence,sender);
    
    XMPPJID *jid = [XMPPJID jidWithString:presenceFromUser];
    [_xmppRoster acceptPresenceSubscriptionRequestFrom:jid andAddToRoster:YES];
}

- (void)removeBuddy:(NSString *)name{
    XMPPJID *jid = [XMPPJID jidWithString:[NSString stringWithFormat:@"%@@%@",name,@"kino.local"]];
    
    [self.xmppRoster removeUser:jid];
}

//获取用户资料
- (void)fetchUserInfoByName:(NSString *)name{
    XMPPJID *jid = [XMPPJID jidWithString:[NSString stringWithFormat:@"%@@%@",name,@"kino.local"]];
    
    [_vCardTempModule fetchvCardTempForJID:jid ignoreStorage:NO];
    _vCardTemp = [_vCardTempModule vCardTempForJID:jid shouldFetch:YES];
    
    _currentType = ConnectTypeFetchUserCard;
    
    _queryJid = jid;
}

- (void)continueAddUser{
    
    [_xmppRoster addUser:_queryJid withNickname:@""];
}

#pragma mark - 注册

- (void)registerWithUser:(User *)user
             withSuccess:(LoginSeccessBlock)regSeccess
                withFail:(LoginFailBlock)regFail{
    self.registerSeccess = regSeccess;
    self.registerFail = regFail;
    
    if (self.xmppStream.isConnecting || self.xmppStream.isConnected) {
        [_xmppStream disconnect];
    }
    
    NSError *err;
    NSString *tjid = [[NSString alloc] initWithFormat:@"anonymous@kino.local"];
    
    [_xmppStream setMyJID:[XMPPJID jidWithString:tjid]];
    [_xmppStream setHostName:kSERVER];
    
    if (![self.xmppStream connectWithTimeout:20 error:&err]){
        NSError *err = [NSError errorWithDomain:@"连接服务器失败" code:-2001 userInfo:nil];
        
        regFail(err);
        return;
    }
    [UserMangaer sharedInstance].perpareRegUser = user;
    self.currentType = ConnectTypeRegister;
}

- (void)continueRegister{
    
    NSString *jid = [[NSString alloc] initWithFormat:@"%@@%@",
                     [UserMangaer sharedInstance].perpareRegUser.name, @"kino.local"];
    
    [self.xmppStream setMyJID:[XMPPJID jidWithString:jid]];
    NSError *error = nil;
    
    if (![self.xmppStream registerWithPassword:[UserMangaer sharedInstance].perpareRegUser.password
                                         error:&error]){
        NSError *err = [NSError errorWithDomain:@"创建帐号失败" code:-2002 userInfo:nil];
        self.registerFail(err);
    }
}

@end
