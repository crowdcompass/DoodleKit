//
//  DKViewController.m
//  DoodleKit
//
//  Created on 7/12/13.
//  Copyright (c) 2013 DaveVan. All rights reserved.
//

#import "DKViewController.h"
#import "DKDoodleView.h"

#import <QuartzCore/QuartzCore.h>

@interface DKViewController ()<DKDoodleViewDelegate>

@end

@implementation DKViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
    // set the delegate
    self.drawingView.delegate = self;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
