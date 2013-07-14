//
//  DKBoardController.m
//  DoodleKitExample
//
//  Created on 7/13/13.
//  Copyright (c) 2013 DaveVan. All rights reserved.
//

#import "DKBoardController.h"
#import "DPSwatchToolbar.h"
#import <QuartzCore/QuartzCore.h>

#import "GTMatchMessenger.h"

@interface DKBoardController ()<DKDoodleViewDelegate, DPSwatchToolbarDelegate>

@property (nonatomic) NSInteger playerCount;
@property (nonatomic) GKMatch *match;

@property (nonatomic) GTHostNegotiator *negotiator;
@property (nonatomic) GTMatchMessenger *messenger;
@end

@implementation DKBoardController

- (id)init
{
    self = [super init];
    if (self) {
        self.playerCount = 2;
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self addGameCenterButton];
    [self addToolbar];
    [self addDoodleView];
}

- (void)didTouchButton
{
    GKMatchRequest *request = [[GKMatchRequest alloc] init];
    request.minPlayers = self.playerCount;
    request.maxPlayers = self.playerCount;

    GKMatchmakerViewController *viewController = [[GKMatchmakerViewController alloc] initWithMatchRequest:request];
    viewController.matchmakerDelegate = self;
    [self presentViewController:viewController animated:YES completion:nil];
}

- (void)addGameCenterButton
{
    UIButton *button = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    [button setTitle:@"Click Me" forState:UIControlStateNormal];
    [button addTarget:self action:@selector(didTouchButton) forControlEvents:UIControlEventTouchUpInside];
    [button sizeToFit];
    button.center = CGPointMake(50.f, 200.f);
    [self.view addSubview:button];
}

- (void)matchmakerViewControllerWasCancelled:(GKMatchmakerViewController *)viewController
{
    [self dismissViewControllerAnimated:YES completion:nil];

}

- (void)matchmakerViewController:(GKMatchmakerViewController *)viewController didFailWithError:(NSError *)error
{

}

- (void)matchmakerViewController:(GKMatchmakerViewController *)viewController didFindMatch:(GKMatch *)match
{
    self.match = match;
    self.match.delegate = self;
    if (match.expectedPlayerCount == 0) {
        [self dismissViewControllerAnimated:YES completion:nil];

        GTMatchMessenger *messenger = [[GTMatchMessenger alloc] initWithMatch:self.match];
        self.messenger = messenger;
        self.drawingView.serializer.messenger = self.messenger;
        self.messenger.serializer = self.drawingView.serializer;

        GTHostNegotiator *negotiator = [[GTHostNegotiator alloc] init];
        negotiator.delegate = self;
        negotiator.match = self.match;
        negotiator.messenger = self.messenger;
        //self.match.delegate = negotiator;

        self.messenger.negotiator = negotiator;

        self.negotiator = negotiator;
        [self.negotiator start];

    }
}

- (void)match:(GKMatch *)match didReceiveData:(NSData *)data fromPlayer:(NSString *)playerID
{
    NSLog(@"I AM RECEIVING DATA");
    [self.messenger match:match didReceiveData:data fromPlayer:playerID];
}


- (UILabel *)labelWithText:(NSString *)text {
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectZero];
    label.text = text;
    label.backgroundColor = [UIColor clearColor];
    label.textColor = [UIColor blackColor];
    [label sizeToFit];
    return label;
}


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)addDoodleView
{
    DKDoodleView *doodleView = [[DKDoodleView alloc] initWithFrame:CGRectMake(100.f, self.toolbar.bounds.size.height, self.view.bounds.size.width - 100.f, self.view.bounds.size.height)];
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
    self.toolbar.delegate = self;
    [self.view addSubview:self.toolbar];
    [self.toolbar showToolbar];
    [self.toolbar startCountdown];
}

- (void)toolbarCountdownDidFinish
{
    
}

- (void)doodlerDidChangeToSwatch:(DPSwatch *)swatch
{
    self.drawingView.lineWidth = 10.0f;
    self.drawingView.lineColor = swatch.swatchColor;
}

- (void)doodlerDidSelectEraser
{
    self.drawingView.lineWidth = 30.0f;
    self.drawingView.lineColor = [UIColor whiteColor];
}

- (void)doodlerDidSelectTrash
{

}

- (void)didStartGame {
    NSLog(@"didStartGame");
}

- (void)didBecomeHost {
    NSLog(@"didBecomeHost");
}


@end
