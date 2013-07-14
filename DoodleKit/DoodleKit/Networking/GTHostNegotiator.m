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

        [[GTMatchMessenger sharedMessenger] registerDataChannelWithFlag:InternalFlag object:self];

    }
    return self;
}

- (void)start {
    return;
    NSString *myIdentifier = [[[UIDevice currentDevice] identifierForVendor] UUIDString];
    [self.deviceIDs addObject:myIdentifier];
    [self sendHostTest:myIdentifier];
}

- (void)receivedHostStartGameDictionary:(NSDictionary *)dictionary {
    [self.delegate didStartGame];
}

- (void)didReceiveData:(NSData *)data fromPlayer:(NSString *)playerID {
    //NSInteger flag = [self flagFromPayload:data];
    NSDictionary *dictionary = [self dictionaryFromPayload:data];

    NSDictionary *stateToIntFlags = @{
                                      @"HostTest": @(HostTestFlag),
                                      @"HostConfirm": @(HostConfirmFlag),
                                      @"HostClaim": @(HostClaimFlag),
                                      @"StartGame": @(StartGameFlag)
                                      };
    NSInteger flag = [stateToIntFlags[dictionary[@"State"]] intValue];

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

- (NSDictionary *)dictionaryFromPayload:(NSData *)payload {
    NSDictionary *dictionary = [NSKeyedUnarchiver unarchiveObjectWithData:payload];
    return dictionary;
}

- (NSData *)payloadForDictionary:(NSDictionary *)dictionary withFlag:(NSInteger)flag {
    NSData *data = [NSKeyedArchiver archivedDataWithRootObject:dictionary];
    return data;
}

- (void)sendHostTest:(NSString *)deviceID {
    NSData *payload = [self payloadForDictionary:@{ @"State": @"HostTest", @"DeviceID": deviceID } withFlag:HostTestFlag];
    GTMatchMessenger *messenger = [GTMatchMessenger sharedMessenger];
    [messenger sendDataToAllPlayers:payload withFlag:InternalFlag];
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
    NSData *payload = [self payloadForDictionary:@{ @"State": @"HostConfirm" } withFlag:HostConfirmFlag];
    GTMatchMessenger *messenger = [GTMatchMessenger sharedMessenger];
    [messenger sendDataToHost:payload withFlag:InternalFlag];
}

- (void)sendStartGame {
    NSData *payload = [self payloadForDictionary:@{ @"State": @"StartGame" } withFlag:StartGameFlag];
    GTMatchMessenger *messenger = [GTMatchMessenger sharedMessenger];
    [messenger sendDataToAllPlayers:payload withFlag:InternalFlag];

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

    NSData *payload = [self payloadForDictionary:@{ @"State": @"HostClaim" } withFlag:HostClaimFlag];
    GTMatchMessenger *messenger = [GTMatchMessenger sharedMessenger];
    [messenger sendDataToAllPlayers:payload withFlag:InternalFlag];
}

- (void)receivedHostClaimDictionary:(NSDictionary *)dictionary fromPlayer:(NSString *)playerID {
    GTMatchMessenger *messenger = [GTMatchMessenger sharedMessenger];
    messenger.hostPlayerID = playerID;
    [self sendHostConfirmation];
}


@end
