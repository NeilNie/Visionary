//
//  History.h
//  Visionary
//
//  Created by Yongyang Nie on 9/15/16.
//  Copyright © 2016 Yongyang Nie. All rights reserved.
//

#import <Realm/Realm.h>

@interface History : RLMObject

@property NSString *imagePath;
@property NSMutableArray *content;
@property NSMutableArray *percentage;
@property NSString *notes;


@end

// This protocol enables typed collections. i.e.:
// RLMArray<History>
RLM_ARRAY_TYPE(History)
