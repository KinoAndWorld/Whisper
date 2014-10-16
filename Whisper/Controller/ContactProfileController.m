//
//  ContactProfileController.m
//  Whisper
//
//  Created by kino on 14-10-13.
//
//

#import "ContactProfileController.h"
#import "ChatController.h"

#import "XmppManager.h"

#import "XMPPUserCoreDataStorageObject.h"
#import "XMPPvCardTemp.h"

#import <MBProgressHUD/MBProgressHUD.h>


@interface ContactProfileController ()
@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
@property (weak, nonatomic) IBOutlet UIImageView *avatarImageView;
- (IBAction)startChatAction:(id)sender;



@end

@implementation ContactProfileController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
//    [self showFailureAlertView:<#(NSString *)#>]
    
//    MBProgressHUD *hud = [[MBProgressHUD alloc] initWithView:self.view];
//    [hud show]
//    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
//    [[XmppManager sharedInstance] addFriendSubscribe:_contactObject.jid.user];
//    [[NSNotificationCenter defaultCenter] addObserver:self
//                                             selector:@selector(handleAddFriendAction:)
//                                                 name:kFetchUserCard object:nil];
    _nameLabel.text = _contactObject.displayName;
    
    
}

- (void)handleAddFriendAction:(NSNotification *)notif{
//    [MBProgressHUD hideHUDForView:self.view animated:YES];
    
    if ([notif.object boolValue]) {
        //获取资料
    }else{
        [self showFailureAlertView:@"资料获取失败"];
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

- (IBAction)startChatAction:(id)sender {
    ChatController *dest = (ChatController *)[self controllerFromBoardByClassName:@"ChatController"];
    dest.contactObject = _contactObject;
    [self.navigationController pushViewController:dest animated:YES];
}

@end
