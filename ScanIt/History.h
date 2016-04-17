//
//  History.h
//  
//
//  Created by Yongyang Nie on 3/18/16.
//
//

#import <UIKit/UIKit.h>
#import <Realm/Realm.h>
#import "ScanItem.h"
#import "PreferenceStore.h"

@import GoogleMobileAds;

@interface History : UIViewController <UICollectionViewDelegate, UICollectionViewDataSource> {
    RLMResults *allItems;
}
@property (weak, nonatomic) IBOutlet GADBannerView *banner;
@property (weak, nonatomic) IBOutlet UICollectionView *collectionView;
@end
