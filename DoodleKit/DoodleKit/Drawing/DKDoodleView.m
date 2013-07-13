//
//  DKDoodleView.m
//  DoodleKit
//
//  Created by Kerney, Benjamin on 7/12/13.
//  Copyright (c) 2013 DaveVan. All rights reserved.
//

#import "DKDoodleView.h"
#import "DKSerializer.h"
#import "DKDrawingTools.h"
#import "ACEDrawingTools.h"

#import <QuartzCore/QuartzCore.h>

#define kDefaultLineColor       [UIColor blackColor]
#define kDefaultLineWidth       10.0f;
#define kDefaultLineAlpha       1.0f

// experimental code
#define PARTIAL_REDRAW          0

@interface DKDoodleView ()<DKSerializerDelegate> {
    CGPoint currentPoint;
    CGPoint previousPoint1;
    CGPoint previousPoint2;
}

@property (nonatomic, assign) ACEDrawingPenTool *drawTool;

@property (nonatomic, strong) NSMutableArray *pathArray;
@property (nonatomic, strong) NSMutableArray *bufferArray;
@property (nonatomic, strong) id<ACEDrawingTool> currentTool;
@property (nonatomic, strong) UIImage *image;
@end

#pragma mark -

@implementation DKDoodleView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self configure];
    }
    return self;
}

- (id)initWithCoder:(NSCoder *)aDecoder
{
    self = [super initWithCoder:aDecoder];
    if (self) {
        [self configure];
    }
    return self;
}

- (void)configure
{
    _toolType = DKDoodleToolTypePen;
    
    // init the private arrays
    self.pathArray = [NSMutableArray array];
    self.bufferArray = [NSMutableArray array];
    
    // set the default values for the public properties
    self.lineColor = kDefaultLineColor;
    self.lineWidth = kDefaultLineWidth;
    self.lineAlpha = kDefaultLineAlpha;
    
    // set the transparent background
    self.backgroundColor = [UIColor clearColor];
    
    self.serializer = [[DKSerializer alloc] init];
    self.serializer.delegate = self;
    
    CADisplayLink *displayLink = [CADisplayLink displayLinkWithTarget:self selector:@selector(flushDrawing)];
    [displayLink addToRunLoop:[NSRunLoop mainRunLoop] forMode:NSDefaultRunLoopMode];

}


#pragma mark - Drawing

- (void)drawUsingToolType:(DKDoodleToolType)toolType withPoints:(NSArray *)points {
    if (toolType == DKDOodleToolTypeRectangle) {
        
        // make sure we have enough points
        if ([points count] < 2) {
            return;
        }
        
        // Serialize
        [self.serializer startUsingTool:_toolType];
        [self.serializer setInitialPoint:[(NSValue *)[points objectAtIndex:0] CGPointValue]];
        
        DKRectanglePoint *rectPoint = [DKRectanglePoint rectanglePointWithTopLeftPoint:[(NSValue *)[points objectAtIndex:0] CGPointValue] andBottomRightPoint:[(NSValue *)[points lastObject] CGPointValue]];
        [self.serializer addDKPointData:rectPoint];

        [self.serializer finishUsingTool]; 
    }
    else {
        NSLog(@"Implement this method for tool of type");
    }
}

- (void)drawRect:(CGRect)rect
{
#if PARTIAL_REDRAW
    // TODO: draw only the updated part of the image
    [self drawPath];
#else
    [self.image drawInRect:self.bounds];
    [self.currentTool draw];
#endif
}

- (void)flushDrawing
{
    if (_toolType == DKDoodleToolTypePen) {
        [self.serializer finishUsingTool];
        [self.serializer startUsingTool:_toolType];
    }
}

- (void)updateCacheImage:(BOOL)redraw
{
    // init a context
    UIGraphicsBeginImageContextWithOptions(self.bounds.size, NO, 0.0);
    
    if (redraw) {
        // erase the previous image
        self.image = nil;
        
        // I need to redraw all the lines
        for (id<ACEDrawingTool> tool in self.pathArray) {
            [tool draw];
        }
        
    } else {
        // set the draw point
        [self.image drawAtPoint:CGPointZero];
        [self.currentTool draw];
    }
    
    // store the image
    self.image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
}

- (id<ACEDrawingTool>)toolWithCurrentSettingsAndType:(DKDoodleToolType)toolType
{
    id<ACEDrawingTool> tool;
    
    switch (toolType) {
        case DKDoodleToolTypePen:
            tool = ACE_AUTORELEASE([ACEDrawingPenTool new]);
            break;
            
        case DKDOodleToolTypeRectangle:
            tool = ACE_AUTORELEASE([ACEDrawingRectangleTool new]);
            ((ACEDrawingRectangleTool *)tool).fill = YES;
            break;
            
        default:
            break;
    }
    return tool;
}


