//
//  DPPlayer.h
//  DoodleKitExample
//
//  Created by Alexander Belliotti on 7/13/13.
//  Copyright (c) 2013 Alexander Belliotti. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <DoodleKit/DoodleKit.h>

@interface DPPlayer : NSObject

@property (nonatomic, strong) NSNumber *playerNumber;
@property (nonatomic, strong) DKDoodleArtist *doodleArtist;

- (id)initWithPlayerNumber:(NSNumber *)number;

@end
