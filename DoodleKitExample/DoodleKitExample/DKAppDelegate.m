//
//  DKAppDelegate.m
//  DoodleKitExample
//
//  Created by Alexander Belliotti on 7/12/13.
//  Copyright (c) 2013 Alexander Belliotti. All rights reserved.
//

#import "DKAppDelegate.h"
#import "DPSwatchToolbar.h"
#import "UIControl+BlocksKit.h"

@implementation DKAppDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    // Override point for customization after application launch.
    self.window.backgroundColor = [UIColor whiteColor];
    [self.window makeKeyAndVisible];
    //TEST CODE
    self.window.backgroundColor = [UIColor grayColor];
    [self testToolbar];
    return YES;
}

- (void)applicationWillResignActive:(UIApplication *)application
{
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application
{
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later. 
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

- (void)applicationWillEnterForeground:(UIApplication *)application
{
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application
{
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}

- (void)applicationWillTerminate:(UIApplication *)application
{
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}

//- (void)testPieProgress {
//    SSPieProgressView *progressView = [[SSPieProgressView alloc] initWithFrame:CGRectMake(95.0f, 245.0f, 130.0f, 130.0f)];
//    __block NSTimer *timer = [NSTimer scheduledTimerWithTimeInterval:1.0/60.0 block:^(NSTimeInterval time){
//        progressView.progress = progressView.progress + (1.0/(kDrawingTimeInSeconds*30.0));
//        if (progressView.progress == 1.0f) {
//            [timer invalidate];
//        }
//        
//        } repeats:YES];
//    [self.window addSubview:progressView];
//    
//    DPSwatch *swatch = [[DPSwatch alloc] initWithColor:[UIColor blueColor] andBorderColor:[UIColor greenColor]];
//    swatch.center = CGPointMake(100.0, 100.0);
//    swatch.selected = YES;
//    [self.window addSubview:swatch];
//}

- (void)testToolbar {
    DPSwatchToolbar *toolbar = [[DPSwatchToolbar alloc] init];
    toolbar.frame = CGRectMake(0.0, 20.0, toolbar.bounds.size.width, toolbar.bounds.size.height);
    [self.window addSubview:toolbar];
    [toolbar startCountdown];
    
    UIButton *testButton = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    [testButton setTitle:@"animated" forState:UIControlStateNormal];
//    [testButton addTarget:toolbar action:@selector(animateSwatchesIn) forControlEvents:UIControlEventTouchUpInside];
    [testButton addEventHandler:^(id sender) {
        [toolbar showToolbar];
    } forControlEvents:UIControlEventTouchUpInside];
    testButton.center = CGPointMake(200.0, 400.0);
    testButton.backgroundColor = [UIColor blueColor];
    [testButton sizeToFit];
    [self.window addSubview:testButton];
    
    
}

@end
