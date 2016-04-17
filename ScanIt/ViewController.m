//
//  ViewController.m
//  ScanIt
//
//  Created by Yongyang Nie on 3/11/16.
//  Copyright © 2016 Yongyang Nie. All rights reserved.
//

#import "ViewController.h"

@interface ViewController ()

@end

@implementation ViewController

#pragma mark - Private

-(void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    
    [self openCamera];
}

-(void)openCamera{

    DBCameraContainerViewController *cameraContainer = [[DBCameraContainerViewController alloc] initWithDelegate:self];
    [cameraContainer setFullScreenMode];
    UINavigationController *nav = [[UINavigationController alloc] initWithRootViewController:cameraContainer];
    [nav setNavigationBarHidden:YES];
    [self presentViewController:nav animated:YES completion:nil];
    NSLog(@"%lu", (unsigned long)self.pickerView.selectedItem);
}

-(IBAction)TakePicture:(id)sender{
    [self openCamera];
}

#pragma mark - DBCamera Delegate

- (void)camera:(id)cameraViewController didFinishWithImage:(UIImage *)image withMetadata:(NSDictionary *)metadata{

    pickedImage = image;
    [self dismissCamera:cameraViewController];
    [self performSegueWithIdentifier:@"ShowDetail" sender:nil];
}

- (void) dismissCamera:(id)cameraViewController{
    
    [self.presentedViewController dismissViewControllerAnimated:YES completion:nil];
    [cameraViewController restoreFullScreenMode];
}

#pragma mark - AKPickerView Delegate

- (NSUInteger)numberOfItemsInPickerView:(AKPickerView *)pickerView{
    
    return array.count;
}

- (NSString *)pickerView:(AKPickerView *)pickerView titleForItem:(NSInteger)item{
    
    return array[item];
}

-(void)pickerView:(AKPickerView *)pickerView didSelectItem:(NSInteger)item{
    
    switch (item) {
        case 0:
            self.label.text = @"Label detection is the most basic function. It gives you keywords about your image.";
            break;
        case 1:
            self.label.text = @"Face detection detects the number of people and overall emtions in your image.";
            break;
        case 2:
            self.label.text = @"Lankmark detection tells you the name of the landmark. Note: the landmark has to make up to 3/4 of your image";
            break;
        case 3:
            self.label.text = @"Text detection converts all the text in your image and turn them into the digital format";
            break;
        case 4:
            self.label.text = @"Logo detection tells you the name of the logo. Note: the logo has to make up to 3/4 of your image and you can only scan one logo at a time";
            break;
            
        default:
            break;
    }
}

- (void)viewDidLoad {
    
    self.pickerView.font = [UIFont fontWithName:@"HelveticaNeue-Light" size:21];
    self.pickerView.highlightedFont = [UIFont fontWithName:@"HelveticaNeue" size:21];
    self.pickerView.interitemSpacing = 20;
    self.pickerView.fisheyeFactor = 0.001;
    self.pickerView.pickerViewStyle = AKPickerViewStyle3D;
    self.pickerView.maskDisabled = false;
    self.pickerView.delegate = self;
    self.pickerView.dataSource = self;
    array = [[NSArray alloc] initWithObjects:@"Label", @"Face", @"Landmark", @"Text", @"Logo", nil];
    
    areAdsRemoved = [[NSUserDefaults standardUserDefaults] boolForKey:@"areAdsRemoved"];
    [[NSUserDefaults standardUserDefaults] synchronize];
    if (!areAdsRemoved) {
        self.banner.adUnitID = @"ca-app-pub-7942613644553368/1563136736";
        self.banner.rootViewController = self;
        [self.banner loadRequest:[GADRequest request]];
    }else{
        self.banner.hidden = YES;
    }
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Navigation

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    
    if ([[segue destinationViewController] isKindOfClass:[DetailView class]]) {
        DetailView *destination =(DetailView *)segue.destinationViewController;
        destination.image = pickedImage;
        destination.pickItem = [NSNumber numberWithUnsignedInteger:self.pickerView.selectedItem];
    }
}

@end
