//
//  ViewController.h
//  ScanIt
//
//  Created by Yongyang Nie on 3/11/16.
//  Copyright © 2016 Yongyang Nie. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <Realm/Realm.h>
#import "iOSUILib/MDButton.h"
#import "PCAngularActivityIndicatorView.h"
#import "DetailViewController.h"
#import "PreferenceViewController.h"
#import "AAPLPreviewView.h"

@import GoogleMobileAds;
@import Photos;

@interface ViewController : UIViewController <AVCaptureMetadataOutputObjectsDelegate, UIImagePickerControllerDelegate, UINavigationControllerDelegate, MDButtonDelegate>{
    
    PCAngularActivityIndicatorView *ActivityIndicator;
    NSArray *array;
    UIImage *pickedImage;
    UIImage *imagePath;
}
// For use in the storyboards.
@property (nonatomic, weak) IBOutlet UIButton *cameraButton;
@property (weak, nonatomic) IBOutlet MDButton *btMore;
@property (weak, nonatomic) IBOutlet MDButton *btFace;
@property (weak, nonatomic) IBOutlet MDButton *btLabel;
@property (weak, nonatomic) IBOutlet MDButton *btText;
@property (weak, nonatomic) IBOutlet MDButton *btQR;
@property (weak, nonatomic) IBOutlet UILabel *indicationLb;

@property (nonatomic, weak) IBOutlet AAPLPreviewView *previewView;
@property (nonatomic, weak) IBOutlet UIButton *resumeButton;
@property (nonatomic, weak) IBOutlet UIButton *stillButton;

@end
