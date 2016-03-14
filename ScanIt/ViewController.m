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

#pragma mark - UICollectionView

-(void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    
}

-(UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    
    return nil;
}

-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    
    return 5;
}

#pragma mark - Private

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

-(void)tap:(UITapGestureRecognizer *)gesture{
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

- (void)viewDidLoad {
    
    UITapGestureRecognizer *singleFingerTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tap:)];
    [self.background addGestureRecognizer:singleFingerTap];
    
    self.pickerView.font = [UIFont fontWithName:@"HelveticaNeue-Light" size:21];
    self.pickerView.highlightedFont = [UIFont fontWithName:@"HelveticaNeue" size:21];
    self.pickerView.interitemSpacing = 20;
    self.pickerView.fisheyeFactor = 0.001;
    self.pickerView.pickerViewStyle = AKPickerViewStyle3D;
    self.pickerView.maskDisabled = false;
    self.pickerView.delegate = self;
    self.pickerView.dataSource = self;
    array = [[NSArray alloc] initWithObjects:@"Label", @"Face", @"Landmark", @"Text", @"Logo", nil];
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
