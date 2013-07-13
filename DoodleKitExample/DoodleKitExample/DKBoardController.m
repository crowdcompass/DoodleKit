//
//  DKBoardController.m
//  DoodleKitExample
//
//  Created on 7/13/13.
//  Copyright (c) 2013 DaveVan. All rights reserved.
//

#import "DKBoardController.h"
#import <DoodleKit/DoodleKit.h>

#import <QuartzCore/QuartzCore.h>

@interface DKBoardController ()<DKDoodleViewDelegate>

@end

@implementation DKBoardController

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.

    DKDoodleView *doodleView = [[DKDoodleView alloc] initWithFrame:self.view.bounds];
    self.drawingView = doodleView;
    self.drawingView.delegate = self;
    
    [self.view addSubview:self.drawingView];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
