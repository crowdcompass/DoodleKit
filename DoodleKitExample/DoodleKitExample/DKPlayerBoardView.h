//
//  DKPlayerBoardView.h
//  DoodleKitExample
//
//  Created by Kerney, Benjamin on 7/14/13.
//  Copyright (c) 2013 Alexander Belliotti. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface DKPlayerBoardView : UIControl

@property (nonatomic, retain) UIImage *image;

- (void)setReady;
- (void)revealPermanently;

@end
