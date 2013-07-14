//
//  DKSerializer.h
//  DoodleKit
//
//  Created by Kerney, Benjamin on 7/12/13.
//  Copyright (c) 2013 DaveVan. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreGraphics/CoreGraphics.h>

#import "GTMatchMessenger.h"
#import "DKDrawingTools.h"

@class GTMatchMessenger;

@protocol DKSerializerDelegate <NSObject>

- (void)startDrawingDoodleStroke:(DKDrawingStrokeDefinition *)strokeDefinition;
- (void)drawDoodleStroke:(DKDrawingStrokeDefinition *)strokeDefinition withDKPointData:(NSObject *)pointData;
- (void)finishDrawingDoodleStroke:(DKDrawingStrokeDefinition *)strokeDefinition;

@end

@interface DKSerializer : NSObject

@property (nonatomic, weak) id<DKSerializerDelegate> delegate;

@property (nonatomic, assign, readonly) DKDoodleToolType toolType;
@property (nonatomic, assign, readonly) CGPoint initialPoint;
@property (nonatomic, assign, readonly) UIColor *penColor;
@property (nonatomic, assign, readonly) CGFloat penWidth;
@property (nonatomic, assign, readonly) CGFloat penAlpha;
@property (nonatomic, assign, readonly) NSArray *dataPoints;

//- (void)startUsingTool:(DKDoodleToolType)toolType;
//- (void)setInitialPoint:(CGPoint)point;
- (void)startStrokeWithDefinition:(DKDrawingStrokeDefinition *)strokeDefinition;
- (void)addDKPointData:(NSObject<NSCoding> *)pointData;
- (void)finishUsingTool;
- (BOOL)isProcessingToolSession;

- (void)didReceiveDoodleData:(NSData *)strokeDef;


@end
