//
//  GTHostNegotiator.m
//  DoodleTester
//
//  Created by Chris Hellmuth on 7/13/13.
//  Copyright (c) 2013 Robert Corlett. All rights reserved.
//

#import "GTHostNegotiator.h"

static NSInteger const HostTestFlag = 1 << 0;
static NSInteger const HostClaimFlag = 1 << 1;
static NSInteger const HostConfirmFlag = 1 << 2;
static NSInteger const StartGameFlag = 1 << 3;

@interface GTHostNegotiator ()
@property (nonatomic) NSMutableArray *deviceIDs;
@property (nonatomic) BOOL isHost;
@property (nonatomic) NSMutableSet *confirmedPlayers;

@end

@implementation GTHostNegotiator

- (id)init {
    self = [super init];
    if (self) {
        self.deviceIDs = [NSMutableArray array];
        self.confirmedPlayers = [NSMutableSet set];

        self.isHost = NO;

    }
    return self;
}

- (void)start {
    NSString *myIdentifier = [[[UIDevice currentDevice] identifierForVendor] UUIDString];
    [self.deviceIDs addObject:myIdentifier];
    [self sendHostTest:myIdentifier];
}

- (void)receivedHostStartGameDictionary:(NSDictionary *)dictionary {
    [self.delegate didStartGame];
}

- (void)match:(GKMatch *)match didReceiveData:(NSData *)data fromPlayer:(NSString *)playerID {
    NSInteger flag = [self flagFromPayload:data];
    NSDictionary *dictionary = [self dictionaryFromPayload:data];


    NSLog(@"%d, %@", flag, dictionary);
    switch (flag) {
        case HostTestFlag: {
            [self receivedHostTestDictionary:dictionary];
            break;
        }
        case HostClaimFlag: {
            [self receivedHostClaimDictionary:dictionary fromPlayer:playerID];
        }
        case HostConfirmFlag: {
            [self receivedHostConfirmDictionary:dictionary fromPlayer:playerID];
            break;
        }
        case StartGameFlag: {
            [self receivedHostStartGameDictionary:dictionary];
            break;
        }
        default: {
            assert(0);
            break;
        }
    }
}


- (NSInteger)flagFromPayload:(NSData *)payload {
    NSInteger flag;
    [payload getBytes:&flag length:sizeof(NSInteger)];
    return flag;
}

- (NSDictionary *)dictionaryFromPayload:(NSData *)payload {
    NSDictionary *dictionary = [NSKeyedUnarchiver unarchiveObjectWithData:
                                [payload subdataWithRange:NSMakeRange(sizeof(NSInteger), [payload length] - sizeof(NSInteger))]];
    return dictionary;
}

- (NSData *)payloadForDictionary:(NSDictionary *)dictionary withFlag:(NSInteger)flag {
    NSMutableData *prelude = [NSMutableData dataWithBytes:&flag length:sizeof(NSInteger)];
    NSData *data = [NSKeyedArchiver archivedDataWithRootObject:dictionary];
    [prelude appendData:data];
    return prelude;
}


- (void)sendHostTest:(NSString *)deviceID {
    NSData *payload = [self payloadForDictionary:@{ @"DeviceID": deviceID } withFlag:HostTestFlag];
    [self.messenger sendDataToAllPlayers:payload];
}

- (void)receivedHostTestDictionary:(NSDictionary *)dictionary {
    NSString *deviceID = dictionary[@"DeviceID"];
    [self.deviceIDs addObject:deviceID];
    if (self.deviceIDs.count == [self.delegate playerCount]) {
        [self.deviceIDs sortUsingComparator:^NSComparisonResult(id obj1, id obj2) {
            NSString *string1 = (NSString *)obj1;
            NSString *string2 = (NSString *)obj2;
            return [string1 compare:string2];
        }];

        if ([self.deviceIDs[0] isEqualToString:[[[UIDevice currentDevice] identifierForVendor] UUIDString]]) {
            [self becomeHost];
        }
    }
}

- (void)sendHostConfirmation {
    NSData *payload = [self payloadForDictionary:@{ @"message-id": @"you are the host" } withFlag:HostConfirmFlag];
    [self.messenger sendDataToHost:payload];
}

- (void)sendStartGame {
    NSData *payload = [self payloadForDictionary:@{ @"message-id": @"start game" } withFlag:StartGameFlag];
    [self.messenger sendDataToAllPlayers:payload];

    [self.delegate didStartGame];
}

- (void)receivedHostConfirmDictionary:(NSDictionary *)dictionary fromPlayer:(NSString *)playerID {
    [self.confirmedPlayers addObject:playerID];
    if (self.confirmedPlayers.count == [self.delegate playerCount] - 1) {
        [self sendStartGame];
    }
}

- (void)becomeHost {
    [self.delegate didBecomeHost];
    self.isHost = YES;

    NSData *payload = [self payloadForDictionary:@{ @"message-id": @"become-host" } withFlag:HostClaimFlag];
    [self.messenger sendDataToAllPlayers:payload];
}

- (void)receivedHostClaimDictionary:(NSDictionary *)dictionary fromPlayer:(NSString *)playerID {
    self.messenger.hostPlayerID = playerID;
    [self sendHostConfirmation];
}


@end
