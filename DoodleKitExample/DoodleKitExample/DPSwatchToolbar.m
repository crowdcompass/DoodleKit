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
@property (nonatomic, strong) UIButton *fifteenButton;
@property (nonatomic, strong) UIButton *thirtyButton;
@property (nonatomic, strong) UIButton *fortyFiveButton;

- (void)setupToolbar;
- (void)addSwatches;
- (void)addTimerAndTrash;
- (void)addDurationButtons;

- (void)animateDurationButtonsIn;
- (void)animateDurationButtonsOut;
- (void)animateSwatchesIn;
- (void)animateTimerAndTrashIn;
- (void)swatchSelected:(id)swatch;
- (void)didChangeDuration:(id)button;
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
    self.backgroundColor = [UIColor whiteColor];

    [self addDurationButtons];
    [self addSwatches];
    [self addTimerAndTrash];
}

- (void)addDurationButtons {
    self.fifteenButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [_fifteenButton setImage:[UIImage imageNamed:@"btn_15"] forState:UIControlStateNormal];
    [_fifteenButton setImage:[UIImage imageNamed:@"btn_15_press"] forState:UIControlStateHighlighted];
    [_fifteenButton sizeToFit];
    
    self.thirtyButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [_thirtyButton setImage:[UIImage imageNamed:@"btn_30"] forState:UIControlStateNormal];
    [_thirtyButton setImage:[UIImage imageNamed:@"btn_30_press"] forState:UIControlStateHighlighted];
    [_thirtyButton sizeToFit];
    
    self.fortyFiveButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [_fortyFiveButton setImage:[UIImage imageNamed:@"btn_45"] forState:UIControlStateNormal];
    [_fortyFiveButton setImage:[UIImage imageNamed:@"btn_45_press"] forState:UIControlStateHighlighted];
    [_fortyFiveButton sizeToFit];
    
    [_fifteenButton addTarget:self action:@selector(didChangeDuration:) forControlEvents:UIControlEventTouchUpInside];
    [_thirtyButton addTarget:self action:@selector(didChangeDuration:) forControlEvents:UIControlEventTouchUpInside];
    [_fortyFiveButton addTarget:self action:@selector(didChangeDuration:) forControlEvents:UIControlEventTouchUpInside];
    
    _fifteenButton.hidden = YES;
    _thirtyButton.hidden = YES;
    _fortyFiveButton.hidden = YES;
    
    
    //determine overall size of swatches, so we can center
    float toolbarWidth = CGRectGetWidth(self.bounds);
    float dx = roundf((toolbarWidth - (CGRectGetWidth(_fifteenButton.bounds) * 3 + (2.0 * 13.0))) / 2.0);
    _fifteenButton.frame = CGRectMake(dx, kToolbarDefaultTopPadding,
                                      CGRectGetWidth(_fifteenButton.bounds), CGRectGetHeight(_fifteenButton.bounds));
    dx += (CGRectGetWidth(_fifteenButton.bounds) + 13.0);
    _thirtyButton.frame = CGRectMake(dx, kToolbarDefaultTopPadding,
                                     CGRectGetWidth(_thirtyButton.bounds), CGRectGetHeight(_thirtyButton.bounds));
    dx += (CGRectGetWidth(_fifteenButton.bounds) + 13.0);
    _fortyFiveButton.frame = CGRectMake(dx, kToolbarDefaultTopPadding,
                                        CGRectGetWidth(_fortyFiveButton.bounds), CGRectGetHeight(_fortyFiveButton.bounds));

    
    
    [self addSubview:_fifteenButton];
    [self addSubview:_thirtyButton];
    [self addSubview:_fortyFiveButton];
    
}

- (void)addSwatches {
    float toolbarWidth = CGRectGetWidth(self.bounds);
    
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
        swatch.hidden = YES;
        [self addSubview:swatch];
        dx += (CGRectGetWidth(swatch.bounds) + 13.0);
    }
}

//////////////////////////////////////////////////////////////////////
#pragma mark -
#pragma mark Present / Animate Views

- (void)animateDurationButtonsIn {
    //ready
    _fifteenButton.transform = CGAffineTransformMakeScale(0.01, 0.01);
    _thirtyButton.transform = CGAffineTransformMakeScale(0.01, 0.01);
    _fortyFiveButton.transform = CGAffineTransformMakeScale(0.01, 0.01);
    
    //go
    [UIView animateWithDuration:kGrowAnimationDuration delay:0.0 options:UIViewAnimationOptionCurveEaseOut animations:^{
        _fifteenButton.transform = CGAffineTransformMakeScale(1.1, 1.1);
        _fifteenButton.hidden = NO;
        _thirtyButton.transform = CGAffineTransformMakeScale(1.1, 1.1);
        _thirtyButton.hidden = NO;
        _fortyFiveButton.transform = CGAffineTransformMakeScale(1.1, 1.1);
        _fortyFiveButton.hidden = NO;
    } completion:^(BOOL finished) {
        [UIView animateWithDuration:kShrinkAnimationDuration delay:0.0 options:UIViewAnimationOptionCurveEaseIn animations:^{
            _fifteenButton.transform = CGAffineTransformIdentity;
            _thirtyButton.transform = CGAffineTransformIdentity;
            _fortyFiveButton.transform = CGAffineTransformIdentity;
        } completion:^(BOOL finished) {
            
        }];
    }];
}

