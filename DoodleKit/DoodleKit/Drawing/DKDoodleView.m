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
#define kDefaultLineWidth       10.0f
#define kDefaultLineAlpha       1.0f

#define kDefaultFrameSpliceRate 1

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
@property (nonatomic, strong) UIImage *image;

@property (nonatomic, strong) NSMutableDictionary *currentTools;
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
    self.currentTools = [NSMutableDictionary dictionary];
    
    // set the default values for the public properties
    self.lineColor = kDefaultLineColor;
    self.lineWidth = kDefaultLineWidth;
    self.lineAlpha = kDefaultLineAlpha;
    
    // set the transparent background
    self.backgroundColor = [UIColor clearColor];
    
    self.serializer = [[DKSerializer alloc] init];
    self.serializer.delegate = self;
    
    CADisplayLink *displayLink = [CADisplayLink displayLinkWithTarget:self selector:@selector(flushDrawing)];
    [displayLink setFrameInterval:kDefaultFrameSpliceRate];
    
    [displayLink addToRunLoop:[NSRunLoop mainRunLoop] forMode:NSDefaultRunLoopMode];
    

}


#pragma mark - Drawing

- (void)drawUsingToolType:(DKDoodleToolType)toolType withPoints:(NSArray *)points {
    if (toolType == DKDoodleToolTypeRectangle) {
        
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
    //[self.image drawInRect:self.bounds];
    
    //for (id<ACEDrawingTool> currentTool in [self.currentTools allValues]) {
    //    [currentTool draw];
    //}
    
    NSLog(@"start of drawRect");
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextClearRect(context, rect);
    UIImage *image = self.image;
    CGRect imageRect = CGRectMake(0, 0, image.size.width, image.size.height);
    
    CGContextTranslateCTM(context, 0, image.size.height);
    CGContextScaleCTM(context, 1.0, -1.0);
    
    CGContextDrawImage(context, imageRect, image.CGImage);
    NSLog(@"end of drawRect");
    
#endif
}

- (void)flushDrawing
{
    if ([self.serializer isProcessingToolSession] && self.serializer.toolType == DKDoodleToolTypePen) {
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
        
        for (id<ACEDrawingTool> currentTool in [self.currentTools allValues]) {
            [currentTool draw];
        }
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
            
        case DKDoodleToolTypeRectangle:
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
            
        case DKDoodleToolTypeRectangle:
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

- (void)startDrawingDoodleData:(NSString *)dataUid withTool:(DKDoodleToolType)toolType atPoint:(CGPoint)initialPoint {
    // init the bezier path

    id<ACEDrawingTool> currentTool = [self toolWithCurrentSettingsAndType:toolType];
    currentTool.lineWidth = self.lineWidth;
    currentTool.lineColor = self.lineColor;
    currentTool.lineAlpha = self.lineAlpha;
    [currentTool setInitialPoint:initialPoint];
    
    [_currentTools setObject:currentTool forKey:dataUid];
}

- (void)drawDoodleData:(NSString *)dataUid withDKPointData:(NSObject *)pointData {
    id<ACEDrawingTool> currentTool =  [_currentTools objectForKey:dataUid];
    
    if (!currentTool) {
        NSLog(@"Houston, we have a problem");
        return;
    }

    if ([currentTool isKindOfClass:[ACEDrawingPenTool class]]) {
        DKPenPoint *penPoint = (DKPenPoint *)pointData;
        
        CGRect bounds = [(ACEDrawingPenTool*)currentTool addPathPreviousPreviousPoint:penPoint.previousPreviousPoint
                                                                         withPreviousPoint:penPoint.previousPoint
                                                                          withCurrentPoint:penPoint.currentPoint];
        
        CGRect drawBox = bounds;
        drawBox.origin.x -= self.lineWidth * 2.0;
        drawBox.origin.y -= self.lineWidth * 2.0;
        drawBox.size.width += self.lineWidth * 4.0;
        drawBox.size.height += self.lineWidth * 4.0;
        
        UIGraphicsBeginImageContextWithOptions(drawBox.size, NO, 0.0);
        //UIGraphicsBeginImageContextWithOptions(self.bounds.size, NO, 0.0);
        CGContextRef context = UIGraphicsGetCurrentContext();
        
        //CGContextClearRect(context, drawBox);
        
        // override in subclass
        [(ACEDrawingPenTool *)currentTool drawInContext:context];
        //[self drawWithContext:context withWidth:self.frame.size.width withHeight:self.frame.size.height];
        
        // Returns an image based on the contents of the current bitmap-based graphics context
        //UIImage *theImage = UIGraphicsGetImageFromCurrentImageContext();
        //self.image = theImage;
        UIGraphicsEndImageContext();
        
        dispatch_async(dispatch_get_main_queue(), ^{
            [self setNeedsDisplayInRect:drawBox];
            //[self setNeedsDisplayInRect:self.bounds];
        });

    } else {
        DKRectanglePoint *rectPoint = (DKRectanglePoint *)pointData;
        [currentTool moveFromPoint:rectPoint.topLeftPoint toPoint:rectPoint.bottomRightPoint];
        [self setNeedsDisplay];
    }
}

- (void)finishDrawingDoodleData:(NSString *)dataUid {
    if (![_currentTools objectForKey:dataUid]) {
        NSLog(@"Houston, we have a problem");
        return;
    }
    
    // update the image
    [self updateCacheImage:NO];

    [_currentTools removeObjectForKey:dataUid];
}

@end
