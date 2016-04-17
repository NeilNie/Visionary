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

@interface PreferenceStore : UIViewController <SKProductsRequestDelegate, SKPaymentTransactionObserver>{
    
}
- (IBAction)tapsRemoveAds;
@end
