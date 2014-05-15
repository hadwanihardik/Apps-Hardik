//
//  AddCoinView.m
//  MarketTradeApp
//
//  Created by Hardik Hadwani on 24/04/14.
//  Copyright (c) 2014 Hardik Hadwani. All rights reserved.
//

#import "AddCoinView.h"
#import "api_Database.h"
@interface AddCoinView ()

@end

@implementation AddCoinView

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    selectedMarket=101;
    received_data=[[NSMutableData alloc] init];
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
}
-(IBAction)radioButton:(UIButton *)sender
{
    for (int i=101; i<104; i++)
    {
        UIButton *btn=(UIButton *)[self.view viewWithTag:i];
        [btn setImage:[UIImage imageNamed:@"btnRadioCategory.png"] forState:UIControlStateNormal];
    }
    
    [sender setImage:[UIImage imageNamed:@"btnRadioCategory_S.png"] forState:UIControlStateNormal];
    selectedMarket=(int)sender.tag;

    
}
-(IBAction)addCoin:(id)sender
{
    [self.navigationController popToRootViewControllerAnimated:NO];
}



              
-(void)connection:(NSURLConnection *)connection didFailWithError:(NSError *)error
{
    [av stopAnimating];
    UIAlertView *alert=[[UIAlertView alloc] initWithTitle:@"Error" message:@"Check Network Connection" delegate:nil cancelButtonTitle:@"Dismiss" otherButtonTitles:nil];
    [alert show];

}
-(void)connection:(NSURLConnection *)connection didReceiveResponse:(NSURLResponse *)response
{
    [received_data setLength:0];//Set your data to 0 to clear your buffer
}
              
-(void)connection:(NSURLConnection *)connection didReceiveData:(NSData *)data
{
    
    [received_data appendData:data];//Append the download data..
}

-(void)connectionDidFinishLoading:(NSURLConnection *)connection
{
    [av stopAnimating];

    //Use your downloaded data here
    NSString * newStr = [[NSString alloc] initWithData:received_data encoding:NSUTF8StringEncoding];
    NSMutableDictionary *JSON = [NSJSONSerialization JSONObjectWithData: [newStr dataUsingEncoding:NSUTF8StringEncoding]
                                    options: NSJSONReadingMutableContainers
                                      error: nil];
    NSLog(@"%@",JSON);
    NSString *insertQuery=@"";
    if (selectedMarket==101)
    {
        if ([[JSON valueForKey:@"result"] isEqualToString:@"true"])
        {
            insertQuery=[NSString stringWithFormat:@"insert into coins(Name,LastPrice,Change,type,basePrice) values('%@','%@','%f','%@','%@')",txtSearch.text,[JSON valueForKey:@"buy"],[[JSON valueForKey:@"last"] floatValue]-[[JSON valueForKey:@"buy"] floatValue],kBter,[JSON valueForKey:@"high"]];
            BOOL stat=[api_Database genericQueryforDatabase:kDatabaseName query:insertQuery];
            NSLog(@"%@",stat?@"inserted":@"Error in insert");
            if (stat==TRUE)
            {
                UIAlertView *alert=[[UIAlertView alloc] initWithTitle:@"Added" message:@"Coin Added" delegate:nil cancelButtonTitle:@"Dismiss" otherButtonTitles:nil];
                [alert show];
//                [self.navigationController popToRootViewControllerAnimated:NO];

            }
            else
            {
                NSLog(@"Error in Insert");
            }

        }
        else
        {
            UIAlertView *alert=[[UIAlertView alloc] initWithTitle:@"Error" message:[JSON valueForKey:@"message"] delegate:nil cancelButtonTitle:@"Dismiss" otherButtonTitles:nil];
            [alert show];
        }
        
        
    }
    else if(selectedMarket==102)
    {
       
        
        if ([newStr rangeOfString:@"error"].location != NSNotFound)
        {
            UIAlertView *alert=[[UIAlertView alloc] initWithTitle:@"Error" message:@"Code Error" delegate:nil cancelButtonTitle:@"Dismiss" otherButtonTitles:nil];
            [alert show];
        }
        else
        {
            NSMutableArray *responseArray = [NSJSONSerialization JSONObjectWithData: [newStr dataUsingEncoding:NSUTF8StringEncoding]
                                                                            options: NSJSONReadingMutableContainers
                                                                              error: nil];
            
            if ([responseArray count] == 0) {
                UIAlertView *alert=[[UIAlertView alloc] initWithTitle:@"Empty" message:@"Data not Found" delegate:nil cancelButtonTitle:@"Dismiss" otherButtonTitles:nil];
                [alert show];
                return;
            }
            
                JSON = [responseArray objectAtIndex:0];
            
            NSLog(@"data :%@",JSON);
            
                insertQuery=[NSString stringWithFormat:@"insert into coins(Name,LastPrice,Change,type,basePrice) values('%@','%@','%@','%@','%@')",[JSON valueForKey:@"code"] ,[JSON valueForKey:@"last_price"],[JSON valueForKey:@"change"],kMintPal,[JSON valueForKey:@"last_price"] ];
                

                BOOL stat=[api_Database genericQueryforDatabase:kDatabaseName query:insertQuery];
                if (stat==TRUE) {
                    UIAlertView *alert=[[UIAlertView alloc] initWithTitle:@"Added" message:@"Coin Added" delegate:nil cancelButtonTitle:@"Dismiss" otherButtonTitles:nil];
                    [alert show];
        //            [self.navigationController popToRootViewControllerAnimated:NO];

                }
                else
                {
                    NSLog(@"Error in Insert");
                }
          
        }
        
    }
    else if(selectedMarket==103)
    {
        
        ////{"success":true,"message":"","result":{"Bid":0.02371119,"Ask":0.02372100,"Last":0.02372100}}
        NSString *str=newStr;
        if ([str rangeOfString:@"invalid market"].location != NSNotFound)
        {
            UIAlertView *alert=[[UIAlertView alloc] initWithTitle:@"Error" message:@"invalid market" delegate:nil cancelButtonTitle:@"Dismiss" otherButtonTitles:nil];
            [alert show];
            return;

        }
        str=[str substringFromIndex:[str rangeOfString:@"\"Last\":"].location+7];
        str=[str substringToIndex:[str rangeOfString:@"}}"].location];
      if ([[JSON valueForKey:@"success"] boolValue]==TRUE)
      {
            NSMutableDictionary *dict=[[NSMutableDictionary alloc]init];
            
            if ( [JSON isKindOfClass:[NSNull class]])
            {
                UIAlertView *alert=[[UIAlertView alloc] initWithTitle:@"Error" message:@"Wrong Code" delegate:nil cancelButtonTitle:@"Dismiss" otherButtonTitles:nil];
                [alert show];
                return;
            }
            
            dict=[JSON valueForKey:@"result"];
            insertQuery=[NSString stringWithFormat:@"insert into coins(Name,LastPrice,Change,type,basePrice) values('%@','%@','%@','%@','%@')",txtSearch.text,str,@"0.0",kBittrex,str];
           
            BOOL stat=[api_Database genericQueryforDatabase:kDatabaseName query:insertQuery];
            NSLog(@"%@",stat?@"inserted":@"Error in insert");
            if (stat==TRUE) {
                UIAlertView *alert=[[UIAlertView alloc] initWithTitle:@"Added" message:@"Coin Added" delegate:nil cancelButtonTitle:@"Dismiss" otherButtonTitles:nil];
                [alert show];

            }
            else
            {
                NSLog(@"Error in Insert");
            }

        }
        else
        {
            UIAlertView *alert=[[UIAlertView alloc] initWithTitle:@"Error" message:@"Wrong Code" delegate:nil cancelButtonTitle:@"Dismiss" otherButtonTitles:nil];
            [alert show];
        }


      
    }

    

    txtSearch.text=@"";

}

