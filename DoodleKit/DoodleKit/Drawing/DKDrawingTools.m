//
//  DKDrawingTools.m
//  DoodleKit
//
//  Created by Ryan Crosby on 7/13/13.
//  Copyright (c) 2013 DaveVan. All rights reserved.
//

#import "DKDrawingTools.h"
#import <UIKit/UIKit.h>

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

@implementation DKPenPoint

+ (DKPenPoint *)penPointWithCurrentPoint:(CGPoint)currentPoint previousPoint:(CGPoint)point1 previousPreviousPoint:(CGPoint)point2 {
    DKPenPoint *newPenPoint = [[DKPenPoint alloc] init];
    newPenPoint.currentPoint = currentPoint;
    newPenPoint.previousPoint = point1;
    newPenPoint.previousPreviousPoint = point2;
    
    return newPenPoint;
}

- (id)initWithCoder:(NSCoder *)aDecoder {
    
    self = [super init];
    if (self) {
        _currentPoint = [aDecoder decodeCGPointForKey:@"initialPoint"];
        _previousPoint = [aDecoder decodeCGPointForKey:@"previousPoint"];
        _previousPreviousPoint = [aDecoder decodeCGPointForKey:@"previousPreviousPoint"];
    }
    
    return self;
}

- (void)encodeWithCoder:(NSCoder *)aCoder {
    
    [aCoder encodeCGPoint:_currentPoint forKey:@"initialPoint"];
    [aCoder encodeCGPoint:_previousPoint forKey:@"previousPoint"];
    [aCoder encodeCGPoint:_previousPreviousPoint forKey:@"previousPreviousPoint"];
}

@end