//
//  DKDoodleSessionManager.m
//  DoodleKit
//
//  Created by Ryan Crosby on 7/14/13.
//  Copyright (c) 2013 DaveVan. All rights reserved.
//

#import "DKDoodleSessionManager.h"

#import "GTMatchMessenger.h"

enum DKDoodleMessageType {
    DKDoodleMessageTypeDeclareHost = 0,
    DKDoodleMessageTypeSubmitToHost,
    DKDoodleMessageTypeStartGame,
    };
typedef NSUInteger DKDoodleMessageType;

#define kDoodleMessageIDKey     @"id"

static NSInteger const playerCount = 4;

static DKDoodleSessionManager *sharedInstance;

@implementation DKDoodleArtist : NSObject

@end

@interface DKDoodleSessionManager ()
@property (nonatomic, strong) GKSession *session;
@property (nonatomic, copy) NSString *hostID;
@property (nonatomic, strong) NSMutableSet *peerIDs;
@property (nonatomic) BOOL gameHasStarted;
@property (nonatomic, strong) NSMutableSet *commitedClients;
@end

@implementation DKDoodleSessionManager

- (void)receiveData:(NSData *)data fromPeer:(NSString *)peer inSession:(GKSession *)session context:(void *)context {
    if (!self.gameHasStarted) {
        NSDictionary *dictionary = [NSKeyedUnarchiver unarchiveObjectWithData:data];
        [self receiveDictionary:dictionary fromPeer:peer];
    }
    else {
        GTMatchMessenger *oldMessenger = [GTMatchMessenger sharedMessenger];
        [oldMessenger match:nil didReceiveData:data fromPlayer:peer];
    }
}

- (void)receiveDictionary:(NSDictionary *)dictionary fromPeer:(NSString *)peer {
    DKDoodleMessageType messageType = [dictionary[kDoodleMessageIDKey] intValue];
    switch (messageType) {
        case DKDoodleMessageTypeDeclareHost: {
            [self handleDeclareHostFromPeer:peer];
        } break;
        case DKDoodleMessageTypeSubmitToHost: {
            [self handleSubmitToHostFromPeer:peer];
        } break;
        case DKDoodleMessageTypeStartGame: {
            [self handleStartGame];
        } break;
    }
    NSLog(@"%d", messageType);
    NSLog(@"%@", dictionary);
}

- (void)sendDictionary:(NSDictionary *)dictionary toPeers:(NSArray *)peers {
    NSData *data = [NSKeyedArchiver archivedDataWithRootObject:dictionary];
    NSError *error;
    [self.session sendData:data toPeers:peers withDataMode:GKSendDataReliable error:&error];
    assert(!error);
}

- (void)handleDeclareHostFromPeer:(NSString *)peer {
    self.hostID = peer;

    NSArray *peers = [self.session peersWithConnectionState:GKPeerStateConnected];
    if (peers.count == playerCount - 1) {
        [self sendDictionary:@{ kDoodleMessageIDKey: @(DKDoodleMessageTypeSubmitToHost) } toPeers:@[ self.hostID ]];
    }
}

- (void)handleSubmitToHostFromPeer:(NSString *)peer {
    [self.commitedClients addObject:peer];
    if (self.commitedClients.count == playerCount - 1) {
        [self sendDictionary:@{ kDoodleMessageIDKey: @(DKDoodleMessageTypeStartGame) } toPeers:[self.commitedClients allObjects]];
        [self handleStartGame];
    }
}

- (void)handleStartGame {
    NSLog(@"LETS START THE GAME!");
    self.gameHasStarted = YES;
    [self.delegate didStartGame];
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
        self.commitedClients = [NSMutableSet set];
    }
    return self;
}

/**
   Authenticate the local user. If the user needs to sign in to GameCenter,
  + then the GK UI is presented modally using the Application handle
  + */
- (void)startAuthenticatingLocalPlayer {
    __weak GKLocalPlayer *localPlayer = [GKLocalPlayer localPlayer];
    [localPlayer setAuthenticateHandler:^(UIViewController *viewController, NSError *error) {
        // We need to auth
        if (viewController) {
            UIViewController *rootViewController = [[[[UIApplication sharedApplication] delegate] window] rootViewController];
            [rootViewController presentViewController:viewController animated:YES completion:nil];
        }
        
        // We are authenticated
        if (localPlayer.authenticated) {
            DKDoodleArtist *doodleArtist = [[DKDoodleArtist alloc] init];
            doodleArtist.displayName = localPlayer.alias;
            doodleArtist.playerID = localPlayer.playerID;
            doodleArtist.isLocal = YES;
            self.doodleArtist = doodleArtist;
            
            if (_delegate && [_delegate respondsToSelector:@selector(didAuthenticateLocalPlayer:)]) {
                [_delegate didAuthenticateLocalPlayer:doodleArtist];
            }

            [self start];
            
        }
    }];
}

- (void)start {
    GKSession *session = [[GKSession alloc] initWithSessionID:@"com.crowdcompass.DoodleParty"
                                                  displayName:_doodleArtist.displayName
                                                  sessionMode:GKSessionModePeer];

    session.delegate = self;
    session.available = YES;
    [session setDataReceiveHandler:self withContext:0];
    _doodleArtist.peerID = session.peerID;

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
        
        if (![peerID isEqualToString:_doodleArtist.peerID]) {
            DKDoodleArtist *doodleArtist = [[DKDoodleArtist alloc] init];
            doodleArtist.peerID = peerID;
            doodleArtist.displayName = [session displayNameForPeer:peerID];
            doodleArtist.isLocal = NO;
            
            [_doodleArtistPeers setObject:doodleArtist forKey:peerID];
            
            [_delegate artistDidConnect:doodleArtist];
        }

        [self poll];

        if (self.hostID) {
            [self handleDeclareHostFromPeer:self.hostID];
        }
    } else if (state == GKPeerStateDisconnected) {
        if (![peerID isEqualToString:_doodleArtist.peerID]) {
            DKDoodleArtist *doodleArtist = [_doodleArtistPeers objectForKey:peerID];
            if (doodleArtist) {
                [_doodleArtistPeers removeObjectForKey:peerID];
                [_delegate artistDidDisconnect:doodleArtist];
            }
        }
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
    
    DKDoodleArtist *doodleArtist = [_doodleArtistPeers objectForKey:peerID];
    if (doodleArtist) {
        [_delegate artistDidDisconnect:doodleArtist];
    }
}

- (void)session:(GKSession *)session didFailWithError:(NSError *)error {
}


////// temp
- (void)sendDataToAllPlayers:(NSData *)data {
    NSError *error;
    NSArray *peers = [self.session peersWithConnectionState:GKPeerStateConnected];
    [self.session sendData:data toPeers:peers withDataMode:GKSendDataReliable error:&error];
    assert (!error);
}


@end
