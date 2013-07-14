//
//  GTMatchMessenger.h
//  DoodleTester
//
//  Created by Chris Hellmuth on 7/13/13.
//  Copyright (c) 2013 Robert Corlett. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "GTHostNegotiator.h"
#import "DKSerializer.h"
#import <GameKit/GameKit.h>

NSInteger const InternalFlag = 1 << 0;
NSInteger const DoodleFlag = 1 << 1;


@class GTHostNegotiator;
@class DKSerializer;

@interface GTMatchMessenger : NSObject

+ (id)sharedMessenger;

- (void)registerDataChannelWithFlag:(NSInteger)flag object:(NSObject *)object;

- (void)sendDataToAllPlayers:(NSData *)data withFlag:(NSInteger)flag;
- (void)sendDataToHost:(NSData *)data withFlag:(NSInteger)flag;

- (void)match:(GKMatch *)match didReceiveData:(NSData *)data fromPlayer:(NSString *)playerID;


@property (nonatomic, copy) NSString *hostPlayerID;
@property (nonatomic, weak) GTHostNegotiator *negotiator;
@property (nonatomic, weak) DKSerializer *serializer;
@property (nonatomic) GKMatch *match;

@end
