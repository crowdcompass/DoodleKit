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
    [self addToolbar];
    
    CGSize tileSize = CGSizeMake(768.f / 2.f, 960.f / 2.f);
    
    [self addDoodleViewWithActiveArea:CGRectMake(0.0f, 960.f / 2.f, tileSize.width, tileSize.height)];
    
    //TODO: random from a bunch of images, maybe image picker?
    UIImage *toTile = [UIImage imageNamed:@"doodle01"];
    _tiler = [[DPImageBoardTiler alloc] initWithImage:toTile tileSize:tileSize delegate:self];
    
    //TODO: hook up a real user index;
    _tiler.userIndex = 3;
    [_tiler tile];
}

- (void)viewDidAppear:(BOOL)animated {
    self.match.delegate = self;
    //if (_match.expectedPlayerCount == 0) {
        GTMatchMessenger *messenger = [GTMatchMessenger sharedMessenger];
        
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

- (void)addDoodleViewWithActiveArea:(CGRect)activeArea {
    DKDoodleView *doodleView = [[DKDoodleView alloc] initWithFrame:CGRectMake(0.0, self.toolbar.bounds.size.height, self.view.bounds.size.width, self.view.bounds.size.height)];
    
    self.drawingView = doodleView;
    self.drawingView.delegate = self;
    self.drawingView.activeArea = activeArea;
    self.drawingView.userInteractionEnabled = NO;

    self.view.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:self.drawingView];
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
    self.drawingView.lineWidth = 6.0f;
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
    self.drawingView.userInteractionEnabled = YES;
}

@end
