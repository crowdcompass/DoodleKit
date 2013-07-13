//
//  DPLobbyController.m
//  DoodleKitExample
//
//  Created by Alexander Belliotti on 7/13/13.
//  Copyright (c) 2013 Alexander Belliotti. All rights reserved.
//

#import "DPLobbyController.h"

#import "DPLobbyView.h"
#import "DPStartDoodleButton.h"

@interface DPLobbyController ()

//target/action
- (void)startPressed;

@end

@implementation DPLobbyController

- (id)initWithPlayer:(DPPlayer *)player {
    self = [super init];
    if (self) {
        
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
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - DPLobbyController

#pragma mark Target/action

- (void)startPressed {
    //attack!
}

@end
