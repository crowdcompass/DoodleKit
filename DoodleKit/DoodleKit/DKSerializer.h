//
//  DKSerializer.h
//  DoodleKit
//
//  Created by Kerney, Benjamin on 7/12/13.
//  Copyright (c) 2013 DaveVan. All rights reserved.
//

#import <Foundation/Foundation.h>

#warning Move these to another file
// Move these into a separate file
enum _DKDoodleToolType {
    DKDoodleToolTypeNone = 0,
    DKDoodleToolTypePen = 0,
};
typedef NSUInteger DKDoodleToolType;

//NSValue *anObj = [NSValue value:&struct withObjCType:@encode(aStruct)];
struct DKPenPoint {
    CGPoint previousPreviousPoint;
    CGPoint previousPoint;
    CGPoint currentPoint;
};

@interface DKSerializer : NSObject

@property (nonatomic, assign, readonly) DKDoodleToolType toolType;
@property (nonatomic, assign, readonly) CGPoint initialPoint;
@property (nonatomic, assign, readonly) NSArray *dataPoints;

- (void)startUsingTool:(DKDoodleToolType)toolType;
- (void)setInitialPoint:(CGPoint)point;
- (void)addDKPointData:(NSValue *)pointData;
- (void)finishUsingTool;

@end