#pragma mark - Touch Methods

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    // add the first touch
    UITouch *touch = [touches anyObject];
    
    previousPoint1 = [touch previousLocationInView:self];
    currentPoint = [touch locationInView:self];
    
    // Serialize
    [self.serializer startUsingTool:_toolType];
    [self.serializer setInitialPoint:currentPoint];
}

- (void)touchesMoved:(NSSet *)touches withEvent:(UIEvent *)event
{
    // save all the touches in the path
    UITouch *touch = [touches anyObject];
    
    previousPoint2 = previousPoint1;
    previousPoint1 = [touch previousLocationInView:self];
    currentPoint = [touch locationInView:self];
    
    switch (_toolType) {
        case DKDoodleToolTypePen:
        {
            DKPenPoint *penPoint = [DKPenPoint penPointWithCurrentPoint:currentPoint
                                                          previousPoint:previousPoint1
                                                  previousPreviousPoint:previousPoint2];
            
            [self.serializer addDKPointData:penPoint];
        }
            break;
            
        case DKDOodleToolTypeRectangle:
        {
            DKRectanglePoint *rectPoint = [DKRectanglePoint rectanglePointWithTopLeftPoint:previousPoint1 andBottomRightPoint:currentPoint];
            [self.serializer addDKPointData:rectPoint];
        }

            
        default:
            break;
    }
    

}

- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event
{
    // make sure a point is recorded
    [self touchesMoved:touches withEvent:event];

    [self.serializer finishUsingTool];
}

- (void)touchesCancelled:(NSSet *)touches withEvent:(UIEvent *)event
{
    // make sure a point is recorded
    [self touchesEnded:touches withEvent:event];
}


#pragma mark - Actions

- (void)clear
{
    [self.bufferArray removeAllObjects];
    [self.pathArray removeAllObjects];
    [self updateCacheImage:YES];
    [self setNeedsDisplay];
}


#pragma mark - Undo / Redo

- (NSUInteger)undoSteps
{
    return self.bufferArray.count;
}

- (BOOL)canUndo
{
    return self.pathArray.count > 0;
}

- (void)undoLatestStep
{
    if ([self canUndo]) {
        id<ACEDrawingTool>tool = [self.pathArray lastObject];
        [self.bufferArray addObject:tool];
        [self.pathArray removeLastObject];
        [self updateCacheImage:YES];
        [self setNeedsDisplay];
    }
}

- (BOOL)canRedo
{
    return self.bufferArray.count > 0;
}

- (void)redoLatestStep
{
    if ([self canRedo]) {
        id<ACEDrawingTool>tool = [self.bufferArray lastObject];
        [self.pathArray addObject:tool];
        [self.bufferArray removeLastObject];
        [self updateCacheImage:YES];
        [self setNeedsDisplay];
    }
}

#if !ACE_HAS_ARC

- (void)dealloc
{
    self.pathArray = nil;
    self.bufferArray = nil;
    self.currentTool = nil;
    self.image = nil;
    [super dealloc];
}

#endif

#pragma mark - DKSerializerDelegate methods

- (void)startDrawingWithTool:(DKDoodleToolType)toolType atPoint:(CGPoint)initialPoint
{
    // init the bezier path
    self.currentTool = [self toolWithCurrentSettingsAndType:toolType];
    self.currentTool.lineWidth = self.lineWidth;
    self.currentTool.lineColor = self.lineColor;
    self.currentTool.lineAlpha = self.lineAlpha;
    [self.currentTool setInitialPoint:initialPoint];

}

- (void)drawDKPointData:(NSObject *)pointData
{
    if ([self.currentTool isKindOfClass:[ACEDrawingPenTool class]]) {
        DKPenPoint *penPoint = (DKPenPoint *)pointData;
        
        CGRect bounds = [(ACEDrawingPenTool*)self.currentTool addPathPreviousPreviousPoint:penPoint.previousPreviousPoint
                                                                         withPreviousPoint:penPoint.previousPoint
                                                                          withCurrentPoint:penPoint.currentPoint];
        
        CGRect drawBox = bounds;
        drawBox.origin.x -= self.lineWidth * 2.0;
        drawBox.origin.y -= self.lineWidth * 2.0;
        drawBox.size.width += self.lineWidth * 4.0;
        drawBox.size.height += self.lineWidth * 4.0;
        
        [self setNeedsDisplayInRect:drawBox];
    } else {
        DKRectanglePoint *rectPoint = (DKRectanglePoint *)pointData;
        [self.currentTool moveFromPoint:rectPoint.topLeftPoint toPoint:rectPoint.bottomRightPoint];
        [self setNeedsDisplay];
    }
}

- (void)finishDrawing
{
    // update the image
    [self updateCacheImage:NO];

    self.currentTool = nil;
}

@end
