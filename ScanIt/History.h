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

@interface History : UIViewController <UICollectionViewDelegate, UICollectionViewDataSource> {
    RLMResults *allItems;
}
@property (weak, nonatomic) IBOutlet UICollectionView *collectionView;
@end
