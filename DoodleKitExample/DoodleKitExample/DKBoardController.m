//
//  DKBoardController.m
//  DoodleKitExample
//
//  Created on 7/13/13.
//  Copyright (c) 2013 DaveVan. All rights reserved.
//

#import "DKBoardController.h"
#import "DPSwatchToolbar.h"
#import <DoodleKit/DoodleKit.h>
#import <QuartzCore/QuartzCore.h>

@interface DKBoardController ()<DKDoodleViewDelegate, DPSwatchToolbarDelegate>

@end

@implementation DKBoardController

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self addToolbar];
    [self addDoodleView];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)addDoodleView
{
    DKDoodleView *doodleView = [[DKDoodleView alloc] initWithFrame:CGRectMake(0.0, self.toolbar.bounds.size.height, self.view.bounds.size.width, self.view.bounds.size.height)];
    self.drawingView = doodleView;
    self.drawingView.delegate = self;
    
    self.view.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:self.drawingView];
}

- (void)addToolbar
{
    DPSwatchToolbar *aToolbar = [[DPSwatchToolbar alloc] init];
    self.toolbar = aToolbar;
    self.toolbar.backgroundColor = [UIColor colorWithRed:0.0f green:0.0f blue:0.0f alpha:0.1f];
    self.toolbar.frame = CGRectMake(0.0, -self.toolbar.bounds.size.height, self.toolbar.bounds.size.width, self.toolbar.bounds.size.height);
    [self.view addSubview:self.toolbar];
    [self.toolbar showToolbar];
    [self.toolbar startCountdown];
}

- (void)toolbarCountdownDidFinish
{
    
}

- (void)doodlerDidChangeToSwatch:(DPSwatch *)swatch
{
    
}

- (void)doodlerDidSelectEraser
{
    
}

- (void)doodlerDidSelectTrash
{

}

@end
