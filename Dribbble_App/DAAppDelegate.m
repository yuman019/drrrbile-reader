//
//  DAAppDelegate.m
//  Dribbble_App
//
//  Created by oda yuma on 2014/08/09.
//  Copyright (c) 2014年 yuma oda. All rights reserved.
//

#import "DAAppDelegate.h"
#import "DATopViewController.h"
#import "DALeftSideViewController.h"
#import "JASidePanelController.h"
#import "DACoreDataManager.h"

@implementation DAAppDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    // Override point for customization after application launch.
    self.window.backgroundColor = [UIColor whiteColor];
    
    JASidePanelController *sidePanelController = [[JASidePanelController alloc] init];
    DALeftSideViewController *leftSideVC = [[DALeftSideViewController alloc] initWithNibName:@"DALeftSideViewController" bundle:nil];
    //sidePanelController.leftPanel = [[UINavigationController alloc] initWithRootViewController:leftSideVC];
    sidePanelController.leftPanel = leftSideVC;
    DATopViewController *topVC = [[DATopViewController alloc] initWithNibName:@"DATopViewController" bundle:nil];
    sidePanelController.centerPanel = [[UINavigationController alloc] initWithRootViewController:topVC];
    
    self.window.rootViewController = sidePanelController;
    [self settingNavigationbar];
    
    [self.window makeKeyAndVisible];
    return YES;
}

-(void)settingNavigationbar
{
    [UINavigationBar appearance].barTintColor = COLOR_PINK;
    [UINavigationBar appearance].tintColor = [UIColor whiteColor];
    [UINavigationBar appearance].titleTextAttributes = @{NSForegroundColorAttributeName: [UIColor whiteColor]};
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
    // Saves changes in the application's managed object context before the application terminates.
    //[self saveContext];
    [[DACoreDataManager sharedManager] saveContextCompletion:nil];
}

@end
