//
//  PreferenceStore.h
//  Visionary
//
//  Created by Yongyang Nie on 3/12/16.
//  Copyright © 2016 Yongyang Nie. All rights reserved.
//

#import <StoreKit/StoreKit.h>
#import <UIKit/UIKit.h>

BOOL areAdsRemoved;

@interface PreferenceViewController : UIViewController <SKProductsRequestDelegate, SKPaymentTransactionObserver, UITableViewDataSource, UITableViewDelegate>

@property (strong, nonatomic) NSMutableArray *apps;

@property (weak, nonatomic) IBOutlet UITableView *table;

- (IBAction)tapsRemoveAds;

@end
