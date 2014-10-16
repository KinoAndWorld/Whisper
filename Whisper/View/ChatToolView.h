//
//  ChatToolView.h
//  Whisper
//
//  Created by kino on 14-9-23.
//
//

#import <UIKit/UIKit.h>

@class ChatToolView;

typedef void(^SendBlock)(ChatToolView *view, NSString *);
typedef void(^VoiceBlock)(ChatToolView *view, NSData *);
typedef void(^MoreBlock)(ChatToolView *view);
typedef void(^EmotionBlock)(ChatToolView *view);

@interface ChatToolView : UIView

@property (weak, nonatomic) IBOutlet UITextField *inputBox;

@property (weak, nonatomic) IBOutlet UIButton *moreButton;

@property (copy, nonatomic) SendBlock sendBlock;
@property (copy, nonatomic) VoiceBlock voiceBlock;
@property (copy, nonatomic) MoreBlock moreBlock;
@property (copy, nonatomic) EmotionBlock emotionBlock;


- (IBAction)moreAction:(id)sender;

- (IBAction)voiceAction:(id)sender;

- (IBAction)emotionAction:(id)sender;


@end
