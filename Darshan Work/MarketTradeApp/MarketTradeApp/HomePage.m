//
//  HomePage.m
//  MarketTradeApp
//
//  Created by Hardik Hadwani on 24/04/14.
//  Copyright (c) 2014 Hardik Hadwani. All rights reserved.
//

#import "HomePage.h"
#import "api_Database.h"
@interface HomePage ()

@end

@implementation HomePage

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    forCustomCell = [[NSMutableDictionary alloc] init];
    NSArray * templates = [[NSBundle mainBundle] loadNibNamed:nibNameOrNil owner:self options:nil];
    for (id template in templates) {
        if ([template isKindOfClass:[UITableViewCell class]]) {
            UITableViewCell * cellTemplate = (UITableViewCell *)template;
            NSString * key = cellTemplate.reuseIdentifier;
            if (key) {
                [forCustomCell setObject:[NSKeyedArchiver archivedDataWithRootObject:template]forKey:key];
            }
            else
            {
                @throw [NSException exceptionWithName:@"Unknown cell"
                                               reason:@"Cell has no reuseIdentifier"
                                             userInfo:nil];
            }
        }
    }

    return self;
}
-(void) viewWillAppear:(BOOL)animated
{
    NSString *selectQuery=[NSString stringWithFormat:@"Select * From coins"];
    arrayData=[[NSMutableArray alloc] init];
    arrayData=[api_Database selectDataFromDatabase:kDatabaseName query:selectQuery];
    if (arrayData.count==0)
    {
        tblView.hidden=TRUE;
    }
    else
    {
        tblView.hidden=FALSE;
        [tblView reloadData];
        [self update:nil];
    }
    
}
-(void)reloadData
{
    NSString *selectQuery=[NSString stringWithFormat:@"Select * From coins"];
    arrayData=[[NSMutableArray alloc] init];
    arrayData=[api_Database selectDataFromDatabase:kDatabaseName query:selectQuery];
    if (arrayData.count==0) {
        tblView.hidden=TRUE;
    }
    else
    {
        tblView.hidden=FALSE;
        
        [tblView reloadData];
    }
}
-(IBAction)update:(id)sender
{
    if (arrayData.count==0)
    {
        UIAlertView *alert=[[UIAlertView alloc] initWithTitle:@"ERROR" message:@"No Coins To be Updated" delegate:nil cancelButtonTitle:@"Dismiss" otherButtonTitles:nil];
        [alert show];

        return;
    }
    else
    {
        [av startAnimating];
        [self performSelector:@selector(updateData) withObject:nil afterDelay:1];
    }
}
-(void) updateData
{
    NSDateFormatter *df=[[NSDateFormatter alloc] init];
    [df setDateFormat:@"dd:MM"];

    for (int i=0; i<arrayData.count; i++)
    {
        NSString *__stringURl=@"";
        if ([[[arrayData objectAtIndex:i] valueForKey:kType] isEqualToString:kBter])
        {
            __stringURl=[NSString stringWithFormat:@"https://data.bter.com/api/1/ticker/%@_btc",[[arrayData objectAtIndex:i] valueForKey:kName]];
        }
        else if([[[arrayData objectAtIndex:i] valueForKey:kType] isEqualToString:kMintPal])
        {
            __stringURl=[NSString stringWithFormat:@"https://api.mintpal.com/v1/market/stats/%@/BTC",[[arrayData objectAtIndex:i] valueForKey:kName]];
            
            
        }
        else if([[[arrayData objectAtIndex:i] valueForKey:kType] isEqualToString:kBittrex])
        {
            __stringURl=[NSString stringWithFormat:@"https://bittrex.com/api/v1/public/getticker?market=BTC-%@",[[arrayData objectAtIndex:i] valueForKey:kName]];
            
            
        }
        
        NSString *respo=[NSString stringWithContentsOfURL:[NSURL URLWithString:__stringURl] encoding:NSUTF8StringEncoding error:nil];
        NSLog(@"resp %@",respo);
        NSDictionary *JSON = [NSJSONSerialization JSONObjectWithData: [respo dataUsingEncoding:NSUTF8StringEncoding]
                                                             options: NSJSONReadingMutableContainers
                                                               error: nil];
        NSString *updatequery=@"";
        
         if([JSON count]==0)
         {
             continue;
         }
        if ([[[arrayData objectAtIndex:i] valueForKey:kType] isEqualToString:kBter])
        {
           updatequery=[NSString stringWithFormat:@"update coins set LastPrice='%@',Change='%f' where Name='%@'",[JSON valueForKey:@"buy"],[[JSON valueForKey:@"last"] floatValue]-[[JSON valueForKey:@"buy"] floatValue],[[arrayData objectAtIndex:i] valueForKey:kName]];
            
            BOOL stat=[api_Database genericQueryforDatabase:kDatabaseName query:updatequery];
            NSLog(@"%@",stat?@"update":@"Error in update");

          
            if ([[df stringFromDate:[kPref valueForKey:kLastUpdateDate]] isEqualToString:[df stringFromDate:[NSDate date]]])
            {
                float basePrice=[[[arrayData objectAtIndex:i] valueForKey:@"basePrice"] floatValue];
                float currentPrice=[[JSON valueForKey:@"buy"] floatValue];
                
                float percentage=0.0;
                NSLog(@"%f - %f",basePrice,currentPrice);

                if (basePrice>currentPrice)
                {
                     percentage=((basePrice/currentPrice)-1)*100;
                    updatequery=[NSString stringWithFormat:@"update coins set LastPrice='%@',Change='-%.2f' where Name='%@'",[JSON valueForKey:@"buy"],percentage,[[arrayData objectAtIndex:i] valueForKey:kName]];

                }
                else
                {
                    percentage=((currentPrice/basePrice)-1)*100;
                    updatequery=[NSString stringWithFormat:@"update coins set LastPrice='%@',Change='%.2f' where Name='%@'",[JSON valueForKey:@"buy"],percentage,[[arrayData objectAtIndex:i] valueForKey:kName]];


                }
                

                
                 stat=[api_Database genericQueryforDatabase:kDatabaseName query:updatequery];
                NSLog(@"%@",stat?@"update":@"Error in update change price %%");
            }
            else
            {
                updatequery=[NSString stringWithFormat:@"update coins set LastPrice='%@',Change='0.0',basePrice='%@' where Name='%@'",[JSON valueForKey:@"buy"],[JSON valueForKey:@"high"],[[arrayData objectAtIndex:i] valueForKey:kName]];
                
                 stat=[api_Database genericQueryforDatabase:kDatabaseName query:updatequery];
                NSLog(@"%@",stat?@"update":@"Error in setBase price bter ");

            
            }
            
        }
        else if([[[arrayData objectAtIndex:i] valueForKey:kType] isEqualToString:kMintPal])
        {
            updatequery=[NSString stringWithFormat:@"update coins set LastPrice='%@',Change='%@' where Name='%@'",[[JSON valueForKey:@"last_price"] objectAtIndex:0],[[JSON valueForKey:@"change"] objectAtIndex:0],[[arrayData objectAtIndex:i] valueForKey:kName]];
            
            BOOL stat=[api_Database genericQueryforDatabase:kDatabaseName query:updatequery];
            
            NSLog(@"%@",stat?@"inserted":@"Error in update");
            
            
            
            
        }
        
        else if([[[arrayData objectAtIndex:i] valueForKey:kType] isEqualToString:kBittrex])
        {
            
           // NSMutableDictionary *dict=[[NSMutableDictionary alloc]init];
            JSON=[JSON valueForKey:@"result"];
            NSString *str=respo;
            str=[str substringFromIndex:[str rangeOfString:@"\"Last\":"].location+7];
            
            str=[str substringToIndex:[str rangeOfString:@"}}"].location];

            
            updatequery=[NSString stringWithFormat:@"update coins set LastPrice='%@',Change='%@' where Name='%@'",str,@"N/A",[[arrayData objectAtIndex:i] valueForKey:kName]];
            
            BOOL stat=[api_Database genericQueryforDatabase:kDatabaseName query:updatequery];
            
            NSLog(@"%@",stat?@"update":@"Error in update");
            
            
            if ([[df stringFromDate:[kPref valueForKey:kLastUpdateDate]] isEqualToString:[df stringFromDate:[NSDate date]]])
            {
                float basePrice=[[[arrayData objectAtIndex:i] valueForKey:@"basePrice"] floatValue];
                float currentPrice=[str floatValue];
                float percentage=0.0;
                
                NSLog(@"%f - %f",basePrice,currentPrice);
                
                if (basePrice>currentPrice)
                {
                    percentage=((basePrice/currentPrice)-1)*100;
                    updatequery=[NSString stringWithFormat:@"update coins set LastPrice='%@',Change='-%.2f' where Name='%@'",str,percentage,[[arrayData objectAtIndex:i] valueForKey:kName]];
                    
                }
                else
                {
                    percentage=((currentPrice/basePrice)-1)*100;
                    updatequery=[NSString stringWithFormat:@"update coins set LastPrice='%@',Change='%.2f' where Name='%@'",str,percentage,[[arrayData objectAtIndex:i] valueForKey:kName]];
                }
                
                stat=[api_Database genericQueryforDatabase:kDatabaseName query:updatequery];
                NSLog(@"%@",stat?@"update":@"Error in update change price %%");
            }
            else
            {
                updatequery=[NSString stringWithFormat:@"update coins set LastPrice='%@',Change='0.0',basePrice='%@' where Name='%@'",str,[JSON valueForKey:@"Last"],[[arrayData objectAtIndex:i] valueForKey:kName]];
                
                stat=[api_Database genericQueryforDatabase:kDatabaseName query:updatequery];
                NSLog(@"%@",stat?@"update":@"Error in setBase price bter ");
               
            }

            
        }
        
        // });
    }
    [self reloadData];
    UIAlertView *alert=[[UIAlertView alloc] initWithTitle:@"Updated" message:@"Coin Updated" delegate:nil cancelButtonTitle:@"Dismiss" otherButtonTitles:nil];
    [alert show];
    [av stopAnimating];

}
- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
}

- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Return YES - we will be able to delete all rows
    return YES;
}

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Perform the real delete action here. Note: you may need to check editing style
    //   if you do not perform delete only.
    
    NSString *deleteQuery=@"";
    
    int i=(int)indexPath.row;
   
        deleteQuery=[NSString stringWithFormat:@"delete from coins where  Name='%@'",[[arrayData objectAtIndex:i] valueForKey:kName]];
    
        BOOL stat=[api_Database genericQueryforDatabase:kDatabaseName query:deleteQuery];
        NSLog(@"%@",stat?@"deleted":@"Error in deleted");
    
    if (stat==TRUE) {
        UIAlertView *alert=[[UIAlertView alloc] initWithTitle:@"Removed" message:@"Coin Deleted" delegate:nil cancelButtonTitle:@"Dismiss" otherButtonTitles:nil];
        [alert show];

    }
       [self reloadData];
    NSLog(@"Deleted row.");
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return arrayData.count;
}

- (UITableViewCell*)cellOfKind: (NSString*)theCellKind forTable: (UITableView*)aTableView
{
    UITableViewCell *cell = [aTableView dequeueReusableCellWithIdentifier:theCellKind];
    
    if (!cell)
    {
        NSData * cellData = [forCustomCell objectForKey:theCellKind];
        if (cellData)
        {
            cell = [NSKeyedUnarchiver unarchiveObjectWithData:cellData];
        }
        else
        {
            NSLog(@"Don't know nothing about cell of kind %@", theCellKind);
        }
    }
    return cell;
}


