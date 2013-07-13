//
//  DKSerializer.h
//  DoodleKit
//
//  Created on 7/12/13.
//  Copyright (c) 2013 DaveVan. All rights reserved.
//

#import <Foundation/Foundation.h>

#warning Move these to another file
// Move these into a separate file
enum _DKDoodleToolType {
    DKDoodleToolTypeNone = 0,
    DKDoodleToolTypePen,
};
typedef NSUInteger DKDoodleToolType;

// DKDoodleToolType toolType = DKDoodleToolTypePen;
//
// NSValue *anObj = [NSValue value:&toolType withObjCType:@encode(DKDoodleToolType)];
//
// DKDoodleToolType bToolType;
// [anObj getValue:&bToolType];

struct DKPenPoint {
    CGPoint previousPreviousPoint;
    CGPoint previousPoint;
    CGPoint currentPoint;
};

typedef struct DKPenPoint DKPenPoint;

@interface DKDrawingStrokeDefinition : NSObject < NSCoding >

@property (nonatomic, assign) DKDoodleToolType toolType;
@property (nonatomic, assign) CGPoint initialPoint;
@property (nonatomic, retain) NSArray *dataPoints;

@end

@protocol DKSerializerDelegate <NSObject>

- (void)startDrawingWithTool:(DKDoodleToolType)toolType atPoint:(CGPoint)initialPoint;
- (void)drawDKPointData:(NSValue *)pointData;
- (void)finishDrawing;

@end

@interface DKSerializer : NSObject

@property (nonatomic, weak) id<DKSerializerDelegate> delegate;

@property (nonatomic, assign, readonly) DKDoodleToolType toolType;
@property (nonatomic, assign, readonly) CGPoint initialPoint;
@property (nonatomic, assign, readonly) NSArray *dataPoints;

- (void)startUsingTool:(DKDoodleToolType)toolType;
- (void)setInitialPoint:(CGPoint)point;
- (void)addDKPointData:(NSValue *)pointData;
- (void)finishUsingTool;

@end
