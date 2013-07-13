//
//  DKLobbyAvatarView.m
//  DoodleKitExample
//
//  Created by Alexander Belliotti on 7/13/13.
//  Copyright (c) 2013 Alexander Belliotti. All rights reserved.
//

#import "DPLobbyAvatarView.h"

#import "DPPlayer.h"

@implementation DPLobbyAvatarView

- (id)init {
    self = [super initWithFrame:CGRectMake(0.f, 0.f, 120.f, 180.f)];
    if (self) {}
    
    return self;
}

- (id)initWithPlayer:(DPPlayer *)player {
    self = [self init];
    if (self) {
        
    }
    
    return self;
}

- (id)initWithPlayerNumber:(NSNumber *)number {
    self = [self init];
    if (self) {
        
    }
    
    return self;
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
