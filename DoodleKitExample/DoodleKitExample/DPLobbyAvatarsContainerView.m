//
//  DPLobbyAvatarsView.m
//  DoodleKitExample
//
//  Created by Alexander Belliotti on 7/13/13.
//  Copyright (c) 2013 Alexander Belliotti. All rights reserved.
//

#import "DPLobbyAvatarsContainerView.h"

#import "DPLobbyAvatarView.h"

#import "SSDrawingUtilities.h"

@interface DPLobbyAvatarsContainerView ()

@property (nonatomic, strong) NSArray *avatarViews;

@end

@implementation DPLobbyAvatarsContainerView

- (id)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        self.autoresizingMask = UIViewAutoresizingFlexibleWidth;
        self.backgroundColor = [UIColor whiteColor];
        
        DPLobbyAvatarView *player1 = [[DPLobbyAvatarView alloc] initWithPlayerNumber:@1];
        DPLobbyAvatarView *player2 = [[DPLobbyAvatarView alloc] initWithPlayerNumber:@2];
        DPLobbyAvatarView *player3 = [[DPLobbyAvatarView alloc] initWithPlayerNumber:@3];
        DPLobbyAvatarView *player4 = [[DPLobbyAvatarView alloc] initWithPlayerNumber:@4];
        _avatarViews = @[ player1, player2, player3, player4 ];
        
        for (DPLobbyAvatarView *avatarView in _avatarViews) {
            [self addSubview:avatarView];
        }
        
        [self setNeedsLayout];
    }
    
    return self;
}

//120 is avatar image width
- (void)layoutSubviews {
    BOOL isPortrait = UIInterfaceOrientationIsPortrait([[UIApplication sharedApplication] statusBarOrientation]);
    CGFloat leftRightMargin = isPortrait ? 66.f : 194.f;
    CGFloat interViewSpacing = 52.f;
    
    DPLobbyAvatarView *player1 = self.avatarViews[0];
    player1.frame = CGRectSetX(player1.frame, leftRightMargin);
    
    DPLobbyAvatarView *player2 = self.avatarViews[1];
    player2.frame = CGRectSetX(player2.frame, player1.frame.origin.x + 120.f + interViewSpacing);
    
    DPLobbyAvatarView *player3 = self.avatarViews[2];
    player3.frame = CGRectSetX(player3.frame, player2.frame.origin.x + 120.f + interViewSpacing);
    
    DPLobbyAvatarView *player4 = self.avatarViews[3];
    player4.frame = CGRectSetX(player4.frame, self.frame.origin.x + self.frame.size.width - leftRightMargin - 120.f);
}

- (DPLobbyAvatarView *)avatarForPlayerNumber:(NSUInteger)playerIndex {
    if (self.avatarViews.count < playerIndex) return nil;
    return self.avatarViews[playerIndex - 1];
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
