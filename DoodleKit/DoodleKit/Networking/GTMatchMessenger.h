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

@class GTHostNegotiator;
@class DKSerializer;

@interface GTMatchMessenger : NSObject

- (id)initWithMatch:(GKMatch *)match;

- (void)sendInternalDataToAllPlayers:(NSData *)data;
- (void)sendInternalDataToHost:(NSData *)data;

- (void)sendDoodleDataToAllPlayers:(NSData *)data;
- (void)sendDoodleDataToHost:(NSData *)data;

- (void)match:(GKMatch *)match didReceiveData:(NSData *)data fromPlayer:(NSString *)playerID;


@property (nonatomic, copy) NSString *hostPlayerID;
@property (nonatomic, weak) GTHostNegotiator *negotiator;
@property (nonatomic, weak) DKSerializer *serializer;

@end
