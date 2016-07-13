//
//  TextView.h
//  Visionary
//
//  Created by Yongyang Nie on 3/13/16.
//  Copyright © 2016 Yongyang Nie. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PDFRender.h"

@interface TextView : UIViewController <PDFRenderDelegate>

@property (nonatomic, strong) NSString *text;
@property (weak, nonatomic) IBOutlet UITextView *textView;

@end
