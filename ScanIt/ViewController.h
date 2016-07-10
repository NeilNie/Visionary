//
//  ViewController.h
//  ScanIt
//
//  Created by Yongyang Nie on 3/11/16.
//  Copyright © 2016 Yongyang Nie. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <Realm/Realm.h>
#import "ScanItem.h"
#import "PCAngularActivityIndicatorView.h"
#import "detailView.h"
#import "PreferenceStore.h"
#import "AAPLPreviewView.h"

@import GoogleMobileAds;
@import Photos;

@interface ViewController : UIViewController <AVCaptureMetadataOutputObjectsDelegate>{
    
    PCAngularActivityIndicatorView *ActivityIndicator;
    NSArray *array;
    UIImage *pickedImage;
}
// For use in the storyboards.
@property (nonatomic, weak) IBOutlet AAPLPreviewView *previewView;
@property (nonatomic, weak) IBOutlet UILabel *cameraUnavailableLabel;
@property (nonatomic, weak) IBOutlet UIButton *resumeButton;
@property (nonatomic, weak) IBOutlet UIButton *stillButton;

@end

