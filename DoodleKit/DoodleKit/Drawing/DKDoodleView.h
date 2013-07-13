//
//  DKDoodleView.h
//  DoodleKit
//
//  Created by Kerney, Benjamin on 7/12/13.
//  Copyright (c) 2013 DaveVan. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "DKSerializer.h"

@protocol DKDoodleViewDelegate;

@interface DKDoodleView : UIView

@property (nonatomic, weak) id<DKDoodleViewDelegate> delegate;
@property (nonatomic, strong) DKSerializer *serializer;

// public properties
@property (nonatomic, assign) DKDoodleToolType toolType;
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
- (void)drawingView:(DKDoodleView *)view willBeginDrawUsingToolType:(DKDoodleToolType)toolType;
- (void)drawingView:(DKDoodleView *)view didEndDrawUsingToolType:(DKDoodleToolType)toolType;

@end