-(IBAction)Support:(id)sender
{
    
    AboutView *aboutView=[[AboutView alloc] initWithNibName:@"AboutView" bundle:nil];
    [self.navigationController pushViewController:aboutView animated:NO];
}
-(IBAction)settings:(id)sender
{
    
}
-(IBAction)search:(id)sender
{
    [txtSearch resignFirstResponder];
    NSString *stringURl=@"";
    
    NSString *selectQuery=[NSString stringWithFormat:@"Select * From coins where Name='%@'",txtSearch.text];
    NSMutableArray *array=[[NSMutableArray alloc] init];
    array=[api_Database selectDataFromDatabase:kDatabaseName query:selectQuery];
    if(array.count>0)
        
    {
        UIAlertView *alert=[[UIAlertView alloc] initWithTitle:@"Already Exist" message:@"Coin Already Exists." delegate:nil cancelButtonTitle:@"Dismiss" otherButtonTitles:nil];
        [alert show];
        return;
    }
    else
    {
            [av startAnimating];

            
            if (selectedMarket==101) {
                stringURl=[NSString stringWithFormat:@"https://data.bter.com/api/1/ticker/%@_btc",txtSearch.text];
            }
            else if(selectedMarket==102)
            {
                stringURl=[NSString stringWithFormat:@"https://api.mintpal.com/v1/market/stats/%@/BTC",txtSearch.text];


            }
            else if(selectedMarket==103)
            {
                stringURl=[NSString stringWithFormat:@"https://bittrex.com/api/v1/public/getticker?market=BTC-%@",txtSearch.text];
                
                
            }
            //https://bittrex.com/api/v1/public/getticker?market=BTC-LTC

            NSURL *url = [[NSURL alloc]initWithString:stringURl];
                          NSURLRequest *request = [NSURLRequest requestWithURL:url];
                          NSURLConnection *connection = [NSURLConnection connectionWithRequest:request delegate:self];
                          [connection start];
    }
    //It will start delegates
}
- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [textField resignFirstResponder];
    return TRUE;
}// called when 'return' key pressed. return NO to ignore.

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
