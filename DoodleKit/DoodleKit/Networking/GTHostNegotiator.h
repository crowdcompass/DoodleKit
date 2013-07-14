//
//  GTHostNegotiator.h
//  DoodleTester
//
//  Created by Chris Hellmuth on 7/13/13.
//  Copyright (c) 2013 Robert Corlett. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <GameKit/GameKit.h>

#import "GTMatchMessenger.h"

@class GTMatchMessenger;

@protocol GTHostNegotiatorDelegate <NSObject>

- (NSInteger)playerCount;
- (void)didStartGame;
- (void)didBecomeHost;

@end





@interface GTHostNegotiator : NSObject

- (void)start;
- (void)match:(GKMatch *)match didReceiveData:(NSData *)data fromPlayer:(NSString *)playerID;

@property (nonatomic, weak) id<GTHostNegotiatorDelegate> delegate;
@property (nonatomic, weak) GKMatch *match;

@end
