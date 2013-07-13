//
//  DPSwatch.m
//  DoodleKitExample
//
//  Created by Dave Shanley on 7/12/13.
//  Copyright (c) 2013 Alexander Belliotti. All rights reserved.
//

#import "DPSwatch.h"

#define kDefaultSwatchSize 37.0
#define kSwatchPadding 4.0
#define kSwatchSelectedSize 9.0

@implementation DPSwatch

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        //
    }
    return self;
}

- (id)initWithColor:(UIColor *)swatchColor {
    return [self initWithColor:swatchColor andBorderColor:swatchColor];
}

- (id)initWithColor:(UIColor *)swatchColor andBorderColor:(UIColor *)borderColor {
    return [self initWithColor:swatchColor borderColor:borderColor andSelectedColor:[UIColor whiteColor]];
}

- (id)initWithColor:(UIColor *)swatchColor borderColor:(UIColor *)borderColor andSelectedColor:(UIColor *)selectedColor {
    self = [self initWithFrame:CGRectMake(0.0, 0.0, kDefaultSwatchSize, kDefaultSwatchSize)];
    if (self) {
        _swatchColor = swatchColor;
        _borderColor = borderColor;
        _selectedColor = selectedColor;
    }
    return self;
}


- (void)drawRect:(CGRect)rect {
    [super drawRect:rect];
    
    CGRect renderRect = CGRectInset(rect, kSwatchPadding, kSwatchPadding);
    CGContextRef context = UIGraphicsGetCurrentContext();
    [_swatchColor set];
    CGContextFillEllipseInRect(context, renderRect);
    if (_borderColor) {
        [_borderColor set];
        CGContextStrokeEllipseInRect(context, renderRect);
    }
    
    if (self.selected) {
        [_selectedColor set];
        CGPoint center = CGPointMake(CGRectGetMidX(rect), CGRectGetMidY(rect));
        
        CGRect selectedRect = CGRectMake(roundf(center.x - kSwatchSelectedSize/2.0),
                                         roundf(center.y - kSwatchSelectedSize/2.0),
                                         kSwatchSelectedSize, kSwatchSelectedSize);
        CGContextFillEllipseInRect(context, selectedRect);
    }
}


@end
