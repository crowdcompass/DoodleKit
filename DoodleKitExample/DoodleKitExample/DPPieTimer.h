//
//  DPPieProgressView.h
//  DoodleKitExample
//
//  Created by Dave Shanley on 7/13/13.
//  Copyright (c) 2013 Alexander Belliotti. All rights reserved.
//

#import "SSPieProgressView.h"

@protocol DPPieTimerDelegate <NSObject>

- (void)pieTimerDidExpire;
- (void)pieTimerWarmupReady;

@end

@interface DPPieTimer : SSPieProgressView

@property BOOL needsWarmUp;
@property (nonatomic, weak) id<DPPieTimerDelegate> delegate;
@property float countdownDuration;

- (void)start;
- (void)stop;

// reset is just UI
- (void)reset;

@end
