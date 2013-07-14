//
//  DKSerializer.m
//  DoodleKit
//
//  Created by Kerney, Benjamin on 7/12/13.
//  Copyright (c) 2013 DaveVan. All rights reserved.
//

#import "DKSerializer.h"

#import <Foundation/Foundation.h>


@interface DKSerializer () {
    NSMutableArray *_dataPoints;
    DKDrawingStrokeDefinition *_strokeDefinition;
}

@end

@implementation DKSerializer

- (id)init {
    self = [super init];
    if (self) {
        [[GTMatchMessenger sharedMessenger] registerDataChannelWithFlag:DoodleFlag object:self];
    }
    return self;
}

- (DKDoodleToolType)toolType {
    if (_strokeDefinition) {
        return _strokeDefinition.toolType;
    }
    
    return DKDoodleToolTypeNone;
}

- (CGPoint)initialPoint {
    if (_strokeDefinition) {
        return _strokeDefinition.initialPoint;
    }
    
    return CGPointMake(0.f, 0.f);
}


- (BOOL)isProcessingToolSession {
    return !!_strokeDefinition;
}

- (void)startStrokeWithDefinition:(DKDrawingStrokeDefinition *)strokeDefinition
{
    _strokeDefinition = strokeDefinition;
    _dataPoints = [NSMutableArray array];

}

- (void)addDKPointData:(NSObject<NSCoding> *)pointData {
    [_dataPoints addObject:pointData];
}

- (void)finishUsingTool {
    // add the data points
    _strokeDefinition.dataPoints = [NSArray arrayWithArray:_dataPoints];
    
    NSMutableData *strokeDef = [NSMutableData data];
    
    NSKeyedArchiver *coder = [[NSKeyedArchiver alloc] initForWritingWithMutableData:strokeDef];
    [_strokeDefinition encodeWithCoder:coder];
    [coder finishEncoding];

    _strokeDefinition = nil;
    _dataPoints = nil;
    
    GTMatchMessenger *messenger = [GTMatchMessenger sharedMessenger];
    [messenger sendDataToAllPlayers:strokeDef withFlag:DoodleFlag];
    [self didReceiveData:strokeDef fromPlayer:nil];
}

- (void)didReceiveData:(NSData *)data fromPlayer:(NSString *)playerID;
{
    NSKeyedUnarchiver *decodeer = [[NSKeyedUnarchiver alloc] initForReadingWithData:data];
    __block DKDrawingStrokeDefinition *strokeDefinition = [[DKDrawingStrokeDefinition alloc] initWithCoder:decodeer];

    // Send to delegate
    __weak DKSerializer *weakSelf = self;
    dispatch_async(dispatch_get_main_queue(), ^{
        //NSLog(@"Drawing Doodle Data with %@ touches", @([strokeDefinitionAgain.dataPoints count]));
        [weakSelf.delegate startDrawingDoodleStroke:strokeDefinition];
        for (NSObject *dataPoint in strokeDefinition.dataPoints) {
            [weakSelf.delegate drawDoodleStroke:strokeDefinition withDKPointData:dataPoint];
        }
        [weakSelf.delegate finishDrawingDoodleStroke:strokeDefinition];
    });

}

@end

