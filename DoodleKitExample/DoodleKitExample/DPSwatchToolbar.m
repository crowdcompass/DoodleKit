//
//  DPSwatchToolbar.m
//  DoodleKitExample
//
//  Created by Dave Shanley on 7/12/13.
//  Copyright (c) 2013 Alexander Belliotti. All rights reserved.
//

#import "DPSwatchToolbar.h"
#import "NSTimer+BlocksKit.h"
#import "SSDrawingUtilities.h"
#import "NSArray+BlocksKit.h"

#define kToolbarDefaultHeight 44.0
#define kToolbarDefaultTopPadding 5.0
#define kToolbarEraserIndex 6

#define kGrowAnimationDuration 0.5
#define kShrinkAnimationDuration 0.1

@interface DPSwatchToolbar ()

@property (nonatomic, strong) UIButton *trash;
@property (nonatomic) NSUInteger selectedSwatchIndex;

- (void)setupToolbar;
- (void)animateSwatchesIn;
- (void)animateTimerAndTrashIn;
- (void)swatchSelected:(id)swatch;
- (void)didSelectEraser;
- (void)didTrash;

@end

@implementation DPSwatchToolbar

- (id)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        [self setupToolbar];
    }
    return self;
}

/**
 We use the width of the device with a fixed height
 */
- (CGSize)sizeThatFits:(CGSize)size {
    return CGSizeMake([[UIScreen mainScreen] bounds].size.width, kToolbarDefaultHeight);
}

/**
 Add the progress view, the swatches, and the trash
 */
- (void)setupToolbar {
    [self sizeToFit];
    
    float toolbarWidth = CGRectGetWidth(self.bounds);
    
    self.backgroundColor = [UIColor whiteColor];
    
    _progressView = [[DPPieTimer alloc] init];
    CGRect progressRect = CGRectMake(12.0, kToolbarDefaultTopPadding, 33.0, 33.0);
    _progressView.frame = progressRect;
    _progressView.delegate = self;
    
    _trash = [UIButton buttonWithType:UIButtonTypeCustom];
    [_trash setImage:[UIImage imageNamed:@"trash"] forState:UIControlStateNormal];
    [_trash sizeToFit];
    _trash.frame = CGRectMake(toolbarWidth - _trash.bounds.size.width - 12.0, kToolbarDefaultTopPadding,
                              CGRectGetWidth(_trash.bounds), CGRectGetHeight(_trash.bounds));
    [_trash addTarget:self action:@selector(didTrash) forControlEvents:UIControlEventTouchUpInside];
    
    DPSwatch *swatch1 = [[DPSwatch alloc] initWithColor:[UIColor colorWithRed:68.0/255.0 green:68.0/255.0 blue:68.0/255.0 alpha:1.0]];
    swatch1.selected = YES;
    _selectedSwatchIndex = 0;
    [swatch1 addTarget:self action:@selector(swatchSelected:) forControlEvents:UIControlEventTouchUpInside];
    DPSwatch *swatch2 = [[DPSwatch alloc] initWithColor:[UIColor colorWithRed:122.0/255.0 green:171.0/255.0 blue:219.0/255.0 alpha:1.0]];
    [swatch2 addTarget:self action:@selector(swatchSelected:) forControlEvents:UIControlEventTouchUpInside];
    DPSwatch *swatch3 = [[DPSwatch alloc] initWithColor:[UIColor colorWithRed:108.0/255.0 green:195.0/255.0 blue:155.0/255.0 alpha:1.0]];
    [swatch3 addTarget:self action:@selector(swatchSelected:) forControlEvents:UIControlEventTouchUpInside];
    DPSwatch *swatch4 = [[DPSwatch alloc] initWithColor:[UIColor colorWithRed:250.0/255.0 green:176.0/255.0 blue:60.0/255.0 alpha:1.0]];
    [swatch4 addTarget:self action:@selector(swatchSelected:) forControlEvents:UIControlEventTouchUpInside];
    DPSwatch *swatch5 = [[DPSwatch alloc] initWithColor:[UIColor colorWithRed:242.0/255.0 green:114.0/255.0 blue:98.0/255.0 alpha:1.0]];
    [swatch5 addTarget:self action:@selector(swatchSelected:) forControlEvents:UIControlEventTouchUpInside];
    DPSwatch *swatch6 = [[DPSwatch alloc] initWithColor:[UIColor colorWithRed:162.0/255.0 green:141.0/255.0 blue:193.0/255.0 alpha:1.0]];
    [swatch6 addTarget:self action:@selector(swatchSelected:) forControlEvents:UIControlEventTouchUpInside];
    //and our eraser
    DPSwatch *swatch7 = [[DPSwatch alloc] initWithColor:[UIColor colorWithRed:255.0/255.0 green:255.0/255.0 blue:255.0/255.0 alpha:1.0]
                                         andBorderColor:[UIColor colorWithRed:221.0/255.0 green:221.0/255.0 blue:221.0/255.0 alpha:1.0]];
    swatch7.selectedColor = [UIColor colorWithRed:221.0/255.0 green:221.0/255.0 blue:221.0/255.0 alpha:1.0];
    [swatch7 addTarget:self action:@selector(swatchSelected:) forControlEvents:UIControlEventTouchUpInside];
    
    _swatches = [NSArray arrayWithObjects:swatch1, swatch2, swatch3, swatch4, swatch5, swatch6, swatch7, nil];
    
    //determine overall size of swatches, so we can center
    float dx = roundf((toolbarWidth - (CGRectGetWidth(swatch1.bounds) * 7 + (6.0 * 13.0))) / 2.0);
    
    for (DPSwatch *swatch in _swatches) {
        swatch.frame = CGRectMake(dx, kToolbarDefaultTopPadding, CGRectGetWidth(swatch.bounds), CGRectGetHeight(swatch.bounds));
        [self addSubview:swatch];
        dx += (CGRectGetWidth(swatch.bounds) + 13.0);
    }
    
    [self addSubview:_progressView];
    [self addSubview:_trash];
    [self addSubview:swatch1];
}

