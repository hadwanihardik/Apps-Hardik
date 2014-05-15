//
//  HomePage.h
//  MarketTradeApp
//
//  Created by Hardik Hadwani on 24/04/14.
//  Copyright (c) 2014 Hardik Hadwani. All rights reserved.
//
//sample change.
#import <UIKit/UIKit.h>
#import "AddCoinView.h"
#import "AboutView.h"
@interface HomePage : UIViewController<UITableViewDataSource,UITableViewDelegate,NSURLConnectionDataDelegate>
{
    
    NSMutableDictionary *forCustomCell;
    IBOutlet UITableView *tblView;
    IBOutlet UIView *headerTbl;
    NSMutableArray *arrayData;
    IBOutlet UIActivityIndicatorView *av;


}
-(IBAction)addCoin:(id)sender;
-(IBAction)support:(id)sender;
@end
