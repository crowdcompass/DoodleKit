//
//  DKLobbyAvatarView.m
//  DoodleKitExample
//
//  Created by Alexander Belliotti on 7/13/13.
//  Copyright (c) 2013 Alexander Belliotti. All rights reserved.
//

#import "DPLobbyAvatarView.h"

#import "DPPlayer.h"

UIImage* imageForPlayerNumber(NSInteger playerIndex, BOOL loaded) {
    NSString *imageName = nil;
    
    switch (playerIndex) {
        case 1:
            imageName = @"player_blue";
            break;
        case 2:
            imageName = @"player_green";
            break;
        case 3:
            if (loaded) {
                imageName = @"player_orange";
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

NSString* textForUnloadedLabel(NSInteger playerNumber) {
    if (playerNumber == 1) return @"Bieber";
    
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
        _loaded = number.integerValue < 3;
        _avatarView.image = imageForPlayerNumber(number.integerValue, _loaded);
        _avatarLabel.text = textForUnloadedLabel(number.integerValue);
        [_avatarLabel sizeToFit];
    }
    
    return self;
}

//this will probably only be used for player 1
- (id)initWithPlayer:(DPPlayer *)player {
    self = [self init];
    if (self) {
    }
    
    return self;
}

- (void)layoutSubviews {
    _avatarLabel.center = CGPointMake(60.f, _avatarLabel.center.y);
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
