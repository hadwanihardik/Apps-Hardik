//
//  AppDelegate.h
//  MarketTradeApp
//
//  Created by Hardik Hadwani on 24/04/14.
//  Copyright (c) 2014 Hardik Hadwani. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface AppDelegate : UIResponder <UIApplicationDelegate>

{
    NSUserDefaults *pref;
    NSDateFormatter *formatter;
}
@property (strong, nonatomic) UIWindow *window;

@end
