//
//  DPConnectManager.h
//  DoodleKitExample
//
//  Created by Dave Shanley on 7/13/13.
//  Copyright (c) 2013 Alexander Belliotti. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <GameKit/GameKit.h>

@protocol DPConnectManagerDelegate <NSObject>

- (void)didAuthenticateLocalPlayer:(GKLocalPlayer *)player;
- (void)didUpdatePlayers:(NSArray *)players;
- (void)didReceiveData:(NSData *)data fromPlayer:(NSString *)playerID;
- (void)didUpdatePlayer:(NSString *)playerID withState:(GKPlayerConnectionState)state;
- (void)didCreateMatch:(GKMatch *)match;

@end

@interface DPConnectManager : NSObject <GKMatchDelegate>

@property (nonatomic, weak) id<DPConnectManagerDelegate> delegate;
@property (nonatomic, strong) NSMutableDictionary *players; // an array of GKPlayers

+ (DPConnectManager *)sharedConnectManager;
- (void)startAuthenticatingLocalPlayer;
- (void)createMatch;

@end
