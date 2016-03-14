//
//  ScanItem.h
//  Visionary
//
//  Created by Yongyang Nie on 3/13/16.
//  Copyright © 2016 Yongyang Nie. All rights reserved.
//

#import <Realm/Realm.h>

@interface ScanItem : RLMObject

@end

// This protocol enables typed collections. i.e.:
// RLMArray<ScanItem>
RLM_ARRAY_TYPE(ScanItem)
