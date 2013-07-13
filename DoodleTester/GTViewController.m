//
//  GTViewController.m
//  DoodleTester
//
//  Created by Robert Corlett on 7/12/13.
//  Copyright (c) 2013 Robert Corlett. All rights reserved.
//

#import "GTViewController.h"
#import <GameKit/GameKit.h>


@interface GTViewController ()
@property (nonatomic) NSMutableSet *playersToInvite;
@property (nonatomic) GKMatch *match;
@end

@implementation GTViewController

- (id)init
{
    self = [super init];
    if (self) {
        self.playersToInvite = [NSMutableSet set];
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
    request.minPlayers = 2;
    request.maxPlayers = 3;

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
    if (match.expectedPlayerCount == 0) {
        [self dismissViewControllerAnimated:YES completion:nil];
        [self.match chooseBestHostPlayerWithCompletionHandler:^(NSString *playerID) {
            NSLog(@"%@", self.match);
            NSLog(@"%@", playerID);
        }];
    }


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


// The match received data sent from the player.
- (void)match:(GKMatch *)match didReceiveData:(NSData *)data fromPlayer:(NSString *)playerID {
    
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
