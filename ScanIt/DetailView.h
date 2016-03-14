//
//  DetailView.h
//  Visionary
//
//  Created by Yongyang Nie on 3/12/16.
//  Copyright © 2016 Yongyang Nie. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <AKPickerView/AKPickerView.h>
#import <DBCamera/DBCameraViewController.h>
#import <DBCamera/DBCameraContainerViewController.h>
#import <DBCamera/DBCameraLibraryViewController.h>
#import "PCAngularActivityIndicatorView.h"
#import "WebPage.h"
#import "TextView.h"

@interface DetailView : UIViewController <UITableViewDelegate, UITableViewDataSource>{
    
    PCAngularActivityIndicatorView *ActivityIndicator;
    NSUInteger pickedItem;
    NSString *ObjectString;
    NSString *TextViewText;
    
    BOOL isWeb;
}

@property (strong, nonatomic) UIImage *image;
@property (strong, nonatomic) NSNumber *pickItem;
@property (strong, nonatomic) NSMutableArray *resultArray;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *LabelConstraint;
@property (weak, nonatomic) IBOutlet UITableView *ResultTable;
@property (weak, nonatomic) IBOutlet UIImageView *imageView;
@property (weak, nonatomic) IBOutlet UIButton *OpenFile;
@property (weak, nonatomic) IBOutlet UIButton *WebView;

@end
