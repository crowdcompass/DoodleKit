//
//  GTViewController.m
//  DoodleTester
//
//  Created by Robert Corlett on 7/12/13.
//  Copyright (c) 2013 Robert Corlett. All rights reserved.
//

#import "GTViewController.h"
#import <GameKit/GameKit.h>


static NSInteger const HostTestFlag = 1 << 0;
static NSInteger const HostVerifyFlag = 1 << 1;
static NSInteger const HostConfirmFlag = 1 << 2;

@interface GTViewController ()
@property (nonatomic) NSMutableArray *deviceIDs;
@property (nonatomic) NSMutableSet *playersToInvite;
@property (nonatomic) GKMatch *match;
@property (nonatomic) NSInteger playerCount;
@property (nonatomic) BOOL isHost;
@property (nonatomic) GKPlayer *hostPlayer;
@end

@implementation GTViewController

- (id)init
{
    self = [super init];
    if (self) {
        self.playersToInvite = [NSMutableSet set];
        self.deviceIDs = [NSMutableArray array];

        self.playerCount = 2;
        self.isHost = NO;
    }
    return self;
}


- (void)loadView {
    UIView *view = [[UIView alloc] initWithFrame:CGRectZero];
    view.autoresizingMask = UIViewAutoresizingFlexibleHeight | UIViewAutoresizingFlexibleWidth;
    view.backgroundColor = [UIColor orangeColor];
    self.view = view;
    
    UIButton *button = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    [button setTitle:@"Click Me" forState:UIControlStateNormal];
    [button addTarget:self action:@selector(didTouchButton) forControlEvents:UIControlEventTouchUpInside];
    [button sizeToFit];
    [self.view addSubview:button];
}

- (void)didTouchButton {
    GKMatchRequest *request = [[GKMatchRequest alloc] init];
    request.minPlayers = self.playerCount;
    request.maxPlayers = self.playerCount;

    GKMatchmakerViewController *viewController = [[GKMatchmakerViewController alloc] initWithMatchRequest:request];
    viewController.matchmakerDelegate = self;
    [self presentViewController:viewController animated:YES completion:nil];
}

- (void)matchmakerViewControllerWasCancelled:(GKMatchmakerViewController *)viewController {
    [self dismissViewControllerAnimated:YES completion:nil];
    
}

- (void)matchmakerViewController:(GKMatchmakerViewController *)viewController didFailWithError:(NSError *)error {
    
}

- (void)matchmakerViewController:(GKMatchmakerViewController *)viewController didFindMatch:(GKMatch *)match {

    self.match = match;
    self.match.delegate = self;
    if (match.expectedPlayerCount == 0) {
        [self dismissViewControllerAnimated:YES completion:nil];
        [self.match chooseBestHostPlayerWithCompletionHandler:^(NSString *playerID) {
            NSLog(@"%@", self.match);
            NSLog(@"%@", playerID);

            NSString *myIdentifier = [[[UIDevice currentDevice] identifierForVendor] UUIDString];
            [self.deviceIDs addObject:myIdentifier];
            NSError *error;
            [self sendHostTest:myIdentifier];
            if (error) { assert(0); }
        }];
    }
}

- (void)sendHostTest:(NSString *)deviceID {
    NSData *payload = [self payloadForDictionary:@{ @"DeviceID": deviceID } withFlag:HostTestFlag];
    NSError *error;
    [self.match sendDataToAllPlayers:payload withDataMode:GKMatchSendDataReliable error:&error];
    if (error) { assert(0); }

}
- (void)matchmakerViewController:(GKMatchmakerViewController *)viewController didFindPlayers:(NSArray *)playerIDs {
    
}

- (void)matchmakerViewController:(GKMatchmakerViewController *)viewController didReceiveAcceptFromHostedPlayer:(NSString *)playerID {
    
}

//- (void)didTouchButton {
//    GKMatchRequest *request = [[GKMatchRequest alloc] init];
//    request.minPlayers = 2;
//    request.maxPlayers = 2;
//    request.defaultNumberOfPlayers = 2;
//    request.playersToInvite = [self.playersToInvite allObjects];
//    request.inviteeResponseHandler = ^(NSString *playerID, GKInviteeResponse response)
//    {
//        if (response == GKInviteeResponseAccepted && self.match.expectedPlayerCount == 0) {
//            GKMatchmaker *matchMaker = [GKMatchmaker sharedMatchmaker];
//            [matchMaker finishMatchmakingForMatch:self.match];
//            
//            NSError *newError;
//            [self.match sendDataToAllPlayers:[@"HELLO WORLD" dataUsingEncoding:NSUTF8StringEncoding] withDataMode:NSUTF8StringEncoding error:&newError];
//            if (newError) {
//                assert(NO);
//            }
//        }
//    };
//    
//    [[GKMatchmaker sharedMatchmaker] findMatchForRequest:request withCompletionHandler:^(GKMatch *match, NSError *error) {
//        NSLog(@"FIND MATCH");
//        NSLog(@"%@", match);
//        NSLog(@"%@", match.playerIDs);
//        NSLog(@"%@", error);
//        if (!error) {
//            self.match = match;
//            self.match.delegate = self;
//        }
//        
//    }];
//}

