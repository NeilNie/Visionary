//
//  PreferenceStore.m
//  Visionary
//
//  Created by Yongyang Nie on 3/12/16.
//  Copyright © 2016 Yongyang Nie. All rights reserved.
//

#import "PreferenceViewController.h"

#define kRemoveAdsProductIdentifier1 @"noads.visionary.com"

@interface PreferenceViewController ()

@end

@implementation PreferenceViewController

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    NSURL *url = [NSURL URLWithString:[[self.apps objectAtIndex:indexPath.row] objectForKey:@"link"]];
    [[UIApplication sharedApplication] openURL:url options:@{} completionHandler:nil];
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.apps.count;
}

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 65;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"idTableCell" forIndexPath:indexPath];
    cell.textLabel.text = [[self.apps objectAtIndex:indexPath.row] objectForKey:@"title"];
    cell.detailTextLabel.text = [[self.apps objectAtIndex:indexPath.row] objectForKey:@"description"];
    return cell;
}

#pragma mark - IBActions

- (IBAction)tapsRemoveAds{
    NSLog(@"User requests to remove ads");
    
    if([SKPaymentQueue canMakePayments]){
        NSLog(@"User can make payments");
        
        SKProductsRequest *productsRequest = [[SKProductsRequest alloc] initWithProductIdentifiers:[NSSet setWithObject:kRemoveAdsProductIdentifier1]];
        productsRequest.delegate = self;
        [productsRequest start];
    }
    else{
        NSLog(@"User cannot make payments due to parental controls");
        //this is called the user cannot make payments, most likely due to parental controls
    }
}

- (IBAction) restore{
    
    //this is called when the user restores purchases, you should hook this up to a button
    [[SKPaymentQueue defaultQueue] addTransactionObserver:self];
    [[SKPaymentQueue defaultQueue] restoreCompletedTransactions];
    areAdsRemoved = NO;
    [[NSUserDefaults standardUserDefaults] setBool:areAdsRemoved forKey:@"areAdsRemoved"];
    //use NSUserDefaults so that you can load wether or not they bought it
    [[NSUserDefaults standardUserDefaults] synchronize];
}


- (IBAction)switchStorage:(id)sender{
    
}

#pragma mark - IAP Store

- (void)productsRequest:(SKProductsRequest *)request didReceiveResponse:(SKProductsResponse *)response{
    
    SKProduct *validProduct = nil;
    NSUInteger count = [response.products count];
    if(count > 0){
        validProduct = [response.products objectAtIndex:0];
        NSLog(@"Products Available!");
        [self purchase:validProduct];
    }
    else if(!validProduct){
        NSLog(@"No products available");
        //this is called if your product id is not valid, this shouldn't be called unless that happens.
    }
}

- (void)purchase:(SKProduct *)product{
    SKPayment *payment = [SKPayment paymentWithProduct:product];
    
    [[SKPaymentQueue defaultQueue] addTransactionObserver:self];
    [[SKPaymentQueue defaultQueue] addPayment:payment];
}

- (void) paymentQueueRestoreCompletedTransactionsFinished:(SKPaymentQueue *)queue
{
    NSLog(@"received restored transactions: %lu", (unsigned long)queue.transactions.count);
    
    for(SKPaymentTransaction *transaction in queue.transactions){
        if(transaction.transactionState == SKPaymentTransactionStateRestored){
            //called when the user successfully restores a purchase
            NSLog(@"Transaction state -> Restored");
            
            //if you have more than one in-app purchase product,
            //you restore the correct product for the identifier.
            //For example, you could use
            //if(productID == kRemoveAdsProductIdentifier)
            //to get the product identifier for the
            //restored purchases, you can use
            //
            //NSString *productID = transaction.payment.productIdentifier;
            [self doRemoveAds];
            [[SKPaymentQueue defaultQueue] finishTransaction:transaction];
            break;
        }
    }
}

- (void)paymentQueue:(SKPaymentQueue *)queue updatedTransactions:(NSArray *)transactions{
    
    for(SKPaymentTransaction *transaction in transactions){
        switch(transaction.transactionState){
            case SKPaymentTransactionStatePurchasing: NSLog(@"Transaction state -> Purchasing");
                //called when the user is in the process of purchasing, do not add any of your own code here.
                break;
            case SKPaymentTransactionStatePurchased:
                //this is called when the user has successfully purchased the package (Cha-Ching!)
                [self doRemoveAds]; //you can add your code for what you want to happen when the user buys the purchase here, for this tutorial we use removing ads
                [[SKPaymentQueue defaultQueue] finishTransaction:transaction];
                NSLog(@"Transaction state -> Purchased");
                break;
            case SKPaymentTransactionStateRestored:
                NSLog(@"Transaction state -> Restored");
                //add the same code as you did from SKPaymentTransactionStatePurchased here
                [[SKPaymentQueue defaultQueue] finishTransaction:transaction];
                break;
            case SKPaymentTransactionStateFailed:
                //called when the transaction does not finish
                if(transaction.error.code == SKErrorPaymentCancelled){
                    NSLog(@"Transaction state -> Cancelled");
                    //the user cancelled the payment ;(
                }
                [[SKPaymentQueue defaultQueue] finishTransaction:transaction];
                break;
            case SKPaymentTransactionStateDeferred:
                break;
        }
    }
}

- (void)doRemoveAds{
    
    areAdsRemoved = YES;
    [[NSUserDefaults standardUserDefaults] setBool:areAdsRemoved forKey:@"areAdsRemoved"];
    [[NSUserDefaults standardUserDefaults] synchronize];
}
- (IBAction)secret:(id)sender {
    
    [self doRemoveAds];
}

- (void)viewDidLoad {
    
    areAdsRemoved = [[NSUserDefaults standardUserDefaults] boolForKey:@"areAdsRemoved"];
    [[NSUserDefaults standardUserDefaults] synchronize];
    
    self.apps = [[NSMutableArray alloc] initWithObjects:
                 @{@"title": @"Track Your Run",
                   @"description": @"A smart and personalized run keeper.",
                   @"link": @"https://itunes.apple.com/us/app/track-your-runs/id1086408057?mt=8"},
                 
                 @{@"title": @"Done!",
                   @"description": @"Smart task manager that understands you and help you to schedule your day.",
                   @"link": @"https://itunes.apple.com/us/app/done!-todo-list/id1107140801?mt=8"},
                 
                 @{@"title": @"Toolbox",
                   @"description": @"Calculator, timer, compass and more. Now it supports voice recognition",
                   @"link": @"https://itunes.apple.com/us/app/the-toolbox/id992505214?mt=8"},
                 
                 @{@"title": @"Bounce Up!",
                   @"description": @"A simple elegant game. ",
                   @"link": @"https://itunes.apple.com/us/app/bounce-up!-how-high-can-you/id1033632885?mt=8`"},
                 nil];
    
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
