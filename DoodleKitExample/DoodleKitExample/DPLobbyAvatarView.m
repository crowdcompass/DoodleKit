//
//  DKLobbyAvatarView.m
//  DoodleKitExample
//
//  Created by Alexander Belliotti on 7/13/13.
//  Copyright (c) 2013 Alexander Belliotti. All rights reserved.
//

#import "DPLobbyAvatarView.h"

@interface DPLobbyAvatarView ()

@property (nonatomic, strong) NSNumber *index;

@end

#import "DPPlayer.h"

UIImage* imageForPlayerNumber(NSUInteger playerIndex, BOOL loaded) {
    NSString *imageName = nil;
    
    switch (playerIndex) {
        case 1:
            if (loaded) {
                imageName = @"player_blue";
            }
            else {
                imageName = @"player_unloaded";
            }
            break;
        case 2:
            if (loaded) {
                imageName = @"player_green";
            }
            else {
                imageName = @"player_unloaded";
            }
            break;
        case 3:
            if (loaded) {
                imageName = @"player_yellow";
            } else {
                imageName = @"player_unloaded";
            }
            break;
        case 4:
            if (loaded) {
                imageName = @"player_red";
            } else {
                imageName = @"player_unloaded";
            }
            break;
        default:
            [NSException raise:NSInternalInconsistencyException format:@"BAD THINGS"];
            break;
    }
    
    return [UIImage imageNamed:imageName];
}

UIFont* fontForLabel(BOOL isLoaded) {
    if (isLoaded) {
        return [UIFont fontWithName:@"Avenir-Book" size:24.f];
    } else {
        return [UIFont fontWithName:@"Avenir-Black" size:36.f];
    }
}

NSString* textForUnloadedLabel(NSUInteger playerNumber) {
    
    NSString *dotStr = @"";
    for (int i = 1; i <= playerNumber; i++) {
        dotStr = [dotStr stringByAppendingString:@"."];
    }
    
    return dotStr;
}

@implementation DPLobbyAvatarView

- (id)init {
    self = [super initWithFrame:CGRectMake(0.f, 0.f, 120.f, 180.f)];
    if (self) {
        self.backgroundColor = [UIColor whiteColor];
        
        _avatarView = [[UIImageView alloc] initWithFrame:CGRectMake(0.f, 0.f, 120.f, 120.f)];
        _avatarView.backgroundColor = [UIColor whiteColor];
        _avatarView.center = CGPointMake(60.f, 60.f);
        [self addSubview:_avatarView];
        
        _avatarLabel = [[UILabel alloc] initWithFrame:CGRectZero];
        _avatarLabel.center = CGPointMake(60.f, 130.f);
        _avatarLabel.textAlignment = NSTextAlignmentCenter;
        [self addSubview:_avatarLabel];
    }
    
    return self;
}

- (id)initWithPlayerNumber:(NSNumber *)number {
    self = [self init];
    if (self) {
        _index = number;
        _loaded = NO;
        _avatarView.image = imageForPlayerNumber(number.unsignedIntegerValue, _loaded);
        _avatarLabel.text = textForUnloadedLabel(number.unsignedIntegerValue);
        [_avatarLabel sizeToFit];
    }
    
    return self;
}

//this will probably only be used for player 1
- (id)initWithPlayer:(DPPlayer *)player {
    self = [self init];
    if (self) {
        _index = player.playerNumber;
    }
    
    return self;
}

- (void)layoutSubviews {
    _avatarLabel.center = CGPointMake(60.f, _avatarLabel.center.y);
}

- (void)setName:(NSString *)name {
    self.avatarView.image = imageForPlayerNumber(self.index.unsignedIntegerValue, YES);
    self.avatarLabel.font = fontForLabel(YES);
    self.avatarLabel.text = name ? name : textForUnloadedLabel(self.index.unsignedIntegerValue);
    [self.avatarLabel sizeToFit];
}


/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
}
*/

@end
