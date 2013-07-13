//
//  GTMatchMessenger.m
//  DoodleTester
//
//  Created by Chris Hellmuth on 7/13/13.
//  Copyright (c) 2013 Robert Corlett. All rights reserved.
//

#import "GTMatchMessenger.h"

@interface GTMatchMessenger ()
@property (nonatomic) GKMatch *match;
@end

@implementation GTMatchMessenger

- (id)initWithMatch:(GKMatch *)match {
    self = [super init];
    if (self) {
        self.match = match;
    }
    return self;
}

- (void)sendDataToAllPlayers:(NSData *)data {
    assert(self.match);
    NSLog(@"Sending data to all players");
    NSError *error;
    [self.match sendDataToAllPlayers:data withDataMode:GKMatchSendDataReliable error:&error];
    if (error) { assert(0); }
}

- (void)sendDataToHost:(NSData *)data {
    assert(self.match);
    NSLog(@"Sending data to host");
    NSError *error;
    [self.match sendData:data toPlayers:@[ self.hostPlayerID ] withDataMode:GKMatchSendDataReliable error:&error];
    if (error) { assert(0); }
}


@end
