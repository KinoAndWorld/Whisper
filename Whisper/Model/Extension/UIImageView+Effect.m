//
//  UIImageView+Effect.m
//  Whisper
//
//  Created by kino on 14-10-11.
//
//

#import "UIImageView+Effect.h"
#import "UIImage+Resize.h"

@implementation UIImageView (Effect)

- (void)applyAvatar{
//    self.clipsToBounds = NO;
    UIImage *image = self.image;
    if (image) {
        UIImage *newImage = [image getImageFitInSize:CGSizeMake(40, 40)];
        self.image = newImage;
    }
    
    self.layer.masksToBounds = YES;
    self.layer.cornerRadius = 20;
    
    self.layer.borderWidth = 1;
    self.layer.borderColor = [UIColor blackColor].CGColor;
    
    self.frame = CGRectMake(0, 0, 40, 40);
    
//    self.contentMode = UIViewContentModeRedraw;
}

@end
