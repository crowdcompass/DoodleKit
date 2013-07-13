//
//  DPStartDoodleButton.m
//  DoodleKitExample
//
//  Created by Alexander Belliotti on 7/13/13.
//  Copyright (c) 2013 Alexander Belliotti. All rights reserved.
//

#import "DPStartDoodleButton.h"

#import "SSDrawingUtilities.h"

@implementation DPStartDoodleButton

- (id)init {
    self = [DPStartDoodleButton buttonWithType:UIButtonTypeCustom];
    if (self) {
        [self useWaitingImage];
        self.frame = CGRectSetSize(self.frame, self.imageView.image.size);
    }
    
    return self;
}

- (void)useWaitingImage {
    [self setImage:[UIImage imageNamed:@"btn_waiting"] forState:UIControlStateNormal];
    self.userInteractionEnabled = NO;
}

- (void)useReadyImage {
    [self setImage:[UIImage imageNamed:@"btn_start"] forState:UIControlStateNormal];
    [self setImage:[UIImage imageNamed:@"btn_start_press"] forState:UIControlStateHighlighted | UIControlStateSelected];
    self.userInteractionEnabled = YES;
    
}
/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
}
*/

@end