- (void)animateSwatchesIn {
    //broadcast change
    [_swatches apply:^(id swatch) {
        ((DPSwatch *)swatch).transform = CGAffineTransformMakeScale(0.01, 0.01);
    }];
    //loop change
    __block float delay = 0.01;
    [_swatches each:^(id swatch) {
        DPSwatch *theSwatch = ((DPSwatch *)swatch);
        [UIView animateWithDuration:kGrowAnimationDuration delay:delay options:UIViewAnimationOptionCurveEaseOut animations:^{
            theSwatch.transform = CGAffineTransformMakeScale(1.1, 1.1);
            delay += 0.03;
        } completion:^(BOOL finished) {
            [UIView animateWithDuration:kShrinkAnimationDuration delay:0.0 options:UIViewAnimationOptionCurveEaseIn animations:^{
                theSwatch.transform = CGAffineTransformMakeScale(1.0, 1.0);
            } completion:^(BOOL finished) {
                
            }];
        }];
    }];
}

- (void)animateTimerAndTrashIn {
    //ready
    _progressView.transform = CGAffineTransformMakeScale(0.01, 0.01);
    _trash.transform = CGAffineTransformMakeScale(0.01, 0.01);
    
    //go
    [UIView animateWithDuration:kGrowAnimationDuration delay:0.0 options:UIViewAnimationOptionCurveEaseOut animations:^{
        _progressView.transform = CGAffineTransformMakeScale(1.1, 1.1);
        _trash.transform = CGAffineTransformMakeScale(1.1, 1.1);
    } completion:^(BOOL finished) {
        [UIView animateWithDuration:kShrinkAnimationDuration delay:0.0 options:UIViewAnimationOptionCurveEaseIn animations:^{
            _progressView.transform = CGAffineTransformMakeScale(1.0, 1.0);
            _trash.transform = CGAffineTransformMakeScale(1.0, 1.0);
        } completion:^(BOOL finished) {
            
        }];
    }];
}

/**
 The toolbar animates in by moving down 100% of it's height
 */
- (void)showToolbar {
    [UIView animateWithDuration:0.8 delay:0.0 options:UIViewAnimationOptionCurveEaseIn animations:^{
        self.transform = CGAffineTransformMakeTranslation(0.0, CGRectGetHeight(self.bounds));
        [self animateTimerAndTrashIn];
        [self animateSwatchesIn];
    } completion:^(BOOL finished) {
        
    }];
}


- (void)startCountdown {
    [_progressView start];
}

//////////////////////////////////////////////////////////////////////
#pragma mark -
#pragma mark PieTimerDelegate

- (void)pieTimerDidExpire {
    if (_delegate && [_delegate respondsToSelector:@selector(toolbarCountdownDidFinish)]) {
        [_delegate toolbarCountdownDidFinish];
    }
}


//////////////////////////////////////////////////////////////////////
#pragma mark -
#pragma mark Swatches

- (void)swatchSelected:(id)swatch {
    NSUInteger newIndex = [_swatches indexOfObject:swatch];
    NSLog(@"Swatch selected %d %@ from %d", newIndex, swatch, _selectedSwatchIndex);
    if (newIndex == _selectedSwatchIndex) return;

    DPSwatch *oldSwatch = [_swatches objectAtIndex:_selectedSwatchIndex];
    oldSwatch.selected = NO;
    DPSwatch *newSwatch = [_swatches objectAtIndex:newIndex];
    newSwatch.selected = YES;
    _selectedSwatchIndex = newIndex;
    
    if (_selectedSwatchIndex == kToolbarEraserIndex) {
        if (_delegate && [_delegate respondsToSelector:@selector(doodlerDidSelectEraser)]) {
            [_delegate doodlerDidSelectEraser];
        }
    } else {
        if (_delegate && [_delegate respondsToSelector:@selector(doodlerDidChangeToSwatch:)]) {
            [_delegate doodlerDidChangeToSwatch:newSwatch];
        }
    }
    
}




//////////////////////////////////////////////////////////////////////
#pragma mark -
#pragma mark Trash

- (void)didTrash {
    NSLog(@"trashed");
    if (_delegate && [_delegate respondsToSelector:@selector(doodlerDidSelectTrash)]) {
        [_delegate doodlerDidSelectTrash];
    }
}






@end
