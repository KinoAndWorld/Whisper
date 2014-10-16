//
//  ChatController.m
//  Whisper
//
//  Created by kino on 14-9-23.
//
//

#import "ChatController.h"
#import "UIView+Utils.h"

//
#import "ChatToolView.h"

#import "UIBubbleTableView.h"
#import "UIBubbleTableViewDataSource.h"
#import "NSBubbleData.h"

#import "XmppManager.h"
#import "XMPPFramework.h"
#import "DDXML.h"
//model
#import "Message.h"


@interface ChatController()<UIBubbleTableViewDataSource,MessageDelegate>


@property (weak, nonatomic) IBOutlet UIBubbleTableView *tableView;
@property (strong, nonatomic) NSMutableArray *chatDatas;
@property (weak, nonatomic) IBOutlet ChatToolView *chatToolView;


@end


@implementation ChatController

- (NSMutableArray *)chatDatas{
    if (_chatDatas == nil) {
        _chatDatas = [[NSMutableArray alloc] init];
    }
    return _chatDatas;
}

- (void)dealloc{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (void)viewDidLoad{
    [super viewDidLoad];
    self.title = _contactObject.displayName;
    
    [XmppManager sharedInstance].messageDeleagte = self;
    
    _tableView.bubbleDataSource = self;
    _tableView.snapInterval = 120;
    
    // The line below enables avatar support. Avatar can be specified for each bubble with .avatar property of NSBubbleData.
    // Avatars are enabled for the whole table at once. If particular NSBubbleData misses the avatar, a default placeholder will be set (missingAvatar.png)
    
    _tableView.showAvatars = YES;
    
    // Uncomment the line below to add "Now typing" bubble
    // Possible values are
    //    - NSBubbleTypingTypeSomebody - shows "now typing" bubble on the left
    //    - NSBubbleTypingTypeMe - shows "now typing" bubble on the right
    //    - NSBubbleTypingTypeNone - no "now typing" bubble
    _tableView.typingBubble = NSBubbleTypingTypeNobody;
    
    [_tableView reloadData];
    
    [self addNotifation];
    
    _chatToolView.SendBlock = ^(ChatToolView *view, NSString *inputString){
        view.inputBox.text = @"";
//        [view.inputBox resignFirstResponder];
        
        if (inputString.length > 0) {
            _tableView.typingBubble = NSBubbleTypingTypeNobody;
            NSBubbleData *sayBubble = [NSBubbleData dataWithText:inputString date:[NSDate dateWithTimeIntervalSinceNow:0] type:BubbleTypeMine];
            [self.chatDatas addObject:sayBubble];
            [_tableView reloadData];
            
            //XMPPFramework主要是通过KissXML来生成XML文件
            //生成<body>文档
            NSXMLElement *body = [NSXMLElement elementWithName:@"body"];
            [body setStringValue:inputString];
            
            //生成XML消息文档
            NSXMLElement *mes = [NSXMLElement elementWithName:@"message"];
            //消息类型
            [mes addAttributeWithName:@"type" stringValue:@"chat"];
            //发送给谁
            [mes addAttributeWithName:@"to" stringValue:_contactObject.displayName];
            //由谁发送
            [mes addAttributeWithName:@"from" stringValue:kUSERID];
            //组合
            [mes addChild:body];
            
            //发送消息
            [[[XmppManager sharedInstance] xmppStream] sendElement:mes];
        }
    };
    
    
}

- (void)addNotifation{
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(messageRecived:)
                                                 name:kHasRecieveMessage
                                               object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(messageTyping:)
                                                 name:kTypingMessage
                                               object:nil];
    // Keyboard events
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(keyboardWasShown:)
                                                 name:UIKeyboardWillShowNotification
                                               object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(keyboardWillBeHidden:)
                                                 name:UIKeyboardWillHideNotification
                                               object:nil];
    
    
}

- (void)removeNotifation{
    
}

//显示正在输入
#warning 会遇到一些并发的显示问题
- (void)showTypingStatus{
    _tableView.typingBubble = NSBubbleTypingTypeSomebody;
    [_tableView reloadData];
    
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(5.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        _tableView.typingBubble = NSBubbleTypingTypeNobody;
        [_tableView reloadData];
    });
}


#pragma mark - UIBubbleTableViewDataSource implementation

- (NSInteger)rowsForBubbleTable:(UIBubbleTableView *)tableView{
    return [_chatDatas count];
}

- (NSBubbleData *)bubbleTableView:(UIBubbleTableView *)tableView dataForRow:(NSInteger)row{
    return [_chatDatas objectAtIndex:row];
}

#pragma mark - Keyboard events

- (void)keyboardWasShown:(NSNotification*)aNotification
{
    NSDictionary* info = [aNotification userInfo];
    CGSize kbSize = [[info objectForKey:UIKeyboardFrameBeginUserInfoKey] CGRectValue].size;
    
    [self replaceTopConstraintOnView:_chatToolView withConstant:kbSize.height];
}

#pragma mark - Helper Methods

- (void)replaceTopConstraintOnView:(UIView *)view withConstant:(float)constant{
    [self.view.constraints enumerateObjectsUsingBlock:^(NSLayoutConstraint *constraint, NSUInteger idx, BOOL *stop) {
        if ((constraint.secondItem == view && (constraint.firstAttribute == NSLayoutAttributeBottom)) ) {
            constraint.constant = constant;
        }
    }];
    
    [UIView animateWithDuration:0.25 delay:0
                        options:UIViewAnimationOptionCurveEaseOut
                     animations:^{
                         [self.view layoutIfNeeded];
                     } completion:nil];
}

- (void)keyboardWillBeHidden:(NSNotification*)aNotification
{
//    NSDictionary* info = [aNotification userInfo];
//    CGSize kbSize = [[info objectForKey:UIKeyboardFrameBeginUserInfoKey] CGRectValue].size;
    [self replaceTopConstraintOnView:_chatToolView withConstant:0];
}

#pragma mark - MessageDelegate

- (void)messageRecived:(NSNotification *)notif{
//    NSLog(@"%@",message);
    Message *message = notif.object;
    
    _tableView.typingBubble = NSBubbleTypingTypeNobody;
    NSBubbleData *sayBubble = [NSBubbleData dataWithText:message.content
                                                    date:[NSDate dateWithTimeIntervalSinceNow:0]
                                                    type:BubbleTypeSomeoneElse];
    [self.chatDatas addObject:sayBubble];
    [_tableView reloadData];
    
    [_tableView scrollBubbleViewToBottomAnimated:YES];
}

- (void)messageTyping:(NSNotification *)notif{
    //    NSLog(@"%@",message);
    [self showTypingStatus];
}


#pragma mark - Actions




@end
