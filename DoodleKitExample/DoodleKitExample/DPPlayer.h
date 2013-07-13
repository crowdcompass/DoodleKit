//
//  DPPlayer.h
//  DoodleKitExample
//
//  Created by Alexander Belliotti on 7/13/13.
//  Copyright (c) 2013 Alexander Belliotti. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <GameKit/GameKit.h>

@interface DPPlayer : NSObject

@property (nonatomic, strong) NSNumber *playerNumber;
@property (nonatomic, strong) GKPlayer *gkPlayer;

- (id)initWithPlayerNumber:(NSNumber *)number;

@end
