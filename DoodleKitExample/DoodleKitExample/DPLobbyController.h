//
//  DPLobbyController.h
//  DoodleKitExample
//
//  Created by Alexander Belliotti on 7/13/13.
//  Copyright (c) 2013 Alexander Belliotti. All rights reserved.
//

#import <UIKit/UIKit.h>

#import <DoodleKit/DKDoodleSessionManager.h>

@class DPPlayer;
@class DPLobbyView;

@interface DPLobbyController : UIViewController <DKDoodleSessionManagerDelegate>

@property (nonatomic, weak) DPLobbyView *lobbyView;

- (id)initWithPlayer:(DPPlayer *)player;

@end

