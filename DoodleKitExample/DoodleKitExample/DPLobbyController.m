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


@interface DPLobbyController ()

@property (nonatomic, strong) DPConnectManager *connectManager;

//target/action
- (void)startPressed;



@end

@implementation DPLobbyController

- (id)initWithPlayer:(DPPlayer *)player {
    self = [super init];
    if (self) {
        self.connectManager = [DPConnectManager sharedConnectManager];
        self.connectManager.delegate = self;
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
    
}

- (void)didUpdatePlayers:(NSArray *)players {
    NSLog(@"Lobby: We have new players %@", players);
}

- (void)didReceiveData:(NSData *)data fromPlayer:(NSString *)playerID {
    
}

- (void)didUpdatePlayer:(NSString *)playerID withState:(GKPlayerConnectionState)state {
    
}



@end
