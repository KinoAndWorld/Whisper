//
//  ChatDelegate.h
//  Whisper
//
//  Created by kino on 14-9-23.
//
//

#import <Foundation/Foundation.h>


@protocol ChatDelegate <NSObject>

- (void)fetchBuddyOnline:(NSString *)buddyName;
- (void)buddyOutOffline:(NSString *)buddyName;
- (void)didDisconnect;


@end


@protocol MessageDelegate <NSObject>

//收到消息
- (void)messageRecived:(NSDictionary *)messageContent;

//- (void)messageFailToRecive:(NSDictionary *)messageContent;

@end