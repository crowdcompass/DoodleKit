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
    DKDoodleToolType _toolType;
    CGPoint _initialPoint;
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

- (DKDoodleToolType)toolType { return _toolType; }
- (CGPoint)initialPoint { return _initialPoint; }
- (NSArray *)dataPoints { return [NSArray arrayWithArray:_dataPoints]; }
- (BOOL)isProcessingToolSession {
    return _toolType != DKDoodleToolTypeNone;
}

- (void)startStrokeWithDefinition:(DKDrawingStrokeDefinition *)strokeDefinition
{
    _strokeDefinition = strokeDefinition;
    _initialPoint = _strokeDefinition.initialPoint;
    _toolType = _strokeDefinition.toolType;
    _dataPoints = [NSMutableArray array];

}

- (void)addDKPointData:(NSObject<NSCoding> *)pointData {
    [_dataPoints addObject:pointData];
}

- (void)finishUsingTool {
    // add the data points
    _strokeDefinition.dataPoints = _dataPoints;
    
    NSMutableData *strokeDef = [NSMutableData data];
    
    NSKeyedArchiver *coder = [[NSKeyedArchiver alloc] initForWritingWithMutableData:strokeDef];
    [_strokeDefinition encodeWithCoder:coder];
    [coder finishEncoding];
    GTMatchMessenger *messenger = [GTMatchMessenger sharedMessenger];
    [messenger sendDataToAllPlayers:strokeDef withFlag:DoodleFlag];
}

- (void)match:(GKMatch *)match didReceiveData:(NSData *)data fromPlayer:(NSString *)playerID;
{
    NSKeyedUnarchiver *decodeer = [[NSKeyedUnarchiver alloc] initForReadingWithData:data];
    __block DKDrawingStrokeDefinition *strokeDefinition = [[DKDrawingStrokeDefinition alloc] initWithCoder:decodeer];

    _toolType = DKDoodleToolTypeNone;
    _initialPoint = CGPointMake(0.f, 0.f);
    
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

