//
//  ChatController.h
//  Whisper
//
//  Created by kino on 14-9-23.
//
//

#import "BaseViewController.h"
#import "XMPPUserCoreDataStorageObject.h"

@class XMPPUserCoreDataStorageObject;

@interface ChatController : BaseViewController

@property (strong, nonatomic) XMPPUserCoreDataStorageObject *contactObject;


@end
