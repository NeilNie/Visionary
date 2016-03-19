//
//  ViewController.h
//  ScanIt
//
//  Created by Yongyang Nie on 3/11/16.
//  Copyright © 2016 Yongyang Nie. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <AKPickerView/AKPickerView.h>
#import <DBCamera/DBCameraViewController.h>
#import <DBCamera/DBCameraContainerViewController.h>
#import <DBCamera/DBCameraLibraryViewController.h>
#import <Realm/Realm.h>
#import "ScanItem.h"
#import "PCAngularActivityIndicatorView.h"
#import "DetailView.h"

@interface ViewController : UIViewController <AKPickerViewDelegate, AKPickerViewDataSource, DBCameraViewControllerDelegate>{
    
    PCAngularActivityIndicatorView *ActivityIndicator;
    NSArray *array;
    UIImage *pickedImage;
}

@property (weak, nonatomic) IBOutlet AKPickerView *pickerView;
@property (weak, nonatomic) IBOutlet UILabel *label;
@end

