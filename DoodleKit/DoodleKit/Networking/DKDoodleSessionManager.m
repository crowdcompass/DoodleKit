//
//  DKDoodleSessionManager.m
//  DoodleKit
//
//  Created by Ryan Crosby on 7/14/13.
//  Copyright (c) 2013 DaveVan. All rights reserved.
//

#import "DKDoodleSessionManager.h"

enum DKDoodleMessageType {
    DKDoodleMessageTypeDeclareHost = 0,
    DKDoodleMessageTypeSubmitToHost,
    DKDoodleMessageTypeStartGame,
    };
typedef NSUInteger DKDoodleMessageType;

#define kDoodleMessageIDKey     @"id"

static NSInteger const playerCount = 2;

static DKDoodleSessionManager *sharedInstance;

@interface DKDoodleSessionManager ()
@property (nonatomic, strong) GKSession *session;

@property (nonatomic, strong) NSMutableSet *peerIDs;
@end

@implementation DKDoodleSessionManager

- (void)receiveData:(NSData *)data fromPeer:(NSString *)peer inSession:(GKSession *)session context:(void *)context {
    NSDictionary *dictionary = [NSKeyedUnarchiver unarchiveObjectWithData:data];
    [self receiveDictionary:dictionary fromPeer:peer];
}

- (void)receiveDictionary:(NSDictionary *)dictionary fromPeer:(NSString *)peer {
    DKDoodleMessageType messageType = dictionary[kDoodleMessageIDKey];
    NSLog(@"%d", messageType);
    NSLog(@"%@", dictionary);
}

- (void)sendDictionary:(NSDictionary *)dictionary toPeers:(NSArray *)peers {
    NSData *data = [NSKeyedArchiver archivedDataWithRootObject:dictionary];
    NSError *error;
    [self.session sendData:data toPeers:peers withDataMode:GKSendDataReliable error:&error];
    assert(!error);
}

+ (instancetype)sharedManager {
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedInstance = [[self alloc] init];
    });
    return sharedInstance;
}

- (id)init {
    self = [super init];
    if (self) {
        self.peerIDs = [NSMutableSet set];
    }
    return self;
}

- (void)start {
    GKSession *session = [[GKSession alloc] initWithSessionID:@"com.crowdcompass.DoodleParty"
                                                  displayName:[[[UIDevice currentDevice] identifierForVendor] UUIDString]
                                                  sessionMode:GKSessionModePeer];

    session.delegate = self;
    session.available = YES;
    [session setDataReceiveHandler:self withContext:0];

    self.session = session;
}

- (void)poll {
    NSArray *peers = [self.session peersWithConnectionState:GKPeerStateConnected];
    NSLog(@"MY PEER COUNT IS: %d", peers.count);
    if (peers.count == playerCount - 1) {
        NSLog(@"WE HAVE A GAME!");
    }
}

- (void)session:(GKSession *)session peer:(NSString *)peerID didChangeState:(GKPeerConnectionState)state {
    if (state == GKPeerStateAvailable) {
        [self.session connectToPeer:peerID withTimeout:15];
    } else if (state == GKPeerStateConnected) {
        [self poll];
    }
}

- (void)createMatch {
    NSArray *peers = [self.session peersWithConnectionState:GKPeerStateConnected];
    if (peers.count == playerCount - 1) {
        [self sendDictionary:@{ kDoodleMessageIDKey: @(DKDoodleMessageTypeDeclareHost) } toPeers:peers];
    }
}

- (void)session:(GKSession *)session didReceiveConnectionRequestFromPeer:(NSString *)peerID {
    NSError *error;
    [self.session acceptConnectionFromPeer:peerID error:&error];
    assert(!error);

}

- (void)session:(GKSession *)session connectionWithPeerFailed:(NSString *)peerID withError:(NSError *)error {

}

- (void)session:(GKSession *)session didFailWithError:(NSError *)error {
}


@end
