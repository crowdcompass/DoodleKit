//
//  DPLobbyView.h
//  DoodleKitExample
//
//  Created by Alexander Belliotti on 7/13/13.
//  Copyright (c) 2013 Alexander Belliotti. All rights reserved.
//

#import <UIKit/UIKit.h>

@class DPStartDoodleButton;

@interface DPLobbyView : UIView

@property (nonatomic, strong) DPStartDoodleButton *button;

- (void)setPlayerName:(NSString *)name forPlayerIndex:(NSUInteger)playerIndex;

@end
