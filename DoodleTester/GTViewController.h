//
//  GTViewController.h
//  DoodleTester
//
//  Created by Robert Corlett on 7/12/13.
//  Copyright (c) 2013 Robert Corlett. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <GameKit/GameKit.h>

#import "GTHostNegotiator.h"
@interface GTViewController : UIViewController <GKMatchmakerViewControllerDelegate, GTHostNegotiatorDelegate, GKMatchDelegate>

- (void)startSearching;

@end
