//
//  DPSwatchToolbar.m
//  DoodleKitExample
//
//  Created by Dave Shanley on 7/12/13.
//  Copyright (c) 2013 Alexander Belliotti. All rights reserved.
//

#import "DPSwatchToolbar.h"
#import "DPSwatch.h"
#import "NSTimer+BlocksKit.h"
#import "SSDrawingUtilities.h"

#define kToolbarDefaultHeight 44.0
#define kCountdownTimeInSeconds 30.0
#define kToolbarDefaultTopPadding 5.0

@interface DPSwatchToolbar ()

@property (nonatomic, strong) UIButton *trash;

- (void)setupToolbar;
- (void)addSwatches;

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
    
    _progressView = [[SSPieProgressView alloc] init];
    CGRect progressRect = CGRectMake(12.0, kToolbarDefaultTopPadding, 33.0, 33.0);
    _progressView.frame = progressRect;
    
    _trash = [UIButton buttonWithType:UIButtonTypeCustom];
    [_trash setImage:[UIImage imageNamed:@"trash"] forState:UIControlStateNormal];
    [_trash sizeToFit];
    _trash.frame = CGRectMake(toolbarWidth - _trash.bounds.size.width - 12.0, kToolbarDefaultTopPadding,
                              CGRectGetWidth(_trash.bounds), CGRectGetHeight(_trash.bounds));
    
    DPSwatch *swatch1 = [[DPSwatch alloc] initWithColor:[UIColor colorWithRed:68.0/255.0 green:68.0/255.0 blue:68.0/255.0 alpha:1.0]];
    DPSwatch *swatch2 = [[DPSwatch alloc] initWithColor:[UIColor colorWithRed:122.0/255.0 green:171.0/255.0 blue:219.0/255.0 alpha:1.0]];
    DPSwatch *swatch3 = [[DPSwatch alloc] initWithColor:[UIColor colorWithRed:108.0/255.0 green:195.0/255.0 blue:155.0/255.0 alpha:1.0]];
    DPSwatch *swatch4 = [[DPSwatch alloc] initWithColor:[UIColor colorWithRed:250.0/255.0 green:176.0/255.0 blue:60.0/255.0 alpha:1.0]];
    DPSwatch *swatch5 = [[DPSwatch alloc] initWithColor:[UIColor colorWithRed:242.0/255.0 green:114.0/255.0 blue:98.0/255.0 alpha:1.0]];
    DPSwatch *swatch6 = [[DPSwatch alloc] initWithColor:[UIColor colorWithRed:162.0/255.0 green:141.0/255.0 blue:193.0/255.0 alpha:1.0]];
    DPSwatch *swatch7 = [[DPSwatch alloc] initWithColor:[UIColor colorWithRed:255.0/255.0 green:255.0/255.0 blue:255.0/255.0 alpha:1.0]
                                         andBorderColor:[UIColor colorWithRed:68.0/255.0 green:68.0/255.0 blue:68.0/255.0 alpha:1.0]];
    
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

- (void)addSwatches {
    
}

- (void)showToolbar {
    
}


- (void)startCountdown {
    __block NSTimer *timer = [NSTimer scheduledTimerWithTimeInterval:1.0/60.0 block:^(NSTimeInterval time){
        _progressView.progress = _progressView.progress + (1.0/(kCountdownTimeInSeconds*60.0));
        if (_progressView.progress == 1.0f) {
            [timer invalidate];
            if (_delegate && [_delegate respondsToSelector:@selector(toolbarCountdownDidFinish)]) {
                [_delegate toolbarCountdownDidFinish];
            }
        }
        
    } repeats:YES];
}

@end