// Row display. Implementers should *always* try to reuse cells by setting each cell's reuseIdentifier and querying for available reusable cells with dequeueReusableCellWithIdentifier:
// Cell gets various attributes set automatically based on table (separators) and data source (accessory views, editing controls)

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell;
    
    cell=[self cellOfKind:@"List" forTable:tableView];
    
    UILabel *lblCode=(UILabel *)[cell viewWithTag:1];
    UILabel *lblLastPrice=(UILabel *)[cell viewWithTag:2];
    UILabel *lblChange=(UILabel *)[cell viewWithTag:3];
    
    lblCode.text=[[arrayData objectAtIndex:indexPath.row] valueForKey:kName];
    lblLastPrice.text=[[arrayData objectAtIndex:indexPath.row] valueForKey:kLastPrice];
    if ([[[arrayData objectAtIndex:indexPath.row] valueForKey:kType] isEqualToString:kBter])
    {
        if ([[[arrayData objectAtIndex:indexPath.row] valueForKey:kChange] floatValue]>0.0)
        {
            lblChange.text=[NSString stringWithFormat:@"+ %@%%",[[arrayData objectAtIndex:indexPath.row] valueForKey:kChange]];

        }
        else
        {
            lblChange.text=[NSString stringWithFormat:@" %@%%",[[arrayData objectAtIndex:indexPath.row] valueForKey:kChange]];

        }

    }
    else     if ([[[arrayData objectAtIndex:indexPath.row] valueForKey:kType] isEqualToString:kMintPal])

    {
        lblChange.text=[NSString stringWithFormat:@"%@%%",[[arrayData objectAtIndex:indexPath.row] valueForKey:kChange]];
    }
    else     if ([[[arrayData objectAtIndex:indexPath.row] valueForKey:kType] isEqualToString:kBittrex])
        
    {
        if ([[[arrayData objectAtIndex:indexPath.row] valueForKey:kChange] floatValue]>0.0)
        {
            lblChange.text=[NSString stringWithFormat:@"+ %@%%",[[arrayData objectAtIndex:indexPath.row] valueForKey:kChange]];
            
        }
        else
        {
            lblChange.text=[NSString stringWithFormat:@" %@%%",[[arrayData objectAtIndex:indexPath.row] valueForKey:kChange]];
            
        }
    }
    else
    {
        
        if ([[[arrayData objectAtIndex:indexPath.row] valueForKey:kChange] floatValue]>0.0)
        {
            lblChange.text=[NSString stringWithFormat:@"+ %@%%",[[arrayData objectAtIndex:indexPath.row] valueForKey:kChange]];
            
        }
        else
        {
            lblChange.text=[NSString stringWithFormat:@" %@%%",[[arrayData objectAtIndex:indexPath.row] valueForKey:kChange]];
            
        }

    }
    
    if ([[[arrayData objectAtIndex:indexPath.row] valueForKey:kChange] floatValue]>= 0.0)
    {
        lblChange.textColor=[UIColor greenColor];
        
    }
    else
    {
        lblChange.textColor=[UIColor redColor];
    }
    
    if ([[[arrayData objectAtIndex:indexPath.row] valueForKey:kChange] isEqualToString:@"N/A"])
    {
        lblChange.textColor=[UIColor blackColor];
        
    }
    
    
     return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath;
{

    /* NSMutableDictionary *dict=[[NSMutableDictionary alloc] initWithDictionary:[[arrayQuestions objectAtIndex:currentIndex] copy]];
    if ([[dict valueForKey:kisAnswerLocked] isEqualToString:@"-1"])
    {
        UITableViewCell *cell=[tableView cellForRowAtIndexPath:indexPath];
        [cell setAccessoryType:UITableViewCellAccessoryCheckmark];
        NSMutableDictionary *dict=[[NSMutableDictionary alloc] initWithDictionary:[[arrayQuestions objectAtIndex:currentIndex] copy]];
        [dict setValue:[NSString stringWithFormat:@"%d",indexPath.row] forKey:kGivenAnswer];
        
        [arrayQuestions removeObjectAtIndex:currentIndex];
        [arrayQuestions insertObject:dict atIndex:currentIndex];
        NSLog(@"%@",dict);
        [tblView reloadData];
        selectedAnswer=indexPath.row;
    }
    */
    
}

-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    return headerTbl;
}

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 40.0;
}
-(IBAction)addCoin:(id)sender
{
    AddCoinView *add=[[AddCoinView alloc] initWithNibName:@"AddCoinView" bundle:nil];
    [self.navigationController pushViewController:add animated:NO];
}



-(IBAction)Support:(id)sender
{
    AboutView *aboutView=[[AboutView alloc] initWithNibName:@"AboutView" bundle:nil];
    [self.navigationController pushViewController:aboutView animated:NO];
}
-(IBAction)settings:(id)sender
{
 
}
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
