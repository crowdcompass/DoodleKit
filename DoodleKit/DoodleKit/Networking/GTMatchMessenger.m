//
//  GTMatchMessenger.m
//  DoodleTester
//
//  Created by Chris Hellmuth on 7/13/13.
//  Copyright (c) 2013 Robert Corlett. All rights reserved.
//

#import "GTMatchMessenger.h"

static NSInteger const InternalFlag = 1 << 0;
static NSInteger const DoodleFlag = 1 << 1;

@interface GTMatchMessenger ()

@end

static GTMatchMessenger *shared = nil;

@implementation GTMatchMessenger

+ (id)sharedMessenger {
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        shared = [[self alloc] init];
    });
    return shared;
}

- (NSInteger)flagFromPayload:(NSData *)payload {
    NSInteger flag;
    [payload getBytes:&flag length:sizeof(NSInteger)];
    return flag;
}

- (NSData *)dataFromPayload:(NSData *)payload {
    return [payload subdataWithRange:NSMakeRange(sizeof(NSInteger), [payload length] - sizeof(NSInteger))];
}

- (NSData *)payloadForData:(NSData *)data withFlag:(NSInteger)flag {
    NSMutableData *prelude = [NSMutableData dataWithBytes:&flag length:sizeof(NSInteger)];
    [prelude appendData:data];
    return prelude;
}

- (void)sendInternalDataToAllPlayers:(NSData *)data {
    assert(self.match);

    data = [self payloadForData:data withFlag:InternalFlag];

    NSLog(@"Sending data to all players");
    NSError *error;
    [self.match sendDataToAllPlayers:data withDataMode:GKMatchSendDataReliable error:&error];
    if (error) { assert(0); }
}

- (void)sendInternalDataToHost:(NSData *)data {
    assert(self.match);
    NSLog(@"Sending data to host");

    data = [self payloadForData:data withFlag:InternalFlag];

    NSError *error;
    [self.match sendData:data toPlayers:@[ self.hostPlayerID ] withDataMode:GKMatchSendDataReliable error:&error];
    if (error) { assert(0); }
}

- (void)match:(GKMatch *)match didReceiveData:(NSData *)data fromPlayer:(NSString *)playerID
{
    NSInteger flag = [self flagFromPayload:data];
    data = [self dataFromPayload:data];
    if (flag == InternalFlag) {
        [self.negotiator match:match didReceiveData:data fromPlayer:playerID];
    } else if (flag == DoodleFlag) {
        [self.serializer didReceiveDoodleData:data];
    }
}

- (void)sendDoodleDataToHost:(NSData *)data
{
    
}

- (void)sendDoodleDataToAllPlayers:(NSData *)data
{
    assert(self.match);

    data = [self payloadForData:data withFlag:DoodleFlag];

    NSLog(@"Sending data to all players");
    NSError *error;
    [self.match sendDataToAllPlayers:data withDataMode:GKMatchSendDataReliable error:&error];
    [self match:self.match didReceiveData:data fromPlayer:nil];
    if (error) { assert(0); }
}

@end
