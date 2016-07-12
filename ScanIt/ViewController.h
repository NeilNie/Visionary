//
//  ViewController.h
//  ScanIt
//
//  Created by Yongyang Nie on 3/11/16.
//  Copyright © 2016 Yongyang Nie. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <Realm/Realm.h>
#import <MaterialControls/MDButton.h>
#import "ScanItem.h"
#import "PCAngularActivityIndicatorView.h"
#import "detailView.h"
#import "PreferenceStore.h"
#import "AAPLPreviewView.h"

@import GoogleMobileAds;
@import Photos;

@interface ViewController : UIViewController <AVCaptureMetadataOutputObjectsDelegate, MDButtonDelegate>{
    
    PCAngularActivityIndicatorView *ActivityIndicator;
    NSArray *array;
    UIImage *pickedImage;
}
// For use in the storyboards.
@property (weak, nonatomic) IBOutlet UILabel *lblStatus;
@property (nonatomic, weak) IBOutlet UIButton *cameraButton;
@property (weak, nonatomic) IBOutlet MDButton *btMore;
@property (weak, nonatomic) IBOutlet MDButton *btFace;
@property (weak, nonatomic) IBOutlet MDButton *btLabel;
@property (weak, nonatomic) IBOutlet MDButton *btText;
@property (weak, nonatomic) IBOutlet MDButton *btQR;
@property (weak, nonatomic) IBOutlet UILabel *indicationLb;

@property (nonatomic, weak) IBOutlet AAPLPreviewView *previewView;
@property (nonatomic, weak) IBOutlet UILabel *cameraUnavailableLabel;
@property (nonatomic, weak) IBOutlet UIButton *resumeButton;
@property (nonatomic, weak) IBOutlet UIButton *stillButton;

@end

