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

- (void)startDrawingDoodleData:(NSString *)dataUid withTool:(DKDoodleToolType)toolType atPoint:(CGPoint)initialPoint;
- (void)drawDoodleData:(NSString *)dataUid withDKPointData:(NSObject *)pointData;
- (void)finishDrawingDoodleData:(NSString *)dataUid;

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
- (BOOL)isProcessingToolSession;

- (void)didReceiveDoodleData:(NSData *)strokeDef;


@end
