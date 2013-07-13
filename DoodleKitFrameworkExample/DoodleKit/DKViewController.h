//
//  DKViewController.h
//  DoodleKit
//
//  Created on 7/12/13.
//  Copyright (c) 2013 DaveVan. All rights reserved.
//

#import <UIKit/UIKit.h>

@class DKDoodleView;

@interface DKViewController : UIViewController

@property (weak, nonatomic) IBOutlet DKDoodleView *drawingView;

@end
