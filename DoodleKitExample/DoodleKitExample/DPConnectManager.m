//
//  DPConnectManager.m
//  DoodleKitExample
//
//  Created by Dave Shanley on 7/13/13.
//  Copyright (c) 2013 Alexander Belliotti. All rights reserved.
//

#import "DPConnectManager.h"
#import <GameKit/GameKit.h>


@interface DPConnectManager ()

@property (nonatomic, strong) NSMutableArray *playersToInvite; // an array of player IDs
@property (nonatomic, strong) GKMatch *match;
@property (nonatomic, strong) GKMatchRequest *matchRequest;
@property (nonatomic, strong) GKMatchmaker *matchMaker;
@property BOOL matchStarted;

- (void)disconnectFromMatch;
- (void)finishMatchMaking;

@end

@implementation DPConnectManager

static const int MIN_PLAYERS = 2;
static const int MAX_PLAYERS = 2;


+ (DPConnectManager *)sharedConnectManager {
    static dispatch_once_t once;
    static id sharedInstance;
    dispatch_once(&once, ^{
        sharedInstance = [[self alloc] init];
    });
    return sharedInstance;
}

- (id)init {
    self = [super init];
    if (self) {
        self.playersToInvite = [NSMutableArray array];
        self.players = [NSMutableDictionary dictionary];
    }
    return self;
}

/**
 Authenticate the local user. If the user needs to sign in to GameCenter, 
 then the GK UI is presented modally using the Application handle
 */
- (void)startAuthenticatingLocalPlayer {
    __weak GKLocalPlayer *localPlayer = [GKLocalPlayer localPlayer];
    [localPlayer setAuthenticateHandler:^(UIViewController *viewController, NSError *error) {
        // We need to auth
        if (viewController) {
            UIViewController *rootViewController = [[[[UIApplication sharedApplication] delegate]
                                                     window] rootViewController];
            [rootViewController presentViewController:viewController animated:YES completion:nil];
        }
        // We are authenticated
        if (localPlayer.authenticated) {
            if (_delegate && [_delegate respondsToSelector:@selector(didAuthenticateLocalPlayer:)]) {
                [_delegate didAuthenticateLocalPlayer:localPlayer];
            }
            
            // Create match
            __weak GKMatchmaker *matchMaker = [GKMatchmaker sharedMatchmaker];
            [matchMaker setInviteHandler:^(GKInvite *acceptedInvite, NSArray *playersToInvite) {
                NSLog(@"MATCHMAKER INVITE HANDLER");
                
                if (acceptedInvite != nil) {
                    // Create match for accepted invite
                    [matchMaker matchForInvite:acceptedInvite completionHandler:^(GKMatch *match, NSError *error) {
                        NSLog(@"Match For Invite completion");
                        if (error) {
                            NSLog(@"Error %@", error);
                            return;
                        }
                        if (match != nil) {
                            [self disconnectFromMatch];
                            // New match
                            self.match = match;
                            self.match.delegate = self;
                        }
                    }];
                }
            
                if (playersToInvite) {
                    NSLog(@"We have players");
                }
            }];
            
            [self startSearchingForPlayers];
        }
    }];
}

//////////////////////////////////////////////////////////////////////
#pragma mark -
#pragma mark Player Management


- (void)startSearchingForPlayers {
    [[GKMatchmaker sharedMatchmaker] startBrowsingForNearbyPlayersWithReachableHandler:^(NSString *playerID, BOOL reachable) {
        if (reachable) {
            NSLog(@"Player to invite: %@", playerID);
            [self.playersToInvite addObject:playerID];
            [self fetchDataForPlayer:playerID];
        }
        else {
            [self.playersToInvite removeObject:playerID];
            
            [GKPlayer loadPlayersForIdentifiers:[NSArray arrayWithObject:playerID] withCompletionHandler:^(NSArray *players, NSError *error) {
                [self.players removeObjectForKey:playerID];
                if (_delegate && [_delegate respondsToSelector:@selector(didUpdatePlayers:)]) {
                    [_delegate didUpdatePlayers:[_players allValues]];
                }
            }];
        }
    }];
}

