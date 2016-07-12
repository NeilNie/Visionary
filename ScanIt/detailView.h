//
//  DetailView.h
//  Visionary
//
//  Created by Yongyang Nie on 3/12/16.
//  Copyright © 2016 Yongyang Nie. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PCAngularActivityIndicatorView.h"
#import "ScanItem.h"
#import "WebPage.h"
#import "TextView.h"
#import "PreferenceStore.h"
#import "ResultTableViewCell.h"

@interface DetailView : UIViewController <UITableViewDelegate, UITableViewDataSource>{
    
    PCAngularActivityIndicatorView *ActivityIndicator;
    NSString *ObjectString;
    NSString *TextViewText;
    
    BOOL isWeb;
}

@property (strong, nonatomic) UIImage *image;
@property NSUInteger pickItem;
@property (strong, nonatomic) NSMutableArray *resultArray;
@property (strong, nonatomic) NSMutableArray *percentArray;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *LabelConstraint;
@property (weak, nonatomic) IBOutlet UITableView *ResultTable;
@property (weak, nonatomic) IBOutlet UIImageView *imageView;
@property (weak, nonatomic) IBOutlet UIButton *OpenFile;
@property (weak, nonatomic) IBOutlet UIButton *WebView;

@end
