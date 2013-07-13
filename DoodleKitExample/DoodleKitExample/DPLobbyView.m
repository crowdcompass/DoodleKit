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

const CGFloat kPartyViewYPortrait = 145.f;
const CGFloat kPartyViewYLandscape = 70.f;

const CGFloat kPartyToAvatarVerticalPortrait = 175.f;
const CGFloat kPartyToAvatarVerticalLandscape = 60.f;

const CGFloat kPartyButtonYPortrait = 800.f;
const CGFloat kPartyButtonYLandscape = 660.f;

@interface DPLobbyView ()

@property (nonatomic, strong) UIImageView *partyView;
@property (nonatomic, strong) DPLobbyAvatarsContainerView *avatarsView;

@end

@implementation DPLobbyView

- (id)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [UIColor whiteColor];
        self.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
        
        BOOL isPortrait = UIInterfaceOrientationIsPortrait([[UIApplication sharedApplication] statusBarOrientation]);
        
        _partyView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"doodleParty"]];
        _partyView.autoresizingMask = UIViewAutoresizingFlexibleTopMargin | UIViewAutoresizingFlexibleLeftMargin;
        _partyView.center = self.center;
        CGFloat partyViewY = isPortrait ? kPartyViewYPortrait : kPartyViewYLandscape;
        _partyView.frame = CGRectSetY(_partyView.frame, partyViewY);
        [self addSubview:_partyView];
        
        CGFloat partyToAvatarVerticalSep = isPortrait ? kPartyToAvatarVerticalPortrait : kPartyToAvatarVerticalLandscape;
        CGFloat avatarsY = frame.origin.y + (_partyView.frame.origin.y +  _partyView.frame.size.height + partyToAvatarVerticalSep);
        _avatarsView = [[DPLobbyAvatarsContainerView alloc] initWithFrame:CGRectMake(0.f, avatarsY, frame.size.width, 180.f)];
        [self addSubview:_avatarsView];
    }
    
    return self;
}

- (void)layoutSubviews {
    CGFloat width = self.frame.size.width;
    BOOL isPortrait = UIInterfaceOrientationIsPortrait([[UIApplication sharedApplication] statusBarOrientation]);
    
    CGFloat partyViewY = isPortrait ? kPartyViewYPortrait : kPartyViewYLandscape;
    self.partyView.frame = CGRectSetY(self.partyView.frame, partyViewY);
    self.partyView.center = CGPointMake(width / 2.f, self.partyView.center.y);
    
    CGFloat partyToAvatarVerticalSep = isPortrait ? kPartyToAvatarVerticalPortrait : kPartyToAvatarVerticalLandscape;
    CGFloat avatarsY = self.frame.origin.y + (_partyView.frame.origin.y +  _partyView.frame.size.height + partyToAvatarVerticalSep);
    self.avatarsView.center = CGPointMake(width/ 2.f, (avatarsY + self.frame.size.height) / 2.f);
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
