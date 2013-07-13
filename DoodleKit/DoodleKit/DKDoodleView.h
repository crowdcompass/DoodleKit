//
//  DKDoodleView.h
//  DoodleKit
//
//  Created on 7/12/13.
//  Copyright (c) 2013 DaveVan. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ACEDrawingTools.h"
#import "DKSerializer.h"

@protocol DKDoodleViewDelegate, ACEDrawingTool;

@interface DKDoodleView : UIView

@property (nonatomic, assign) ACEDrawingPenTool *drawTool;
@property (nonatomic, assign) id<DKDoodleViewDelegate> delegate;
@property (nonatomic, strong) DKSerializer *serializer;

// public properties
@property (nonatomic, strong) UIColor *lineColor;
@property (nonatomic, assign) CGFloat lineWidth;
@property (nonatomic, assign) CGFloat lineAlpha;


// get the current drawing
@property (nonatomic, strong, readonly) UIImage *image;
@property (nonatomic, readonly) NSUInteger undoSteps;


// erase all
- (void)clear;

// undo / redo
- (BOOL)canUndo;
- (void)undoLatestStep;

- (BOOL)canRedo;
- (void)redoLatestStep;

@end

#pragma mark -

@protocol DKDoodleViewDelegate <NSObject>

@optional
- (void)drawingView:(DKDoodleView *)view willBeginDrawUsingTool:(id<ACEDrawingTool>)tool;
- (void)drawingView:(DKDoodleView *)view didEndDrawUsingTool:(id<ACEDrawingTool>)tool;

@end
