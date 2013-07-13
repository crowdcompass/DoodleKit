//
//  DKSerializer.m
//  DoodleKit
//
//  Created on 7/12/13.
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
        for (NSValue *dataPoint in strokeDefinition.dataPoints) {
            [weakSelf.delegate drawDKPointData:dataPoint];
        }
        [weakSelf.delegate finishDrawing];
    });

}

@end

@implementation DKDrawingStrokeDefinition

- (id)initWithCoder:(NSCoder *)aDecoder {
    
    self = [super init];
    if (self) {
        _toolType = [aDecoder decodeIntegerForKey:@"toolType"];
        _initialPoint = [aDecoder decodeCGPointForKey:@"initialPoint"];
        _dataPoints = [aDecoder decodeObjectForKey:@"dataPoints"];
    }
    
    return self;
}

- (void)encodeWithCoder:(NSCoder *)aCoder {
    
    [aCoder encodeInteger:_toolType forKey:@"toolType"];
    [aCoder encodeCGPoint:_initialPoint forKey:@"initialPoint"];
    [aCoder encodeObject:_dataPoints forKey:@"dataPoints"];
}

@end