//
//  DPLobbyController.m
//  DoodleKitExample
//
//  Created by Alexander Belliotti on 7/13/13.
//  Copyright (c) 2013 Alexander Belliotti. All rights reserved.
//

#import "DPLobbyController.h"
#import "DKBoardController.h"
#import "DPLobbyView.h"
#import "DPStartDoodleButton.h"

#import <NSArray+BlocksKit.h>



@interface DPLobbyController ()

@property (nonatomic, strong) DKDoodleSessionManager *doodleSessionManager;

@property (nonatomic, strong) DKDoodleArtist *doodleArtist;
@property (nonatomic, strong) NSMutableArray *doodleArtists;


//target/action
- (void)startPressed;



@end

@implementation DPLobbyController

- (id)initWithPlayer:(DPPlayer *)player {
    self = [super init];
    if (self) {
        self.doodleSessionManager = [DKDoodleSessionManager sharedManager];
        _doodleSessionManager.delegate = self;
        
        self.doodleArtists = [NSMutableArray array];
    }
    
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
	
    self.view.backgroundColor = [UIColor whiteColor];
    
    DPLobbyView *lobbyView = [[DPLobbyView alloc] initWithFrame:self.view.frame];
    [self.view addSubview:lobbyView];
    self.lobbyView = lobbyView;
    
    [self.lobbyView.button addTarget:self action:@selector(startPressed) forControlEvents:UIControlEventTouchUpInside];

//    [self.lobbyView.button setEnabled:NO];

}

- (void)viewDidAppear:(BOOL)animated {
    DKDoodleSessionManager *sessionManager = [DKDoodleSessionManager sharedManager];
    [sessionManager startAuthenticatingLocalPlayer];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - DPLobbyController

#pragma mark Target/action

- (void)startPressed {
    [[DKDoodleSessionManager sharedManager] createMatch];
    return;
//    [_connectManager createMatch];
    DKBoardController *boardController = [[DKBoardController alloc] init];
    [self presentViewController:boardController animated:NO completion:nil];
    
}

//////////////////////////////////////////////////////////////////////
#pragma mark -
#pragma mark DKDoodleSessionManager

- (void)didAuthenticateLocalPlayer:(DKDoodleArtist *)doodleArtist {
    self.doodleArtist = doodleArtist;
    [_doodleArtists addObject:doodleArtist];
    
    [self updatePlayerAvatars];
}

- (void)artistDidConnect:(DKDoodleArtist *)aDoodleArtist {
    
    __block NSUInteger lastIdx = NSNotFound;
    [_doodleArtists enumerateObjectsUsingBlock:^(DKDoodleArtist *doodleArtist, NSUInteger idx, BOOL *stop) {
        if ([doodleArtist.peerID isEqualToString:aDoodleArtist.peerID]) {
            lastIdx = idx;
            *stop = YES;
        }
    }];
    
    if (lastIdx == NSNotFound) {
        [self.doodleArtists addObject:aDoodleArtist];
    }

    [_doodleArtists sortUsingComparator:^NSComparisonResult(id obj1, id obj2) {
        return [((DKDoodleArtist *)obj1).peerID compare:((DKDoodleArtist *)obj2).peerID];
    }];
    
    [self updatePlayerAvatars];
}

- (void)artistDidDisconnect:(DKDoodleArtist *)aDoodleArtist {

    __block NSUInteger lastIdx = NSNotFound;
    [_doodleArtists enumerateObjectsUsingBlock:^(DKDoodleArtist *doodleArtist, NSUInteger idx, BOOL *stop) {
        if ([doodleArtist.peerID isEqualToString:aDoodleArtist.peerID]) {
            lastIdx = idx;
            *stop = YES;
        }
    }];
    
    if (lastIdx != NSNotFound) {
        [_doodleArtists removeObjectAtIndex:lastIdx];
    }

    [self updatePlayerAvatars];
}

- (void)updatePlayerAvatars {

    [_doodleArtists enumerateObjectsUsingBlock:^(DKDoodleArtist *doodleArtist, NSUInteger idx, BOOL *stop) {
        [self.lobbyView setPlayerName:doodleArtist.displayName forPlayerIndex:idx +1];
    }];
    
    NSUInteger idx;
    for (idx = [_doodleArtists count]; idx < 4; idx++) {
        [self.lobbyView setPlayerName:nil forPlayerIndex:(idx + 1)];
    }

}

- (void)didStartGame {
    DKBoardController *boardController = [[DKBoardController alloc] init];
    [self presentViewController:boardController animated:NO completion:nil];
}

- (void)didReceiveData:(NSData *)data fromPlayer:(NSString *)playerID {
    NSLog(@"didReceiveData from Player");
}

- (void)didUpdatePlayer:(NSString *)playerID withState:(GKPlayerConnectionState)state {
    NSLog(@"didUpdatePlayer");
}

- (void)didCreateMatch:(GKMatch *)match {
    
}

- (void)didEstablishDataConnection {
    NSLog(@"Lobby: connection established!");
    DKBoardController *boardController = [[DKBoardController alloc] init];
    //boardController.match = _connectManager.match;
    [self presentViewController:boardController animated:NO completion:nil];
}

@end
