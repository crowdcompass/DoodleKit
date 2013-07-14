//
//  DKPlayerBoardView.m
//  DoodleKitExample
//
//  Created by Kerney, Benjamin on 7/14/13.
//  Copyright (c) 2013 Alexander Belliotti. All rights reserved.
//

#import "DKPlayerBoardView.h"

@implementation DKPlayerBoardView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self prepInitialState];
    }
    return self;
}

- (void)prepInitialState
{
    self.backgroundColor = [UIColor colorWithRed:0.0f green:0.0f blue:0.0f alpha:0.1f];
}

- (void)tileTapRecognized:(UITapGestureRecognizer *)recognizer {
    toggleImageTile(recognizer.view);
}

void toggleImageTile(UIView *tile) {
    if (tile.alpha >= .9f) {
        //fade out
        [UIView animateWithDuration:.12
                         animations:^{
                             tile.alpha = 0.02f;
                         }];
    } else {
        //fade in
        [UIView animateWithDuration:.12
                         animations:^{
                             tile.alpha = .98f;
                         }];
    }
}

- (void)setReady
{
    UITapGestureRecognizer *tapRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tileTapRecognized:)];
    [self addGestureRecognizer:tapRecognizer];

    UIImageView *imageView = [[UIImageView alloc] initWithImage:self.image];
    imageView.frame = self.bounds;
    [self addSubview:imageView];
}


//- (id)initWithFrame:(CGRect)frame
//{
//    self = [super initWithFrame:frame];
//    if (self) {
//        // Initialization code
//    }
//    return self;
//}
//
/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
}
*/

@end
