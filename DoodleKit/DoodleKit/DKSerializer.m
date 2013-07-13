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
    
    __weak DKSerializer *weakSelf = self;
    
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_HIGH, NULL), ^{
        [weakSelf.delegate startDrawingWithTool:_toolType atPoint:_initialPoint];
        
    });
}

@end
