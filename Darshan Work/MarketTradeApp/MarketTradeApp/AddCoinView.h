//
//  AddCoinView.h
//  MarketTradeApp
//
//  Created by Hardik Hadwani on 24/04/14.
//  Copyright (c) 2014 Hardik Hadwani. All rights reserved.
//

//https://api.mintpal.com/v1/market/stats/AUR/BTC

//https://data.bter.com/api/1/ticker/btc_cny
//https://bittrex.com/api/v1/public/getticker?market=BTC-LTC
//[{"market_id":"25","code":"AUR","exchange":"BTC","last_price":"0.00128000","yesterday_price":"0.00148000","change":"-13.51","24hhigh":"0.00180000","24hlow":"0.00119990","24hvol":"19.206","top_bid":"0.00128818","top_ask":"0.00141800"}]


//{"result":"true","last":2730,"high":2812,"low":2625,"avg":2733.93,"sell":2738.96,"buy":2730.02,"vol_btc":398.212,"vol_cny":1088683.37}


//{"success":true,"message":"","result":{"Bid":0.02371119,"Ask":0.02372100,"Last":0.02372100}}

#import <UIKit/UIKit.h>
#import "AboutView.h"
@interface AddCoinView : UIViewController<UITextFieldDelegate,NSURLConnectionDataDelegate>

{
    IBOutlet UITextField *txtSearch;
    int selectedMarket;
    NSMutableData *received_data;
    IBOutlet UIActivityIndicatorView *av;
    
}

-(IBAction)support:(id)sender;

@end
