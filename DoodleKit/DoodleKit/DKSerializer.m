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
}

- (void)setInitialPoint:(CGPoint)point {
    
}
- (void)addDKPointData:(NSValue *)pointData;
- (void)finishUsingTool;

@end
