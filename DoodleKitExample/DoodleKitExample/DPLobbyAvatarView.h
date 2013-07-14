//
//  DKLobbyAvatarView.h
//  DoodleKitExample
//
//  Created by Alexander Belliotti on 7/13/13.
//  Copyright (c) 2013 Alexander Belliotti. All rights reserved.
//

#import <UIKit/UIKit.h>

@class DPPlayer;

@interface DPLobbyAvatarView : UIView

@property (nonatomic, strong, readonly) UIImageView *avatarView;
@property (nonatomic, strong, readonly) UILabel *avatarLabel;

@property (nonatomic, assign, getter = isLoaded) BOOL loaded;

- (id)initWithPlayerNumber:(NSNumber *)number;
- (id)initWithPlayer:(DPPlayer *)player;

- (void)setName:(NSString *)name;
//TODO: set name and image

@end
