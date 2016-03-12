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

#pragma mark - Google Cloud Vision API

static NSString *const API_Key = @"AIzaSyCUCwQG6OgMc8CGn308Ak7mOVfSz4GCAew";
static NSString *const Google_URL = @"https://vision.googleapis.com/v1/images:annotate?key=";

- (UIImage *) resizeImage:(UIImage*)image toSize:(CGSize)newSize {
    
    UIGraphicsBeginImageContext(newSize);
    [image drawInRect:CGRectMake(0, 0, newSize.width, newSize.height)];
    UIImage *newImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return newImage;
}

- (NSString *) base64EncodeImage: (UIImage*)image {
    
    NSData *imagedata = UIImagePNGRepresentation(image);
    
    // Resize the image if it exceeds the 2MB API limit
    if ([imagedata length] > 2097152) {
        CGSize oldSize = [image size];
        CGSize newSize = CGSizeMake(800, oldSize.height / oldSize.width * 800);
        image = [self resizeImage: image toSize: newSize];
        imagedata = UIImagePNGRepresentation(image);
    }
    
    NSString *base64String = [imagedata base64EncodedStringWithOptions:NSDataBase64EncodingEndLineWithCarriageReturn];
    return base64String;
}

- (void) createRequest: (NSString*)imageData {
    
    // Create our request URL
    NSString *requestString = [NSString stringWithFormat:@"%@%@", Google_URL, API_Key];
    
    NSURL *url = [NSURL URLWithString: requestString];
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:url];
    [request setHTTPMethod: @"POST"];
    [request addValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
    [request addValue:[[NSBundle mainBundle] bundleIdentifier] forHTTPHeaderField:@"X-Ios-Bundle-Identifier"];
    
    // Build our API request
    NSString *type;
    
    switch (pickedItem) {
        case 0:
            type = @"LABEL_DETECTION";
            break;
        case 1:
            type = @"FACE_DETECTION";
            break;
        case 2:
            type = @"LANDMARK_DETECTION";
            break;
        case 3:
            type = @"TEXT_DETECTION";
            break;
        case 4:
            type = @"LOGO_DETECTION";
            break;
            
        default:
            break;
    }
    
    NSDictionary *paramsDictionary =
    @{@"requests":@[
              @{@"image":
                    @{@"content":imageData},
                @"features":@[
                        @{@"type":[NSString stringWithFormat:@"%@", type],
                          @"maxResults":@10}]}]};
    
    NSError *error;
    NSData *requestData = [NSJSONSerialization dataWithJSONObject:paramsDictionary options:0 error:&error];
    [request setHTTPBody: requestData];
    
    // Run the request on a background thread
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        [self runRequestOnBackgroundThread: request];
    });
}

- (void)runRequestOnBackgroundThread: (NSMutableURLRequest*) request {
    
    NSURLSessionDataTask *task = [[NSURLSession sharedSession] dataTaskWithRequest:request completionHandler:^ (NSData *data, NSURLResponse *response, NSError *error) {
        [self analyzeResults:data];
    }];
    [task resume];
}

- (void)analyzeResults: (NSData*)dataToParse {
    
    // Update UI on the main thread
    dispatch_async(dispatch_get_main_queue(), ^{
        
        NSError *e = nil;
        NSDictionary *json = [NSJSONSerialization JSONObjectWithData:dataToParse options:kNilOptions error:&e];
        NSArray *responses = [json objectForKey:@"responses"];
        NSDictionary *responseData = [responses objectAtIndex: 0];
        NSDictionary *errorObj = [json objectForKey:@"error"];
        NSLog(@"%@", responses);
        [self.ActivityIndicator stopAnimating];
        
        // Check for errors
        if (errorObj) {
            
            NSString *errorString1 = @"Error code ";
            NSString *errorCode = [errorObj[@"code"] stringValue];
            NSString *errorString2 = @": ";
            NSString *errorMsg = errorObj[@"message"];
            self.ResultLabel.text = [NSString stringWithFormat:@"%@%@%@%@", errorString1, errorCode, errorString2, errorMsg];
            
        } else {
            
            switch (pickedItem) {
                case 0:
                    self.ResultLabel.text = [self LabelResultWithJson:responseData];
                    break;
                case 1:
                    
                    break;
                case 2:
                    
                    break;
                case 3:
                    
                    break;
                case 4:
                    
                    break;
                    
                default:
                    break;
            }
        }
    });
    
}

