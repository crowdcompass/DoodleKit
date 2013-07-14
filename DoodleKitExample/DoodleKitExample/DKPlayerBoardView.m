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
    [self addTarget:self action:@selector(fadeOut) forControlEvents:UIControlEventTouchDown];
    [self addTarget:self action:@selector(fadeIn) forControlEvents:UIControlEventTouchUpInside];
    [self addTarget:self action:@selector(fadeIn) forControlEvents:UIControlEventTouchDragExit];
}

- (void)fadeOut {
    [UIView animateWithDuration:.25
                         animations:^{
                             self.alpha = 0.f;
                         }];
}

- (void)fadeIn {
    [UIView animateWithDuration:.25
                         animations:^{
                             self.alpha = 1.f;
                         }];
}

- (void)setReady
{
    UIImageView *imageView = [[UIImageView alloc] initWithImage:self.image];
    imageView.frame = self.bounds;
    [self addSubview:imageView];
}

- (void)revealPermanently
{
    [self removeTarget:self action:@selector(fadeOut) forControlEvents:UIControlEventTouchDown];
    [self removeTarget:self action:@selector(fadeIn) forControlEvents:UIControlEventTouchUpInside];
    [self removeTarget:self action:@selector(fadeIn) forControlEvents:UIControlEventTouchDragExit];
    [UIView animateWithDuration:.25
                     animations:^{
                         self.alpha = 0.f;
                     }];
}

@end
