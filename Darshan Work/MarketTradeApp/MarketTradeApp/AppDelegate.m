//
//  AppDelegate.m
//  MarketTradeApp
//
//  Created by Hardik Hadwani on 24/04/14.
//  Copyright (c) 2014 Hardik Hadwani. All rights reserved.
//

#import "AppDelegate.h"
#import "HomePage.h"
#import "DemoViewController.h"

@implementation AppDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    
    
    if (![kPref valueForKey:kFirstDate])
    {
        [kPref setValue:[NSDate date] forKey:kFirstDate];
    }
    
//    NSDateFormatter *tempFormatter = [[NSDateFormatter alloc]init];
////    [tempFormatter setDateFormat:@"dd-MM-yyyy HH:mm:ss"];
//    NSDate *startdate = [tempFormatter dateFromString:[kPref valueForKey:kFirstDate]];
//    NSLog(@"startdate ==%@",startdate);
    
    
    // Override point for customization after application launch.
    HomePage *home=[[HomePage alloc] initWithNibName:@"HomePage" bundle:nil];
    UINavigationController *nav=[[UINavigationController alloc] initWithRootViewController:home];
    nav.navigationBar.hidden=TRUE;
    self.window.rootViewController=nav;
    self.window.backgroundColor = [UIColor whiteColor];
    [self.window makeKeyAndVisible];
    pref=[NSUserDefaults standardUserDefaults];
    if (![kPref valueForKey:kLastUpdateDate])
    {
        [kPref setValue:[NSDate date] forKey:kLastUpdateDate];
    }
    
    if ([kPref valueForKey:kLastUpdateDate])
    {
        [kPref setValue:[NSDate date] forKey:kLastUpdateDate];
    }
    
    int i = [[kPref valueForKey:kLastUpdateDate] timeIntervalSince1970];
    int j = [[NSDate date] timeIntervalSince1970];
    
    double X = j-i;
    
    if (X < 0)
    {
        DemoViewController *demoView = [[DemoViewController alloc]init];
        nav=[[UINavigationController alloc] initWithRootViewController:demoView];
        nav.navigationBar.hidden=TRUE;
        self.window.rootViewController=nav;
        return YES;
    }
    
    
    i = [[kPref valueForKey:kFirstDate] timeIntervalSince1970];
    j = [[NSDate date] timeIntervalSince1970];
    
    X = j-i;
    
    X=(int)((double)X/(3600.0*24.00));
    
    //    NSLog(@"data :%@   inteval :%f",[kPref valueForKey:kFirstDate],X);
    
    
    if (X > 30)
    {
        DemoViewController *demoView = [[DemoViewController alloc]init];
        UINavigationController *nav=[[UINavigationController alloc] initWithRootViewController:demoView];
        nav.navigationBar.hidden=TRUE;
        self.window.rootViewController=nav;
        return YES;
    }
    
    [kPref setValue:[NSDate date] forKey:kLastUpdateDate];
    
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
    
    if ([kPref valueForKey:kLastUpdateDate])
    {
        [kPref setValue:[NSDate date] forKey:kLastUpdateDate];
    }
    
    int i = [[kPref valueForKey:kLastUpdateDate] timeIntervalSince1970];
    int j = [[NSDate date] timeIntervalSince1970];
    
    double X = j-i;
    
    if (X < 0)
    {
        DemoViewController *demoView = [[DemoViewController alloc]init];
        UINavigationController *nav=[[UINavigationController alloc] initWithRootViewController:demoView];
        nav.navigationBar.hidden=TRUE;
        self.window.rootViewController=nav;
        return;
    }
    
    
    i = [[kPref valueForKey:kFirstDate] timeIntervalSince1970];
    j = [[NSDate date] timeIntervalSince1970];
    
    X = j-i;
    
    X=(int)((double)X/(3600.0*24.00));
    
    //    NSLog(@"data :%@   inteval :%f",[kPref valueForKey:kFirstDate],X);
    
    
    if (X > 30)
    {
        DemoViewController *demoView = [[DemoViewController alloc]init];
        UINavigationController *nav=[[UINavigationController alloc] initWithRootViewController:demoView];
        nav.navigationBar.hidden=TRUE;
        self.window.rootViewController=nav;
        return;
    }

[kPref setValue:[NSDate date] forKey:kLastUpdateDate];
    
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}

- (void)applicationWillTerminate:(UIApplication *)application
{
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}

@end
