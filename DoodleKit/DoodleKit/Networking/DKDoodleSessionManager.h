//
//  DKDoodleSessionManager.h
//  DoodleKit
//
//  Created by Ryan Crosby on 7/14/13.
//  Copyright (c) 2013 DaveVan. All rights reserved.
//

#import <Foundation/Foundation.h>

#import <GameKit/GameKit.h>

@interface DKDoodleArtist : NSObject

@property (nonatomic, copy) NSString *displayName;
@property (nonatomic, copy) NSString *playerID;
@property (nonatomic, copy) NSString *peerID;
@property (nonatomic, assign) BOOL isLocal;

@end

@protocol DKDoodleSessionManagerDelegate <NSObject>

- (void)didAuthenticateLocalPlayer:(DKDoodleArtist *)doodleArtist;
- (void)artistDidConnect:(DKDoodleArtist *)doodleArtist;
- (void)artistDidDisconnect:(DKDoodleArtist *)doodleArtist;
- (void)didStartGame;

@end

@interface DKDoodleSessionManager : NSObject  <GKSessionDelegate>

@property (nonatomic, weak) id<DKDoodleSessionManagerDelegate> delegate;
@property (nonatomic, strong) DKDoodleArtist *doodleArtist;
@property (nonatomic, strong) NSMutableDictionary *doodleArtistPeers;

+ (instancetype)sharedManager;
- (void)start;
- (void)poll;
- (void)createMatch;

- (void)startAuthenticatingLocalPlayer;

#warning temp
- (void)sendDataToAllPlayers:(NSData *)data;


@end

