//
//  DKBoardController.h
//  DoodleKitExample
//
//  Created on 7/13/13.
//  Copyright (c) 2013 DaveVan. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <GameKit/GameKit.h>
#import <DoodleKit/DoodleKit.h>

@class DKDoodleView;
@class DPSwatchToolbar;

@interface DKBoardController : UIViewController <GKMatchmakerViewControllerDelegate, GKMatchDelegate, GTHostNegotiatorDelegate>

@property (weak, nonatomic) DPSwatchToolbar *toolbar;
@property (weak, nonatomic) DKDoodleView *drawingView;

@end
