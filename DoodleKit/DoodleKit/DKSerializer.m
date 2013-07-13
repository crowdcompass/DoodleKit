//
//  DKSerializer.m
//  DoodleKit
//
//  Created by Kerney, Benjamin on 7/12/13.
//  Copyright (c) 2013 DaveVan. All rights reserved.
//

#import "DKSerializer.h"

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

- (void)startUsingTool:(DKDoodleToolType)toolType {
    _toolType = toolType;
    _dataPoints = [NSMutableArray array];
}

- (void)setInitialPoint:(CGPoint)point {
    _initialPoint = point;
}

- (void)addDKPointData:(NSValue *)pointData {
    [_dataPoints addObject:pointData];
}

- (void)finishUsingTool {
    _toolType = DKDoodleToolTypeNone;
    _initialPoint = CGPointMake(0.f, 0.f);

    [self.delegate startDrawingWithTool:_toolType atPoint:_initialPoint];
    for (NSValue *dataPoint in _dataPoints) {
        [self.delegate drawDKPointData:dataPoint];
    }
    [self.delegate finishDrawing];
}

@end