-(NSString *)FaceResultWithJson:(NSDictionary *)responseData{
    
    // Get face annotations
    NSDictionary *faceAnnotations = [responseData objectForKey:@"faceAnnotations"];
    NSString *result;
    
    if (faceAnnotations != NULL) {
        
        // Get number of faces detected
        NSInteger numPeopleDetected = [faceAnnotations count];
        NSString *peopleStr = [NSString stringWithFormat:@"%lu", (unsigned long)numPeopleDetected];
        NSString *faceStr1 = @"People detected: ";
        NSString *faceStr2 = @"\n\nEmotions detected:\n";
        self.ResultLabel.text = [NSString stringWithFormat:@"%@%@%@", faceStr1, peopleStr, faceStr2];
        
        NSArray *emotions = @[@"joy", @"sorrow", @"surprise", @"anger"];
        NSMutableDictionary *emotionTotals = [NSMutableDictionary dictionaryWithObjects:@[@0.0,@0.0,@0.0,@0.0]forKeys:@[@"sorrow",@"joy",@"surprise",@"anger"]];
        NSDictionary *emotionLikelihoods = @{@"VERY_LIKELY": @0.9, @"LIKELY": @0.75, @"POSSIBLE": @0.5, @"UNLIKELY": @0.25, @"VERY_UNLIKELY": @0.0};
        
        // Sum all detected emotions
        for (NSDictionary *personData in faceAnnotations) {
            for (NSString *emotion in emotions) {
                NSString *lookup = [emotion stringByAppendingString:@"Likelihood"];
                NSString *result = [personData objectForKey:lookup];
                double newValue = [emotionLikelihoods[result] doubleValue] + [emotionTotals[emotion] doubleValue];
                NSNumber *tempNumber = [[NSNumber alloc] initWithDouble:newValue];
                [emotionTotals setValue:tempNumber forKey:emotion];
            }
        }
        
        // Get emotion likelihood as a % and display it in the UI
        for (NSString *emotion in emotionTotals) {
            double emotionSum = [emotionTotals[emotion] doubleValue];
            double totalPeople = [faceAnnotations count];
            double likelihoodPercent = emotionSum / totalPeople;
            NSString *percentString = [[NSString alloc] initWithFormat:@"%2.0f%%",(likelihoodPercent*100)];
            NSString *emotionPercentString = [NSString stringWithFormat:@"%@%@%@%@", emotion, @": ", percentString, @"\r\n"];
            result = [result stringByAppendingString:emotionPercentString];
        }
        
        return result;
    } else {
        return @"Sorry, no faces found";
    }
}

-(NSString *)LogoResultWithJson:(NSDictionary *)responseData{
    
    return nil;
}

-(NSString *)LabelResultWithJson:(NSDictionary *)responseData{
    
    // Get label annotations
    NSDictionary *labelAnnotations = [responseData objectForKey:@"labelAnnotations"];
    NSInteger numLabels = [labelAnnotations count];
    NSMutableArray *labels = [[NSMutableArray alloc] init];
    
    if (numLabels > 0) {
        NSString *labelResultsText = @"Labels found: ";
        for (NSDictionary *label in labelAnnotations) {
            NSString *labelString = [label objectForKey:@"description"];
            [labels addObject:labelString];
        }
        for (NSString *label in labels) {
            // if it's not the last item add a comma
            if (labels[labels.count - 1] != label) {
                NSString *commaString = [label stringByAppendingString:@", "];
                labelResultsText = [labelResultsText stringByAppendingString:commaString];
            } else {
                labelResultsText = [labelResultsText stringByAppendingString:label];
            }
        }
        return labelResultsText;
    } else {
        return @"No labels found";
    }
}

-(NSString *)LandmarkResultWithJson:(NSDictionary *)responseData{
    
    return nil;
}

-(NSString *)TextResultWithJson:(NSDictionary *)responseData{
    
    return nil;
}

-(void)tap:(UITapGestureRecognizer *)gesture{
    
    NSLog(@"taped");
    
    self.TapLabel.hidden = YES;
    self.TapImage.hidden = YES;
    self.pickerView.hidden = YES;
    pickedItem = self.pickerView.selectedItem;
    
    DBCameraContainerViewController *cameraContainer = [[DBCameraContainerViewController alloc] initWithDelegate:self];
    [cameraContainer setFullScreenMode];
    UINavigationController *nav = [[UINavigationController alloc] initWithRootViewController:cameraContainer];
    [nav setNavigationBarHidden:YES];
    [self presentViewController:nav animated:YES completion:nil];
}

#pragma mark - AKPickerView Delegate

- (NSUInteger)numberOfItemsInPickerView:(AKPickerView *)pickerView{
    
    return array.count;
}

- (NSString *)pickerView:(AKPickerView *)pickerView titleForItem:(NSInteger)item{
    
    return array[item];
}

- (void)pickerView:(AKPickerView *)pickerView didSelectItem:(NSInteger)item{
    
}

#pragma mark - DBCamera Delegate

- (void)camera:(id)cameraViewController didFinishWithImage:(UIImage *)image withMetadata:(NSDictionary *)metadata{
    
    self.background.contentMode = UIViewContentModeScaleAspectFit;
    self.background.image = image;
    
    self.ActivityIndicator.color = [UIColor whiteColor];
    [self.ActivityIndicator startAnimating];
    
    [self dismissCamera:cameraViewController];
}

- (void) dismissCamera:(id)cameraViewController{
    [self.presentedViewController dismissViewControllerAnimated:YES completion:nil];
    [cameraViewController restoreFullScreenMode];
}

#pragma mark - Life Cycle

- (void)viewDidLoad {
    
    self.pickerView.delegate = self;
    self.pickerView.dataSource = self;
    
    self.pickerView.font = [UIFont fontWithName:@"HelveticaNeue-Light" size:21];
    self.pickerView.highlightedFont = [UIFont fontWithName:@"HelveticaNeue" size:21];
    self.pickerView.interitemSpacing = 20;
    self.pickerView.fisheyeFactor = 0.001;
    self.pickerView.pickerViewStyle = AKPickerViewStyle3D;
    self.pickerView.maskDisabled = false;
    array = [[NSArray alloc] initWithObjects:@"Label", @"Face", @"Landmark", @"Text", @"Logo", nil];
    
    self.constraint.constant = 0;
    self.LabelConstraint.constant = 0;
    
    UITapGestureRecognizer *singleFingerTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tap:)];
    [self.background addGestureRecognizer:singleFingerTap];
    
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
