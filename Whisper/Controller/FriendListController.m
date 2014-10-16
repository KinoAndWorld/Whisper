//
//  FriendListController.m
//  Whisper
//
//  Created by kino on 14-9-24.
//
//

#import "FriendListController.h"
#import "LoginController.h"
#import "ChatController.h"

#import "ContactProfileController.h"
//
#import "XmppManager.h"

#import "XMPPFramework.h"

#import <CoreData/CoreData.h>

#import "ContactManager.h"

#import "UIImageView+Effect.h"


@interface FriendListController()

@property (weak, nonatomic) IBOutlet UITableView *tableView;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *addContactViewConstraint;

@property (weak, nonatomic) IBOutlet UIView *addContactView;
@property (strong, nonatomic) UIView *maskView;
@property (weak, nonatomic) IBOutlet UITextField *addContactBox;

KOMutableArray allContacts;

@end

@implementation FriendListController


- (NSMutableArray *)allContacts{
    if (_allContacts == nil) {
        _allContacts = [[NSMutableArray alloc] init];
    }
    return _allContacts;
}

- (UIView *)maskView{
    if (!_maskView) {
        _maskView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.view.width, self.view.height)];
        _maskView.backgroundColor = [UIColor blackColor];
        [self.view addSubview:_maskView];
        [self.view bringSubviewToFront:_addContactView];
    }
    _maskView.alpha = 0.0;
    _maskView.center = self.view.center;
    return _maskView;
}

#pragma mark - 


- (void)viewDidLoad{
    [super viewDidLoad];
    
    [self.tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:@"Cell"];
    
//    [XmppManager sharedInstance].chatDeleagte = self;
    
    
    _allContacts = [ContactManager sharedInstance].allContacts;
    [self recContactsUpdated];
    
    [[ContactManager sharedInstance] setContactHasBeenRefresh:^{
        _allContacts = [ContactManager sharedInstance].allContacts;
        [_allContacts enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
            XMPPUserCoreDataStorageObject *user = (XMPPUserCoreDataStorageObject *)obj;
            if ([user.subscription isEqualToString:@"none"]) {
                [_allContacts removeObject:obj];
            }
        }];
        [self recContactsUpdated];
        [_tableView reloadData];
    }];
//    UIBarButtonItem *barButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"重新登录" style:UIBarButtonItemStyleDone target:self action:@selector(logoutAndShowLogin)];
//    
//    [self.tabBarController.navigationItem setRightBarButtonItem:barButtonItem];
}

- (void)recContactsUpdated{
    if (!_allContacts || _allContacts.count == 0) {
        [self showBlankView:@"暂时没有联系人~"];
        _tableView.hidden = YES;
    }else{
        
        [self hideBlankView];
        _tableView.hidden = NO;
    }
}


- (void)logoutAndShowLogin{
    [[XmppManager sharedInstance] disconnect];
    LoginController *dest = [[UIStoryboard storyboardWithName:@"Main" bundle:nil]
                             instantiateViewControllerWithIdentifier:@"LoginController"];
    [self.navigationController presentViewController:dest animated:YES completion:nil];
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    
//    if ([[XmppManager sharedInstance].xmppStream isDisconnected]) {
//            dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, 0.0 * NSEC_PER_SEC);
//            dispatch_after(popTime, dispatch_get_main_queue(), ^(void){
//                LoginController *dest = [[UIStoryboard storyboardWithName:@"Main" bundle:nil]
//                                         instantiateViewControllerWithIdentifier:@"LoginController"];
//                [self.navigationController presentViewController:dest animated:YES completion:nil];
//            });
//    }
    //连接服务器
//    [[XmppManager sharedInstance] xmppStream].myJID.bare

    //    self.tabBarController.title = @"连接中...";
//    self.tableView.contentInset = UIEdgeInsetsMake(0, 0, 0, 0);
}

#pragma maek - UITableViewDataSource, UITableViewDelegate

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 60;
}

