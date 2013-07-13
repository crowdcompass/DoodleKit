//
//  GTViewController.m
//  DoodleTester
//
//  Created by Robert Corlett on 7/12/13.
//  Copyright (c) 2013 Robert Corlett. All rights reserved.
//

#import "GTViewController.h"
#import <GameKit/GameKit.h>

#import "GTHostNegotiator.h"
#import "GTMatchMessenger.h"

@interface GTViewController ()
@property (nonatomic) NSMutableSet *playersToInvite;
@property (nonatomic) GKMatch *match;
@property (nonatomic) NSInteger playerCount;
@property (nonatomic) GTHostNegotiator *negotiator;
@property (nonatomic) GTMatchMessenger *messenger;

@property (nonatomic) UILabel *startGameLabel;
@property (nonatomic) UILabel *iAmHostLabel;
@end

@implementation GTViewController

- (id)init
{
    self = [super init];
    if (self) {
        self.playersToInvite = [NSMutableSet set];

        self.playerCount = 2;
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

    UILabel *startGameLabel = [self labelWithText:@"LETS GET THIS PARTY STARTED"];
    startGameLabel.center = CGPointMake(100.f, 100.f);
    [self.view addSubview:startGameLabel];
    self.startGameLabel = startGameLabel;
    [self.startGameLabel setHidden:YES];

    UILabel *iAmHostLabel = [self labelWithText:@"I THINK I AM THE HOST"];
    iAmHostLabel.center = CGPointMake(250.f, 250.f);
    [self.view addSubview:iAmHostLabel];
    self.iAmHostLabel = iAmHostLabel;
    self.iAmHostLabel.hidden = YES;
}

- (UILabel *)labelWithText:(NSString *)text {
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectZero];
    label.text = text;
    label.backgroundColor = [UIColor clearColor];
    label.textColor = [UIColor blackColor];
    [label sizeToFit];
    return label;
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
    NSLog(@"%@", match.playerIDs);
    self.match = match;
    self.match.delegate = self;
    if (match.expectedPlayerCount == 0) {
        [self dismissViewControllerAnimated:YES completion:nil];

        GTMatchMessenger *messenger = [[GTMatchMessenger alloc] initWithMatch:self.match];
        self.messenger = messenger;
        
        GTHostNegotiator *negotiator = [[GTHostNegotiator alloc] init];
        negotiator.delegate = self;
        negotiator.match = self.match;
        negotiator.messenger = self.messenger;
        //self.match.delegate = negotiator;

        self.negotiator = negotiator;
        [self.negotiator start];
    }
}

- (void)matchmakerViewController:(GKMatchmakerViewController *)viewController didFindPlayers:(NSArray *)playerIDs {
    
}

- (void)matchmakerViewController:(GKMatchmakerViewController *)viewController didReceiveAcceptFromHostedPlayer:(NSString *)playerID {
    
}

- (void)didStartGame {
    [self.startGameLabel setHidden:NO];
}

// The player state changed (eg. connected or disconnected)
- (void)match:(GKMatch *)match player:(NSString *)playerID didChangeState:(GKPlayerConnectionState)state {
    NSLog(@"%@ %d", playerID, state);
}

// The match was unable to be established with any players due to an error.
- (void)match:(GKMatch *)match didFailWithError:(NSError *)error {
    
}

// This method is called when the match is interrupted; if it returns YES, a new invite will be sent to attempt reconnection. This is supported only for 1v1 games
- (BOOL)match:(GKMatch *)match shouldReinvitePlayer:(NSString *)playerID {
    return YES;
}

- (void)startSearching {}



- (void)match:(GKMatch *)match didReceiveData:(NSData *)data fromPlayer:(NSString *)playerID {
    NSLog(@"I AM RECEIVING DATA");
    [self.negotiator match:match didReceiveData:data fromPlayer:playerID];
}



- (void)didBecomeHost {
    self.iAmHostLabel.hidden = NO;
}


@end