- (void)animateDurationButtonsOut {
    [UIView animateWithDuration:kShrinkAnimationDuration animations:^{
        _fifteenButton.alpha = 0.0;
        _thirtyButton.alpha = 0.0;
        _fortyFiveButton.alpha = 0.0;
    } completion:^(BOOL finished) {
        [_fifteenButton removeFromSuperview];
        [_thirtyButton removeFromSuperview];
        [_fortyFiveButton removeFromSuperview];
        self.fifteenButton = nil;
        self.thirtyButton = nil;
        self.fortyFiveButton = nil;
        // and now animate the rest in
        [self animateSwatchesIn];
        [self animateTimerAndTrashIn];
    }];
}

- (void)addTimerAndTrash {
    float toolbarWidth = CGRectGetWidth(self.bounds);
    
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
    
    //hide for now
    _progressView.hidden = YES;
    _trash.hidden = YES;
    
    [self addSubview:_progressView];
    [_progressView reset];
    [self addSubview:_trash];

}

- (void)animateSwatchesIn {
    //broadcast change
    [_swatches apply:^(id swatch) {
        ((DPSwatch *)swatch).transform = CGAffineTransformMakeScale(0.01, 0.01);
        ((DPSwatch *)swatch).hidden = NO;
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
    _progressView.transform = CGAffineTransformMakeScale(0.7, 0.7);
    _progressView.alpha = 0.0;
    _trash.transform = CGAffineTransformMakeScale(0.01, 0.01);
    
    //go
    [UIView animateWithDuration:kGrowAnimationDuration delay:0.0 options:UIViewAnimationOptionCurveEaseOut animations:^{
        _progressView.alpha = 1.0;
        _progressView.hidden = NO;
        _trash.transform = CGAffineTransformMakeScale(1.1, 1.1);
        _trash.hidden = NO;
    } completion:^(BOOL finished) {
        [UIView animateWithDuration:kShrinkAnimationDuration delay:0.0 options:UIViewAnimationOptionCurveEaseIn animations:^{
            [_progressView reset];
            _trash.transform = CGAffineTransformIdentity;
        } completion:^(BOOL finished) {
            [self startCountdown];
        }];
    }];
}

/**
 The toolbar animates in by moving down 100% of it's height
 */
- (void)showToolbar {
    [UIView animateWithDuration:0.4 delay:0.0 options:UIViewAnimationOptionCurveEaseIn animations:^{
        self.transform = CGAffineTransformMakeTranslation(0.0, CGRectGetHeight(self.bounds));
        [self animateDurationButtonsIn];
//        [self animateTimerAndTrashIn];
//        [self animateSwatchesIn];
    } completion:^(BOOL finished) {
        
    }];
}


- (void)startCountdown {
    [_progressView start];
}

//////////////////////////////////////////////////////////////////////
#pragma mark -
#pragma mark Button Actions

- (void)didChangeDuration:(id)button {
    float duration = 0.f;
    if ([button isEqual:_fifteenButton]) {
        NSLog(@"duration changed to 15");
        duration = 15.0;
    } else if ([button isEqual:_thirtyButton]) {
        NSLog(@"duration changed to 30");
        duration = 30.0;
    } else if ([button isEqual:_fortyFiveButton]) {
        NSLog(@"duration changed to 45");
        duration = 45.0;
    }
   
    [self setDuration:duration];
    
    if (_delegate && [_delegate respondsToSelector:@selector(doodlerDidChangeDuration:)]) {
        [_delegate doodlerDidChangeDuration:_progressView.countdownDuration];
    }
}

- (void)setDuration:(float)duration
{
    _progressView.countdownDuration = duration;
    [self animateDurationButtonsOut];

}

//////////////////////////////////////////////////////////////////////
#pragma mark -
#pragma mark PieTimerDelegate

- (void)pieTimerDidExpire {
    if (_delegate && [_delegate respondsToSelector:@selector(toolbarCountdownDidFinish)]) {
        [_delegate toolbarCountdownDidFinish];
    }
}

- (void)pieTimerWarmupReady {
    if (_delegate && [_delegate respondsToSelector:@selector(toolbarWarmupDidFinish)]) {
        [_delegate toolbarWarmupDidFinish];
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
