//
//  DPLobbyView.m
//  DoodleKitExample
//
//  Created by Alexander Belliotti on 7/13/13.
//  Copyright (c) 2013 Alexander Belliotti. All rights reserved.
//

#import "DPLobbyView.h"

#import "DPLobbyAvatarsContainerView.h"
#import "DPStartDoodleButton.h"

#import "SSDrawingUtilities.h"

const CGFloat kPartyViewYPortrait = 145.f;
const CGFloat kPartyViewYLandscape = 70.f;

const CGFloat kPartyToAvatarVerticalPortrait = 180.f;
const CGFloat kPartyToAvatarVerticalLandscape = 60.f;

const CGFloat kPartyButtonYPortrait = 880.f;
const CGFloat kPartyButtonYLandscape = 640.f;

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
        
        _button = [[DPStartDoodleButton alloc] init];
        _button.center = CGPointMake(self.center.x, 0.f);
        CGFloat buttonY = isPortrait ? kPartyButtonYPortrait : kPartyButtonYLandscape;
        _button.frame = CGRectSetY(_button.frame, buttonY);
        [self addSubview:_button];
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
    self.avatarsView.frame = CGRectSetY(self.avatarsView.frame, avatarsY);
    self.avatarsView.center = CGPointMake(width/ 2.f, self.avatarsView.center.y);
    
    CGFloat buttonY = isPortrait ? kPartyButtonYPortrait : kPartyButtonYLandscape;
    self.button.frame = CGRectSetY(self.button.frame, buttonY);
    self.button.center = CGPointMake(width / 2.f, self.button.center.y);
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
