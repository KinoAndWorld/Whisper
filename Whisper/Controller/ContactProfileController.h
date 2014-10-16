//
//  ContactProfileController.h
//  Whisper
//
//  Created by kino on 14-10-13.
//
//

#import "BaseViewController.h"

@class XMPPUserCoreDataStorageObject;

@interface ContactProfileController : BaseViewController

@property (strong, nonatomic) XMPPUserCoreDataStorageObject *contactObject;

@end
