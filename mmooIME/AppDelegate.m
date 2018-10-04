//
//  AppDelegate.m
//  MmooKeyboard
//
//  Created by 透子 桃井 on 12/01/17.
//  Copyright (c) 2012年 mmoos. All rights reserved.
//

#import "AppDelegate.h"
#import "TextListViewController.h"
#import "KeyboardSettingViewController.h"
#import "SettingsViewController.h"
#import "WebMenuController.h"

@implementation AppDelegate

@synthesize window = _window;

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions{
    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    
    TextListViewController *vc1 = [[TextListViewController alloc] init];
    UINavigationController *nav1= [[UINavigationController alloc] initWithRootViewController:vc1];
    [nav1.tabBarItem setImage:[UIImage imageNamed:@"179-notepad.png"]];
    
    KeyboardSettingViewController *vc2 = [[KeyboardSettingViewController alloc] init];
    UINavigationController *nav2= [[UINavigationController alloc] initWithRootViewController:vc2];
    [nav2.tabBarItem setImage:[UIImage imageNamed:@"keyboard_white.png"]];
    
    SettingsViewController *vc3 = [[SettingsViewController alloc] init];
    UINavigationController *nav3= [[UINavigationController alloc] initWithRootViewController:vc3];
    [nav3.tabBarItem setImage:[UIImage imageNamed:@"158-wrench-2.png"]];
    
    WebMenuController *vc4 = [[WebMenuController alloc] init];
    UINavigationController *nav4= [[UINavigationController alloc] initWithRootViewController:vc4];
    [nav4.tabBarItem setImage:[UIImage imageNamed:@"27-planet.png"]];
    
    UITabBarController *tab = [[UITabBarController alloc] init];
    [tab setViewControllers:[NSArray arrayWithObjects:nav1,nav2,nav3,nav4,nil]];
    self.window.rootViewController = tab;
    [self.window makeKeyAndVisible];
    
    return YES;
}

- (void)applicationWillResignActive:(UIApplication *)application
{
    /*
     Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
     Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
     */
}

- (void)applicationDidEnterBackground:(UIApplication *)application
{
    /*
     Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later. 
     If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
     */
}

- (void)applicationWillEnterForeground:(UIApplication *)application
{
    /*
     Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
     */
}

- (void)applicationDidBecomeActive:(UIApplication *)application
{
    /*
     Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
     */
}

- (void)applicationWillTerminate:(UIApplication *)application
{
    /*
     Called when the application is about to terminate.
     Save data if appropriate.
     See also applicationDidEnterBackground:.
     */
}

@end
