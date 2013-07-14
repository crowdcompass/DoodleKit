//
//  DKDoodleSessionManager.h
//  DoodleKit
//
//  Created by Ryan Crosby on 7/14/13.
//  Copyright (c) 2013 DaveVan. All rights reserved.
//

#import <Foundation/Foundation.h>

#import <GameKit/GameKit.h>

@protocol DKDoodleSessionManagerDelegate <NSObject>

@end

@interface DKDoodleSessionManager : NSObject  <GKSessionDelegate>

+ (instancetype)sharedManager;
- (void)start;
- (void)poll;
- (void)createMatch;

@property (nonatomic, weak) id<DKDoodleSessionManagerDelegate> delegate;

@end
