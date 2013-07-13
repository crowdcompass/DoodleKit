//
//  DPPieProgressView.m
//  DoodleKitExample
//
//  Created by Dave Shanley on 7/13/13.
//  Copyright (c) 2013 Alexander Belliotti. All rights reserved.
//

#import "DPPieTimer.h"
#import "NSTimer+BlocksKit.h"

enum DPPieProgressViewState {
    PieReady = 0,
    PieSet = 1,
    PieGo = 2
    };

#define kCountdownTimeInSeconds 30.0

#define kPieRedColor [UIColor colorWithRed:240.0/255.0 green:70.0/255.0 blue:50.0/255.0 alpha:1.0]
#define kPieYellowColor [UIColor colorWithRed:250.0/255.0 green:208.0/255.0 blue:60.0/255.0 alpha:1.0]
#define kPieGreenColor [UIColor colorWithRed:66.0/255.0 green:182.0/255.0 blue:73.0/255.0 alpha:1.0]
#define kPieFillColor [UIColor colorWithRed:230.0/255.0 green:230.0/255.0 blue:230.0/255.0 alpha:1.0]

#define kAnimationDuration 0.8
#define kTimerShrinkSize 0.7
#define kTimerGrowSize 1.1

@interface DPPieTimer ()

@property (nonatomic) enum DPPieProgressViewState warmingUpState;
@property (nonatomic, strong) __block NSTimer *countdownTimer;

- (void)warmUp;
- (void)didWarmUp;
- (void)startCountdown;
- (void)reset;

@end

@implementation DPPieTimer

- (void)_initialize {
    //from super
    self.backgroundColor = [UIColor clearColor];
	
	self.progress = 0.0f;
	self.pieBorderWidth = 2.0f;
	[self reset];
}

- (UIColor *)defaultPieColor {
    return kPieRedColor;
}

- (void)reset {
    self.pieBorderColor = kPieRedColor;
	self.pieFillColor = self.pieBorderColor;
    self.warmingUpState = PieReady;
    self.pieBackgroundColor = kPieRedColor;
    [self.countdownTimer invalidate];
    self.countdownTimer = nil;
    [UIView animateWithDuration:0.1 delay:0.0 options:UIViewAnimationOptionCurveEaseOut animations:^{
        self.transform = CGAffineTransformMakeScale(kTimerShrinkSize, kTimerShrinkSize);
    } completion:^(BOOL finished) {}];
}

//////////////////////////////////////////////////////////////////////
#pragma mark -
#pragma mark Countdown

- (void)start {
    if (_warmingUpState == PieReady) {
        [self warmUp];
        return;
    } else {
        [self startCountdown];
    }
    
}

- (void)stop {
    [self reset];
}

- (void)warmUp {
    [UIView animateWithDuration:kAnimationDuration delay:0.0 options:UIViewAnimationOptionCurveEaseIn animations:^{
        self.transform = CGAffineTransformMakeScale(kTimerGrowSize, kTimerGrowSize);
    } completion:^(BOOL finished) {
        [UIView animateWithDuration:0.1 delay:0.0 options:UIViewAnimationOptionCurveEaseOut animations:^{
            self.transform = CGAffineTransformMakeScale(kTimerShrinkSize, kTimerShrinkSize);
        } completion:^(BOOL finished) {
            self.warmingUpState = PieSet;
            self.pieFillColor = kPieYellowColor;
            self.pieBorderColor = kPieYellowColor;
            self.pieBackgroundColor = kPieYellowColor;
            [UIView animateWithDuration:kAnimationDuration delay:0.0 options:UIViewAnimationOptionCurveEaseIn animations:^{
                self.transform = CGAffineTransformMakeScale(kTimerGrowSize, kTimerGrowSize);
            } completion:^(BOOL finished) {
                [UIView animateWithDuration:0.1 delay:0.0 options:UIViewAnimationOptionCurveEaseOut animations:^{
                    self.transform = CGAffineTransformMakeScale(kTimerShrinkSize, kTimerShrinkSize);
                } completion:^(BOOL finished) {
                    self.warmingUpState = PieGo;
                    self.pieFillColor = kPieFillColor;
                    self.pieBorderColor = kPieGreenColor;
                    self.pieBackgroundColor = kPieGreenColor;
                    [UIView animateWithDuration:kAnimationDuration delay:0.0 options:UIViewAnimationOptionCurveEaseIn animations:^{
                        self.transform = CGAffineTransformMakeScale(kTimerGrowSize, kTimerGrowSize);
                    } completion:^(BOOL finished) {
                        [UIView animateWithDuration:0.1 delay:0.0 options:UIViewAnimationOptionCurveEaseOut animations:^{
                            self.transform = CGAffineTransformMakeScale(1.0, 1.0);
                        } completion:^(BOOL finished) {
                            [self didWarmUp];
                        }];
                    }];
                }];
            }];
        }];
    }];
}

- (void)didWarmUp {
    NSLog(@"current transform x %f y %f", self.transform.a, self.transform.d);
    [self startCountdown];
}

- (void)startCountdown {
     _countdownTimer = [NSTimer scheduledTimerWithTimeInterval:1.0/60.0 block:^(NSTimeInterval time) {
        self.progress = self.progress + (1.0/(kCountdownTimeInSeconds*60.0));
        if (self.progress == 1.0f) {
            [_countdownTimer invalidate];
            _countdownTimer = nil;
            if (_delegate && [_delegate respondsToSelector:@selector(pieTimerDidExpire)]) {
                [_delegate pieTimerDidExpire];
                [self reset];
            }
        }
        
    } repeats:YES];
}

@end
