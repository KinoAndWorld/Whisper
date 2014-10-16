//
//  ChatToolView.m
//  Whisper
//
//  Created by kino on 14-9-23.
//
//

#import "ChatToolView.h"

@interface ChatToolView()<UITextFieldDelegate>



@end

@implementation ChatToolView

- (void)awakeFromNib{
    
}

//- (void)layoutSubviews{
//    
//}

- (IBAction)moreAction:(id)sender{
    if (_moreBlock) {
        _moreBlock(self);
    }
}

- (IBAction)voiceAction:(id)sender{
    if (_voiceBlock) {
        _voiceBlock(self,[NSData data]);
    }
}

- (IBAction)emotionAction:(id)sender{
    if (_emotionBlock) {
        _emotionBlock(self);
    }
}

#pragma mark - UITextFieldDelegate

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string{
    if (textField.text.length > 256) {
        return NO;
    }
    return YES;
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField{
    if ([textField.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]].length != 0) {
        if (_sendBlock) {
            _sendBlock(self,textField.text);
        }
    }
    return YES;
}

- (IBAction)textFieldEditOnExit:(id)sender{
    
}

@end
