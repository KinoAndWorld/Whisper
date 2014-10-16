//
//  ContactManager.h
//  Whisper
//
//  Created by kino on 14-10-11.
//
//

#import <Foundation/Foundation.h>


typedef void(^WhenAllContactRefreshBlock)();

@interface ContactManager : NSObject

DECLARE_SINGLETON_FOR_CLASS(ContactManager)


@property (copy, nonatomic) WhenAllContactRefreshBlock contactHasBeenRefresh;


//最近聊天
@property (strong, nonatomic, readonly) NSMutableArray *recentContacts;

//所有联系人
@property (strong, nonatomic, readonly) NSMutableArray *allContacts;

@end
