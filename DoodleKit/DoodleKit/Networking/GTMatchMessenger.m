//
//  GTMatchMessenger.m
//  DoodleTester
//
//  Created by Chris Hellmuth on 7/13/13.
//  Copyright (c) 2013 Robert Corlett. All rights reserved.
//

#import "GTMatchMessenger.h"

#import "GTHostNegotiator.h"


@interface GTMatchMessenger ()
@property (nonatomic) NSMutableDictionary *channelLookup;

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

- (id)init {
    self = [super init];
    if (self) {
        self.channelLookup = [@{} mutableCopy];
    }
    return self;
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

- (void)registerDataChannelWithFlag:(NSInteger)flag object:(NSObject *)object
{
    self.channelLookup[@(flag)] = object;
}

- (void)sendDataToAllPlayers:(NSData *)data withFlag:(NSInteger)flag {
//    assert(self.match);

    data = [self payloadForData:data withFlag:flag];
    if (flag == DoodleFlag) {
        [self match:self.match didReceiveData:data fromPlayer:nil];
    }

    NSLog(@"Sending data to all players");
    NSError *error;
    [self.match sendDataToAllPlayers:data withDataMode:GKMatchSendDataReliable error:&error];
    if (error) { assert(0); }
}

- (void)sendDataToHost:(NSData *)data withFlag:(NSInteger)flag {
//    assert(self.match);

    data = [self payloadForData:data withFlag:flag];

    NSLog(@"Sending data to all players");
    NSError *error;
    [self.match sendData:data toPlayers:@[ self.hostPlayerID ] withDataMode:GKMatchSendDataReliable error:&error];
    if (error) { assert(0); }
}

- (void)match:(GKMatch *)match didReceiveData:(NSData *)data fromPlayer:(NSString *)playerID
{
    NSInteger flag = [self flagFromPayload:data];
    data = [self dataFromPayload:data];

    NSObject<GTMatchMessengerReceiver> *receiver = self.channelLookup[@(flag)];
    [receiver match:match didReceiveData:data fromPlayer:playerID];
}

@end