- (void)viewDidLoad
{
    [super viewDidLoad];
}

- (void)startSearching
{
//    __weak GKMatchmaker *matchmaker = [GKMatchmaker sharedMatchmaker];
//    [matchmaker setInviteHandler:^(GKInvite *acceptedInvitation, NSArray *players) {
//        assert(!players);
//        NSLog(@"INVITE HANDLER");
//        NSLog(@"%@", acceptedInvitation);
//        NSLog(@"%@", players);
//        
//        [matchmaker matchForInvite:acceptedInvitation completionHandler:^(GKMatch *match, NSError *error) {
//            NSLog(@"MatchForInvite");
//            NSLog(@"%@", match);
//            NSLog(@"%@", error);
//            NSLog(@"%d", match.expectedPlayerCount);
//            NSLog(@"%@", match.playerIDs);
//            
//            self.match = match;
//            self.match.delegate = self;
//
//            NSError *newError;
//            [self.match sendDataToAllPlayers:[@"HELLO WORLD" dataUsingEncoding:NSUTF8StringEncoding] withDataMode:NSUTF8StringEncoding error:&error];
//            if (newError) {
//                assert(NO);
//            }
//            if (match.expectedPlayerCount == 0) {
//                [matchmaker finishMatchmakingForMatch:match];
//            }
//            
//            
//        }];
//    }];
//    [[GKMatchmaker sharedMatchmaker] startBrowsingForNearbyPlayersWithReachableHandler:^(NSString *playerID, BOOL reachable) {
//        if (reachable) {
//            [self.playersToInvite addObject:playerID];
//        }
//    }];
}


// The match received data sent from the player.c

- (NSInteger)flagFromPayload:(NSData *)payload {
    NSInteger flag;
    [payload getBytes:&flag length:sizeof(NSInteger)];
    return flag;
}

- (NSDictionary *)dictionaryFromPayload:(NSData *)payload {
    NSDictionary *dictionary = [NSKeyedUnarchiver unarchiveObjectWithData:
                             [payload subdataWithRange:NSMakeRange(sizeof(NSInteger), [payload length] - sizeof(NSInteger))]];
    return dictionary;
}

- (void)receivedHostTestDictionary:(NSDictionary *)dictionary {
    NSString *deviceID = dictionary[@"DeviceID"];
    [self.deviceIDs addObject:deviceID];
    if (self.deviceIDs.count == self.playerCount) {
        [self.deviceIDs sortUsingComparator:^NSComparisonResult(id obj1, id obj2) {
            NSString *string1 = (NSString *)obj1;
            NSString *string2 = (NSString *)obj2;
            return [string1 compare:string2];
        }];

        if ([self.deviceIDs[0] isEqualToString:[[[UIDevice currentDevice] identifierForVendor] UUIDString]]) {
            [self becomeHost];
        }
    }
}

- (void)receivedHostVerifyDictionary:(NSDictionary *)dictionary {
    NSLog(@"%@", dictionary);
}

- (void)match:(GKMatch *)match didReceiveData:(NSData *)data fromPlayer:(NSString *)playerID {
    NSInteger flag = [self flagFromPayload:data];
    NSDictionary *dictionary = [self dictionaryFromPayload:data];


    switch (flag) {
        case HostTestFlag: {
            [self receivedHostTestDictionary:dictionary];
            break;
        }
        case HostVerifyFlag: {
            [self receivedHostVerifyDictionary:dictionary];
        }
        case HostConfirmFlag: {
            break;
        }
        default: {
            assert(0);
            break;
        }
    }
}

- (NSData *)payloadForDictionary:(NSDictionary *)dictionary withFlag:(NSInteger)flag {
    NSMutableData *prelude = [NSMutableData dataWithBytes:&flag length:sizeof(NSInteger)];
    NSData *data = [NSKeyedArchiver archivedDataWithRootObject:dictionary];
    [prelude appendData:data];
    return prelude;
}

- (void)becomeHost {
    self.isHost = YES;

    NSData *payload = [self payloadForDictionary:@{ @"message-id": @"become-host" } withFlag:HostVerifyFlag];
    NSError *error;
    [self.match sendDataToAllPlayers:payload withDataMode:GKMatchSendDataReliable error:&error];
    if (error) { assert(0); }

}

// The player state changed (eg. connected or disconnected)
- (void)match:(GKMatch *)match player:(NSString *)playerID didChangeState:(GKPlayerConnectionState)state {
    
}

// The match was unable to be established with any players due to an error.
- (void)match:(GKMatch *)match didFailWithError:(NSError *)error {
    
}

// This method is called when the match is interrupted; if it returns YES, a new invite will be sent to attempt reconnection. This is supported only for 1v1 games
- (BOOL)match:(GKMatch *)match shouldReinvitePlayer:(NSString *)playerID {
    return YES;
}

@end
