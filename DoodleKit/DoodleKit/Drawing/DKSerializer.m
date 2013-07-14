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
//    DKDrawingStrokeDefinition *strokeDefinition = [[DKDrawingStrokeDefinition alloc] init];
//    strokeDefinition.toolType = _toolType;
//    strokeDefinition.initialPoint = _initialPoint;
//    strokeDefinition.penColor = _penColor;
//    strokeDefinition.penWidth = _penWidth;
//    strokeDefinition.penWidth = _penAlpha;
//    strokeDefinition.dataPoints = [self dataPoints];
    
    _strokeDefinition.dataPoints = _dataPoints;
    
    NSMutableData *strokeDef = [NSMutableData data];
    
    NSKeyedArchiver *coder = [[NSKeyedArchiver alloc] initForWritingWithMutableData:strokeDef];
    [_strokeDefinition encodeWithCoder:coder];
    [coder finishEncoding];
    GTMatchMessenger *messenger = [GTMatchMessenger sharedMessenger];
    [messenger sendDoodleDataToAllPlayers:strokeDef];
}

- (void)didReceiveDoodleData:(NSData *)strokeDef
{
    NSKeyedUnarchiver *decodeer = [[NSKeyedUnarchiver alloc] initForReadingWithData:strokeDef];
    __block DKDrawingStrokeDefinition *strokeDefinitionAgain = [[DKDrawingStrokeDefinition alloc] initWithCoder:decodeer];
    
    _toolType = DKDoodleToolTypeNone;
    _initialPoint = CGPointMake(0.f, 0.f);
    
    // Send to delegate
    __weak DKSerializer *weakSelf = self;
    dispatch_async(dispatch_get_main_queue(), ^{
        //NSLog(@"Drawing Doodle Data with %@ touches", @([strokeDefinitionAgain.dataPoints count]));
        [weakSelf.delegate startDrawingDoodleStroke:strokeDefinitionAgain];
        for (NSObject *dataPoint in strokeDefinitionAgain.dataPoints) {
            [weakSelf.delegate drawDoodleStroke:strokeDefinitionAgain withDKPointData:dataPoint];
        }
        [weakSelf.delegate finishDrawingDoodleStroke:strokeDefinitionAgain];
    });

}

@end

