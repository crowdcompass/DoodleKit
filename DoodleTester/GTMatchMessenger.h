//
//  GTMatchMessenger.h
//  DoodleTester
//
//  Created by Chris Hellmuth on 7/13/13.
//  Copyright (c) 2013 Robert Corlett. All rights reserved.
//

#import <Foundation/Foundation.h>

#import <GameKit/GameKit.h>

@interface GTMatchMessenger : NSObject

- (id)initWithMatch:(GKMatch *)match;

- (void)sendDataToHost:(NSData *)data;
- (void)sendDataToAllPlayers:(NSData *)data;

@property (nonatomic, copy) NSString *hostPlayerID;


@end
