//
//  DKBoardController.h
//  DoodleKitExample
//
//  Created on 7/13/13.
//  Copyright (c) 2013 DaveVan. All rights reserved.
//

#import <UIKit/UIKit.h>

@class DKDoodleView;
@class DPSwatchToolbar;

@interface DKBoardController : UIViewController

@property (weak, nonatomic) DPSwatchToolbar *toolbar;
@property (weak, nonatomic) DKDoodleView *drawingView;

@end