- (void)fetchDataForPlayer:(NSString *)playerID {
    [GKPlayer loadPlayersForIdentifiers:[NSArray arrayWithObject:playerID] withCompletionHandler:^(NSArray *players, NSError *error) {
        NSLog(@"Received players %@", players);
        [self.players setObject:[players lastObject] forKey:playerID];
        if (_delegate && [_delegate respondsToSelector:@selector(didUpdatePlayers:)]) {
            [_delegate didUpdatePlayers:[_players allValues]];
        }
    }];
}

//////////////////////////////////////////////////////////////////////
#pragma mark -
#pragma mark Match Management


- (void)createMatch {
    NSLog(@"Sending match request");
    GKMatchRequest *request = [[GKMatchRequest alloc] init];
    request.minPlayers = MIN_PLAYERS;
    request.maxPlayers = MAX_PLAYERS;
    request.playersToInvite = nil;
    request.inviteMessage = @"Let's Doodle!!";
    self.matchRequest = request;
    
    request.inviteeResponseHandler = ^(NSString *playerID, GKInviteeResponse response) {
        NSLog(@"INVITEE RESPONSE HANDLER");
        NSLog(@"playeer %@ response %d", playerID, response);
        if (response == GKInviteeResponseAccepted) {
            //finish here, but for more players, we would check count
            [self finishMatchMaking];
        }
    };
    
    [[GKMatchmaker sharedMatchmaker] findMatchForRequest:request withCompletionHandler:^(GKMatch *match, NSError *error) {
        NSLog(@"FIND MATCH COMPLETION");
        NSLog(@"%@", match);
        if (error) {
            NSLog(@"Error %@", error);
            [self disconnectFromMatch];
            return;
        }
        if (match) {
            self.match = match;
            self.match.delegate = self;
            
            [_delegate didCreateMatch:self.match];
        }
        
        NSLog(@"Expected players %d", match.expectedPlayerCount);
    }];
}

- (void)finishMatchMaking {
    [[GKMatchmaker sharedMatchmaker] finishMatchmakingForMatch:self.match];
    [[GKMatchmaker sharedMatchmaker] stopBrowsingForNearbyPlayers];
    
    NSLog(@"The Players are %@", self.match.playerIDs);
    if (self.match.playerIDs.count > 0) {
        NSData *data = [@"HELLO DOODLERS" dataUsingEncoding:NSUTF8StringEncoding];
        NSError *error;
        [self.match sendDataToAllPlayers:data withDataMode:GKMatchSendDataReliable error:&error];
        if (error) {
            NSLog(@"Send data error %@", error);
        }
    }

}

- (void)disconnectFromMatch {
    if (!_match) return;
    
    NSLog(@"Attempting to disconnect from match %@", _match);
    [self.match disconnect];
    self.match = nil;
}

//////////////////////////////////////////////////////////////////////
#pragma mark -
#pragma mark GKMatchDelegate

- (void)match:(GKMatch *)match player:(NSString *)playerID didChangeState:(GKPlayerConnectionState)state {
    NSLog(@"matchPlayerDIdChangeState");
    
    switch (state) {
        case GKPlayerStateUnknown:
            NSLog(@"!! Unknown player connection state");
            break;
        case GKPlayerStateConnected:
            NSLog(@"Player %@ connected to match %@", playerID, match);
            break;
        case GKPlayerStateDisconnected:
            NSLog(@"Player %@ DISconnected from match %@", playerID, match);
            break;
        default:
            NSLog(@"No state given");
            break;
    }
    
    if (!self.matchStarted && match.expectedPlayerCount == 0) {
        NSLog(@"TIME TO START THE MATCH YO");
        self.matchStarted = YES;
        [self finishMatchMaking];
    }
    
    if (_delegate && [_delegate respondsToSelector:@selector(didUpdatePlayer:withState:)]) {
        [_delegate didUpdatePlayer:playerID withState:state];
    }
}


- (void)match:(GKMatch *)match didReceiveData:(NSData *)data fromPlayer:(NSString *)playerID {
    NSString *message = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
    NSLog(@"matchDidReceiveData %@ %@ %@", match, message, playerID);
    
    if (_delegate && [_delegate respondsToSelector:@selector(didReceiveData:fromPlayer:)]) {
        [_delegate didReceiveData:data fromPlayer:playerID];
    }
}


- (BOOL)match:(GKMatch *)match shouldReinvitePlayer:(NSString *)playerID {
    NSLog(@"matchShouldReinvite %@ %@", match, playerID);
    return YES;
}

@end
