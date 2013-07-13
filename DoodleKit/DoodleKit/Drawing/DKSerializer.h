//
//  DKSerializer.h
//  DoodleKit
//
//  Created by Kerney, Benjamin on 7/12/13.
//  Copyright (c) 2013 DaveVan. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreGraphics/CoreGraphics.h>

#import "DKDrawingTools.h"

@protocol DKSerializerDelegate <NSObject>

- (void)startDrawingWithTool:(DKDoodleToolType)toolType atPoint:(CGPoint)initialPoint;
- (void)drawDKPointData:(NSObject *)pointData;
- (void)finishDrawing;

@end

@interface DKSerializer : NSObject

@property (nonatomic, weak) id<DKSerializerDelegate> delegate;

@property (nonatomic, assign, readonly) DKDoodleToolType toolType;
@property (nonatomic, assign, readonly) CGPoint initialPoint;
@property (nonatomic, assign, readonly) NSArray *dataPoints;

- (void)startUsingTool:(DKDoodleToolType)toolType;
- (void)setInitialPoint:(CGPoint)point;
- (void)addDKPointData:(NSObject<NSCoding> *)pointData;
- (void)finishUsingTool;

@end
