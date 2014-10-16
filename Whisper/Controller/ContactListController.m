//
//  ContactListController.m
//  Whisper
//
//  Created by kino on 14-9-23.
//
//

#import "ContactListController.h"
#import "ChatController.h"

#import "ChatDelegate.h"
#import "XmppManager.h"
#import "ContactManager.h"

//#import "NotifitionConfig.h"

#define kRecContactsCount @"recContacts.count"

@interface ContactListController()<UITableViewDataSource, UITableViewDelegate>

KOMutableArray recContacts;

@property (weak, nonatomic) IBOutlet UITableView *tableView;

@end

@implementation ContactListController

- (NSMutableArray *)recContacts{
    if (_recContacts == nil) {
        _recContacts = [[NSMutableArray alloc] init];
    }
    return _recContacts;
}

- (void)dealloc{
    [[NSNotificationCenter defaultCenter] removeObserver:self forKeyPath:kHasRecieveMessage];
    
    
    [self removeObserver:self forKeyPath:kRecContactsCount];
}

- (void)viewDidLoad{
    [super viewDidLoad];
    
    
    
//    [XmppManager sharedInstance].chatDeleagte = self;
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(recieveMessage:)
                                                 name:kHasRecieveMessage
                                               object:nil];
    
    //view
    [_tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:@"Cell"];
    
    
    //从数据库 获取最近联系人
    _recContacts = [ContactManager sharedInstance].recentContacts;
//    [ContactManager sharedInstance]
    [self recContactsUpdated];
    
}

- (void)recContactsUpdated{
    if (!_recContacts || _recContacts.count == 0) {
        [self showBlankView:@"暂时没有聊天的人~"];
        _tableView.hidden = YES;
    }else{
        [self hideBlankView];
        _tableView.hidden = NO;
    }
}


//收到消息
- (void)recieveMessage:(NSNotification *)notif{
    
}


- (IBAction)showChatAction:(id)sender {
    ChatController *dest = [[UIStoryboard storyboardWithName:@"Main" bundle:nil] instantiateViewControllerWithIdentifier:@"ChatController"];
    [self.navigationController pushViewController:dest animated:YES];
    
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    
    
}

#pragma mark - ChatDelegate

- (void)fetchBuddyOnline:(NSString *)buddyName{
    
}

- (void)buddyOutOffline:(NSString *)buddyName{
    
}

- (void)didDisconnect{
    
}


#pragma maek - UITableViewDataSource, UITableViewDelegate

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.recContacts.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 60;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    NSString *cellIdentifier = @"Cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier
                                                            forIndexPath:indexPath];
    
    
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}


@end
