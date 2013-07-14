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

#import "DPImageBoardTiler.h"
#import "DPSwatchToolbar.h"
#import "GTMatchMessenger.h"
#import "DKPlayerBoardView.h"

#import <BlocksKit/NSArray+BlocksKit.h>

@interface DKBoardController ()<DKDoodleViewDelegate, DPSwatchToolbarDelegate, DPImageBoardTilerDelegate>

@property (nonatomic, strong) DPImageBoardTiler *tiler;

@property (nonatomic) NSInteger playerCount;
@property (nonatomic, strong) NSMutableArray *tileViews;

@property (nonatomic) GTHostNegotiator *negotiator;
@end

@implementation DKBoardController

- (id)init
{
    self = [super init];
    if (self) {
        self.playerCount = 2;
        self.tileViews = [NSMutableArray arrayWithCapacity:4];
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self addGameCenterButton];
    [self addToolbar];
    [self addDoodleView];
    
    //TODO: random from a bunch of images, maybe image picker?
    UIImage *toTile = [UIImage imageNamed:@"doodle01"];
    _tiler = [[DPImageBoardTiler alloc] initWithImage:toTile delegate:self];
    
    //add clear UIViews to prevent touches
    [self addTouchBlockers];
    
    //TODO: hook up a real user index;
    _tiler.userIndex = 3;
    [_tiler tile];
}

- (void)viewDidAppear:(BOOL)animated {
    self.match.delegate = self;
    //if (_match.expectedPlayerCount == 0) {
        GTMatchMessenger *messenger = [GTMatchMessenger sharedMessenger];
        messenger.match = self.match;
        
        messenger.serializer = self.drawingView.serializer;
        
        GTHostNegotiator *negotiator = [[GTHostNegotiator alloc] init];
        negotiator.delegate = self;
        negotiator.match = self.match;
        //self.match.delegate = negotiator;
        
        messenger.negotiator = negotiator;
        
        self.negotiator = negotiator;
        [self.negotiator start];
        
    //}
}
- (BOOL)shouldAutorotate {
    return NO;
}

- (NSUInteger) supportedInterfaceOrientations
{
    return UIInterfaceOrientationMaskPortrait;
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
    button.center = CGPointMake(50.f, 610.f);
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

        GTMatchMessenger *messenger = [GTMatchMessenger sharedMessenger];
        messenger.match = self.match;
        
        messenger.serializer = self.drawingView.serializer;

        GTHostNegotiator *negotiator = [[GTHostNegotiator alloc] init];
        negotiator.delegate = self;
        negotiator.match = self.match;
        //self.match.delegate = negotiator;

        messenger.negotiator = negotiator;

        self.negotiator = negotiator;
        [self.negotiator start];

    }
}

- (void)match:(GKMatch *)match didReceiveData:(NSData *)data fromPlayer:(NSString *)playerID
{
    NSLog(@"I AM RECEIVING DATA");
    GTMatchMessenger *messenger = [GTMatchMessenger sharedMessenger];
    [messenger match:match didReceiveData:data fromPlayer:playerID];
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

- (void)addDoodleView {
    //TOFIX: crazy shiz
    DKDoodleView *doodleView = [[DKDoodleView alloc] initWithFrame:CGRectMake(100.f, self.toolbar.bounds.size.height, self.view.bounds.size.width - 100.f, self.view.bounds.size.height)];
    //DKDoodleView *doodleView = [[DKDoodleView alloc] initWithFrame:CGRectMake(0.0, self.toolbar.bounds.size.height, self.view.bounds.size.width, self.view.bounds.size.height)];
    
    self.drawingView = doodleView;
    self.drawingView.delegate = self;

    self.view.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:self.drawingView];
}

//hacky, easier than handling at framework level for now though
- (void)addTouchBlockers {
    for (NSUInteger i = 1; i <= 4; i++) {
        if (i == self.tiler.userIndex) continue;
        
        UIView *touchBlocker = [[UIView alloc] initWithFrame:[self.tiler frameForIndex:i]];
        touchBlocker.userInteractionEnabled = NO;
        touchBlocker.backgroundColor = [UIColor clearColor];
        
        [self.view addSubview:touchBlocker];
    }
}

- (void)addToolbar
{
    DPSwatchToolbar *aToolbar = [[DPSwatchToolbar alloc] init];
    self.toolbar = aToolbar;
    self.toolbar.frame = CGRectMake(0.0, -self.toolbar.bounds.size.height, self.toolbar.bounds.size.width, self.toolbar.bounds.size.height);
    self.toolbar.delegate = self;
    [self.view addSubview:self.toolbar];
    [self.toolbar showToolbar];
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

#pragma mark DPImageBoardTiler

- (void)imageTilerFinished:(DPImageBoardTiler *)tiler tiledImages:(NSDictionary *)images {
    __weak DKBoardController *selfRef = self;
    
    for (NSNumber *indexKey in images) {
        dispatch_async(dispatch_get_main_queue(), ^{
            UIImage *image = images[indexKey];
            DKPlayerBoardView *tileView = [[DKPlayerBoardView alloc] initWithFrame:[tiler frameForIndex:indexKey.unsignedIntegerValue]];
            tileView.image = image;
            [selfRef.view addSubview:tileView];
            [self.tileViews addObject:tileView];
        });
    }
}

- (void)didStartGame {
    NSLog(@"didStartGame");
}

- (void)didBecomeHost {
    NSLog(@"didBecomeHost");
}

- (void)toolbarWarmupDidFinish
{
    [self.tileViews each: ^(id obj) {
        [obj setReady];
    }];
}

@end