//- (NSString *)tableView:(UITableView *)sender titleForHeaderInSection:(NSInteger)sectionIndex{
//    NSArray *sections = [[self fetchedResultsController] sections];
//    
//    if (sectionIndex < [sections count]){
//        id <NSFetchedResultsSectionInfo> sectionInfo = [sections objectAtIndex:sectionIndex];
//        
//        int section = [sectionInfo.name intValue];
//        switch (section)
//        {
//            case 0  : return @"Available";
//            case 1  : return @"Away";
//            default : return @"Offline";
//        }
//    }
//    
//    return @"";
//}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)sectionIndex{
    
    return self.allContacts.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView
         cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *CellIdentifier = @"Cell";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier
                                                            forIndexPath:indexPath];
    
    XMPPUserCoreDataStorageObject *user = [_allContacts objectAtIndex:indexPath.row];
    
    cell.textLabel.text = user.displayName;
    [self configurePhotoForCell:cell user:user];
    
    return cell;
}

- (void)configurePhotoForCell:(UITableViewCell *)cell user:(XMPPUserCoreDataStorageObject *)user{
    // Our xmppRosterStorage will cache photos as they arrive from the xmppvCardAvatarModule.
    // We only need to ask the avatar module for a photo, if the roster doesn't have it.
    
    
    if (user.photo != nil){
        cell.imageView.image = user.photo;
    }
    else
    {
        cell.imageView.image = [UIImage imageNamed:@"avatar"];
//        NSData *photoData = [[[self appDelegate] xmppvCardAvatarModule] photoDataForJID:user.jid];
//        
//        if (photoData != nil)
//            cell.imageView.image = [UIImage imageWithData:photoData];
//        else
//            cell.imageView.image = [UIImage imageNamed:@"defaultPerson"];
    }
    
    [cell.imageView applyAvatar];
}


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    XMPPUserCoreDataStorageObject *user = [_allContacts objectAtIndex:indexPath.row];
    
    ContactProfileController *dest = (ContactProfileController *)[self controllerFromBoardByClassName:@"ContactProfileController"];
    dest.contactObject = user;
    
//    ChatController *dest = [[UIStoryboard storyboardWithName:@"Main" bundle:nil] instantiateViewControllerWithIdentifier:@"ChatController"];
//    dest.contactObject = user;
    dest.hidesBottomBarWhenPushed = YES;
    
    [self.navigationController pushViewController:dest animated:YES];
    
    self.hidesBottomBarWhenPushed = NO;
}

#pragma mark - 

- (IBAction)addContactAction:(id)sender {
    
    [UIView animateWithDuration:0.6 delay:0
         usingSpringWithDamping:0.6 initialSpringVelocity:10
                        options:UIViewAnimationOptionCurveEaseInOut
                     animations:^{
                         self.maskView.alpha = 0.6;
                         _addContactViewConstraint.constant = -350.f;
                         [self.view layoutIfNeeded];
    } completion:^(BOOL finished) {  }];
}

- (IBAction)confirmAddContact:(id)sender {
    NSString *friend = _addContactBox.text;
    _addContactBox.text = @"";
    [self.view endEditing:YES];
    if (friend.length == 0) {
        [self showFailureAlertView:@"先填写用户名好吗"];
        return;
    }
    
    [[XmppManager sharedInstance] addFriendSubscribe:friend];
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(handleAddFriendAction:)
                                                 name:kFetchUserCard object:nil];
    
    [UIView animateWithDuration:0.6 delay:0
         usingSpringWithDamping:0.6 initialSpringVelocity:10
                        options:UIViewAnimationOptionCurveEaseInOut
                     animations:^{
                         self.maskView.alpha = 0.0;
                         _addContactViewConstraint.constant = 50.f;
                         [self.view layoutIfNeeded];
                     } completion:^(BOOL finished) {  }];
}

- (void)handleAddFriendAction:(NSNotification *)notif{
    if ([notif.object boolValue]) {
        //获取资料
        
    }else{
        [self showFailureAlertView:@"该用户不存在"];
    }
}

- (void)dealloc{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

@end
