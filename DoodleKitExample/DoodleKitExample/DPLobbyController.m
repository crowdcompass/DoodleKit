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

@property (nonatomic, strong) DPConnectManager *connectManager;

@property (nonatomic, strong) GKLocalPlayer *localPlayer;
@property (nonatomic, strong) NSArray *allPlayers;


//target/action
- (void)startPressed;



@end

@implementation DPLobbyController

- (id)initWithPlayer:(DPPlayer *)player {
    self = [super init];
    if (self) {
        self.connectManager = [DPConnectManager sharedConnectManager];
        self.connectManager.delegate = self;
        
        self.allPlayers = [NSArray array];
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

    [self.lobbyView.button setEnabled:NO];
    
    // Start filling the lobby
    [_connectManager startAuthenticatingLocalPlayer];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - DPLobbyController

#pragma mark Target/action

- (void)startPressed {
//    [_connectManager createMatch];
    DKBoardController *boardController = [[DKBoardController alloc] init];
    [self presentViewController:boardController animated:NO completion:nil];
    
}

//////////////////////////////////////////////////////////////////////
#pragma mark -
#pragma mark DPConnectManagerDelegate

- (void)didAuthenticateLocalPlayer:(GKLocalPlayer *)player {
    self.localPlayer = player;
    [self.lobbyView setPlayerName:player.alias forPlayerIndex:1];
    //self.
    //playe
}

- (void)didUpdatePlayers:(NSArray *)players {
    NSLog(@"Lobby: We have new players %@", players);
    NSArray *tempArray = [players arrayByAddingObject:_localPlayer];

    self.allPlayers = [tempArray sortedArrayUsingSelector:@selector(playerID)];
    
    __block NSUInteger lastIdx;
    [_allPlayers enumerateObjectsUsingBlock:^(GKPlayer *player, NSUInteger idx, BOOL *stop) {
        [self.lobbyView setPlayerName:player.alias forPlayerIndex:(idx + 1)];
        if ((idx + 1) > 4) {
            lastIdx = idx;
            *stop = YES;
        }
    }];
    
    for (; lastIdx < 4; lastIdx++) {
        [self.lobbyView setPlayerName:nil forPlayerIndex:(lastIdx + 1)];
    }
    
#warning Modify this to set players required to 4
    [self.lobbyView.button setEnabled:([_allPlayers count] > 1)];
    
//    if (([_allPlayers count] > 1)) {
//        [self.connectManager createMatch];
//    }
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
    boardController.match = _connectManager.match;
    [self presentViewController:boardController animated:NO completion:nil];
}

@end
