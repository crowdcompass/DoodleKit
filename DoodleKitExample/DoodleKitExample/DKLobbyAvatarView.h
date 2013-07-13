//
//  DKLobbyAvatarView.h
//  DoodleKitExample
//
//  Created by Alexander Belliotti on 7/13/13.
//  Copyright (c) 2013 Alexander Belliotti. All rights reserved.
//

#import <UIKit/UIKit.h>

@class DPPlayer;

@interface DKLobbyAvatarView : UIView

@property (nonatomic, strong, readonly) UIImageView *avatarImage;

- (id)initWithPlayer:(DPPlayer *)player;
- (id)initWithPlayerNumber:(NSNumber *)number;

@end
