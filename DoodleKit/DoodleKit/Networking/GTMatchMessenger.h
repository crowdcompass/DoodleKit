//
//  GTMatchMessenger.h
//  DoodleTester
//
//  Created by Chris Hellmuth on 7/13/13.
//  Copyright (c) 2013 Robert Corlett. All rights reserved.
//

#import <Foundation/Foundation.h>

#import <GameKit/GameKit.h>

extern NSInteger const InternalFlag;
extern NSInteger const DoodleFlag;

@class GTHostNegotiator;
@class DKSerializer;

@protocol GTMatchMessengerReceiver
- (void)match:(GKMatch *)match didReceiveData:(NSData *)data fromPlayer:(NSString *)playerID;
@end

@interface GTMatchMessenger : NSObject

+ (id)sharedMessenger;

- (void)registerDataChannelWithFlag:(NSInteger)flag object:(NSObject<GTMatchMessengerReceiver> *)object;

- (void)sendDataToAllPlayers:(NSData *)data withFlag:(NSInteger)flag;
- (void)sendDataToHost:(NSData *)data withFlag:(NSInteger)flag;

- (void)match:(GKMatch *)match didReceiveData:(NSData *)data fromPlayer:(NSString *)playerID;


@property (nonatomic, copy) NSString *hostPlayerID;
@property (nonatomic) GKMatch *match;

@end
