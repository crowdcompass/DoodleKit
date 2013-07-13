//
//  DPPlayer.m
//  DoodleKitExample
//
//  Created by Alexander Belliotti on 7/13/13.
//  Copyright (c) 2013 Alexander Belliotti. All rights reserved.
//

#import "DPPlayer.h"

@implementation DPPlayer

- (id)initWithPlayerNumber:(NSNumber *)number {
    self = [super init];
    if (self) {
        _playerNumber = number;
    }
    
    return self;
}

@end
