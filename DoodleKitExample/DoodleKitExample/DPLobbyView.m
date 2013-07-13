//
//  DPLobbyView.m
//  DoodleKitExample
//
//  Created by Alexander Belliotti on 7/13/13.
//  Copyright (c) 2013 Alexander Belliotti. All rights reserved.
//

#import "DPLobbyView.h"

#import "DPLobbyAvatarsContainerView.h"

#import "SSDrawingUtilities.h"

@interface DPLobbyView ()

@property (nonatomic, strong) UIImageView *partyView;
@property (nonatomic, strong) DPLobbyAvatarsContainerView *avatarsView;

@end

@implementation DPLobbyView

- (id)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        _partyView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"doodleParty"]];
        _partyView.autoresizingMask = UIViewAutoresizingFlexibleTopMargin;
        _partyView.center = self.center;
        CGRectSetY(_partyView.frame, 200.f);
        
        
        
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
