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
}

@end

@implementation DKSerializer

- (DKDoodleToolType)toolType { return _toolType; }
- (CGPoint)initialPoint { return _initialPoint; }
- (NSArray *)dataPoints { return [NSArray arrayWithArray:_dataPoints]; }
- (BOOL)isProcessingToolSession {
    return _toolType != DKDoodleToolTypeNone;
}

- (void)startUsingTool:(DKDoodleToolType)toolType {
    _toolType = toolType;
    _dataPoints = [NSMutableArray array];
}

- (void)setInitialPoint:(CGPoint)point {
    _initialPoint = point;
}

- (void)addDKPointData:(NSObject<NSCoding> *)pointData {
    [_dataPoints addObject:pointData];
}

- (void)finishUsingTool {
    __block DKDrawingStrokeDefinition *strokeDefinition = [[DKDrawingStrokeDefinition alloc] init];
    strokeDefinition.toolType = _toolType;
    strokeDefinition.initialPoint = _initialPoint;
    strokeDefinition.dataPoints = [self dataPoints];
    
    _toolType = DKDoodleToolTypeNone;
    _initialPoint = CGPointMake(0.f, 0.f);

#warning Send the Data to GKGameKit
    
    // Send to delegate
    __weak DKSerializer *weakSelf = self;
    dispatch_async(dispatch_get_main_queue(), ^{
        [weakSelf.delegate startDrawingWithTool:strokeDefinition.toolType atPoint:strokeDefinition.initialPoint];
        for (NSObject *dataPoint in strokeDefinition.dataPoints) {
            [weakSelf.delegate drawDKPointData:dataPoint];
        }
        [weakSelf.delegate finishDrawing];
    });

}

@end

