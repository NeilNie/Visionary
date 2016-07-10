//
//  DetailView.m
//  Visionary
//
//  Created by Yongyang Nie on 3/12/16.
//  Copyright © 2016 Yongyang Nie. All rights reserved.
//

#import "detailView.h"

@interface detailView ()

@end

@implementation detailView

#pragma UITableView Delegates

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    NSString *selectedObject = [self.resultArray objectAtIndex:indexPath.row];
    if ([selectedObject containsString:@" "]) {
        ObjectString = [selectedObject stringByReplacingOccurrencesOfString:@" " withString:@"+"];
    }else{
        ObjectString = selectedObject;
    }
    dispatch_async(dispatch_get_main_queue(), ^{
        [self performSegueWithIdentifier:@"ShowWebView" sender:nil];
    });
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.resultArray.count;
}

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}

- (UIView *) tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    
    UIView *headerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, tableView.bounds.size.width, 70)];
    [headerView setBackgroundColor:[UIColor orangeColor]];
    
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(10, -8, 300, 44)];
    label.backgroundColor = [UIColor clearColor];
    label.textColor = [UIColor whiteColor];
    label.font = [UIFont fontWithName:@"Helvetica" size:18];
    label.text = @"Result";
    
    [headerView addSubview:label];
    
    return headerView;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    NSString *string = [self.resultArray objectAtIndex:indexPath.row];
    
    if ([string length] < 40) {
        return 48;
    }else{
        int X = ((int)[string length] / 30) * 30 + 20;
        return X;
    }
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"CellID" forIndexPath:indexPath];
    cell.textLabel.text = [self.resultArray objectAtIndex:indexPath.row];
    cell.backgroundColor = [UIColor clearColor];
    return cell;
}

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
    
    switch (self.pickItem.intValue) {
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
    NSLog(@"type %@", type);
    
    NSError *error;
    NSData *requestData = [NSJSONSerialization dataWithJSONObject:paramsDictionary options:0 error:&error];
    [request setHTTPBody: requestData];
    
    // Run the request on a imageView thread
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        [self runRequestOnimageViewThread: request];
    });
}

- (void)runRequestOnimageViewThread: (NSMutableURLRequest*) request {
    
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
        
        [ActivityIndicator stopAnimating];
        ActivityIndicator.hidden = NO;
        
        // Check for errors
        if (errorObj) {
            
            NSString *errorString1 = @"Error code ";
            NSString *errorCode = [errorObj[@"code"] stringValue];
            NSString *errorString2 = @": ";
            NSString *errorMsg = errorObj[@"message"];
            NSLog(@"%@%@%@%@", errorString1, errorCode, errorString2, errorMsg);
            
        } else {
            
            switch (self.pickItem.intValue) {
                case 0:
                    [self LabelResultWithJson:responseData];
                    [self.ResultTable reloadData];
                    [self showLabel];
                    break;
                case 1:
                    [self FaceResultWithJson:responseData];
                    [self.ResultTable reloadData];
                    [self showLabel];
                    break;
                case 2:
                    [self LandmarkResultWithJson:responseData];
                    [self.ResultTable reloadData];
                    [self showLabel];
                    break;
                case 3:
                    [self TextResultWithJson:responseData];
                    [self.ResultTable reloadData];
                    break;
                case 4:
                    [self LogoResultWithJson:responseData];
                    [self.ResultTable reloadData];
                    [self showLabel];
                    break;
                    
                default:
                    break;
            }
        }
    });
}

#pragma mark - Private

-(void)FaceResultWithJson:(NSDictionary *)responseData{
    
    // Get face annotations
    NSDictionary *faceAnnotations = [responseData objectForKey:@"faceAnnotations"];
    
    if (faceAnnotations != NULL) {
        
        // Get number of faces detected
        NSInteger numPeopleDetected = [faceAnnotations count];
        NSString *peopleStr = [NSString stringWithFormat:@"%lu", (unsigned long)numPeopleDetected];
        NSString *faceStr1 = @"People detected: ";
        [self.resultArray addObject:faceStr1];
        [self.resultArray addObject:peopleStr];
        
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
            NSString *emotionPercentString = [NSString stringWithFormat:@"%@: %@", emotion, percentString];
            [self.resultArray addObject:emotionPercentString];
        }

    }
    [self savetoHistoryWithString:self.resultArray];
}

-(void)LogoResultWithJson:(NSDictionary *)responseData{
    
    NSDictionary *labelAnnotations = [responseData objectForKey:@"logoAnnotations"];
    NSInteger numLabels = [labelAnnotations count];
    
    if (numLabels >= 0) {
        
        for (NSDictionary *label in labelAnnotations) {
            NSString *labelString = [label objectForKey:@"description"];
            [self.resultArray addObject:labelString];
        }
        isWeb = YES;
        self.WebView.enabled = YES;
        
    } else {
        [self.resultArray addObject:@"No result found"];
    }
    [self savetoHistoryWithString:self.resultArray];
}

-(void)LabelResultWithJson:(NSDictionary *)responseData{
    
    // Get label annotations
    NSDictionary *labelAnnotations = [responseData objectForKey:@"labelAnnotations"];
    NSInteger numLabels = [labelAnnotations count];
    
    if (numLabels > 0) {

        for (NSDictionary *label in labelAnnotations) {
            NSString *labelString = [label objectForKey:@"description"];
            [self.resultArray addObject:labelString];
        }
        isWeb = YES;
        self.WebView.enabled = YES;
        
    } else {
        [self.resultArray addObject:@"Sorry, no result found"];
    }
    [self savetoHistoryWithString:self.resultArray];
}

-(void)LandmarkResultWithJson:(NSDictionary *)responseData{
    
    NSDictionary *textAnnotations = [responseData objectForKey:@"landmarkAnnotations"];
    NSInteger numLabels = [textAnnotations count];
    
    if (numLabels > 0) {
        
        for (NSDictionary *label in textAnnotations) {
            NSString *labelString = [label objectForKey:@"description"];
            self.OpenFile.enabled = YES;
            if (labelString) {
                [self.resultArray addObject:labelString];
            }
        }
        isWeb = NO;
        UIImage *btnImage = [UIImage imageNamed:@"pin.png"];
        [self.WebView setImage:btnImage forState:UIControlStateNormal];
        [self.WebView setImage:btnImage forState:UIControlStateSelected];
        
    } else {
        [self.resultArray addObject:@"Sorry, no result found"];
    }
    [self savetoHistoryWithString:self.resultArray];

}
-(void)TextResultWithJson:(NSDictionary *)responseData{
    
    NSArray *textAnnotations = [responseData objectForKey:@"textAnnotations"];
    if (textAnnotations > 0) {
        
        TextViewText = [[textAnnotations objectAtIndex:0] objectForKey:@"description"];
        [self performSegueWithIdentifier:@"ShowTextView" sender:nil];
        self.OpenFile.enabled = YES;
        
    } else {
        [self.resultArray addObject:@"Sorry, no result found"];
    }
    
    [self savetoHistoryWithString:[NSMutableArray arrayWithObject:TextViewText]];
}

-(void)showLabel{
    
    int constraint;
    if (_resultArray.count > 5) {
        constraint = 250;
    }else{
        constraint = 180;
    }
    [UIView animateWithDuration:0.8 animations:^{
        self.LabelConstraint.constant = constraint;
        [self.view layoutIfNeeded];
    }];
}

- (IBAction)search:(id)sender {
    
}

- (IBAction)webview:(id)sender {
    
    dispatch_async(dispatch_get_main_queue(), ^{
        if (isWeb) {
            [self performSegueWithIdentifier:@"ShowWebView" sender:nil];
        }else{
            [self performSegueWithIdentifier:@"ShowMap" sender:nil];
        }
        
    });
}

- (IBAction)listView:(id)sender {
    
    dispatch_async(dispatch_get_main_queue(), ^{
        [self performSegueWithIdentifier:@"ShowTextView" sender:nil];
    });
    
}
- (IBAction)trash:(id)sender {
    
}

-(void)savetoHistoryWithString:(NSMutableArray *)result{
    
    RLMRealm *realm = [RLMRealm defaultRealm];
    [realm beginWriteTransaction];
    ScanItem *item = [[ScanItem alloc] init];
    item.imageData = UIImageJPEGRepresentation(self.imageView.image, 0.7);
    NSLog(@"image size %f", item.imageData.length/1024.0f/1024.0f);
    item.result = [NSKeyedArchiver archivedDataWithRootObject:result];
    [realm addObject:item];
    [realm commitWriteTransaction];
}

-(void)animationActivityIndicator{
    ActivityIndicator = [[PCAngularActivityIndicatorView alloc] initWithActivityIndicatorStyle:PCAngularActivityIndicatorViewStyleLarge];
    ActivityIndicator.color = [UIColor whiteColor];
    ActivityIndicator.center = self.view.center;
    [self.view addSubview:ActivityIndicator];
    [ActivityIndicator startAnimating];

}

#pragma mark - Life Cycle


- (void)viewDidLoad {
    
    [self animationActivityIndicator];
    
    self.LabelConstraint.constant = 0;
    self.ResultTable.backgroundColor = [UIColor clearColor];
    self.WebView.enabled = NO;
    self.OpenFile.enabled = NO;
    
    self.imageView.image = self.image;
    NSString *binaryImageData = [self base64EncodeImage:self.image];
    [self createRequest:binaryImageData];
    self.resultArray = [NSMutableArray array];
    
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
    // Do any additional setup after loading the view, typically from a nib.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


#pragma mark - Navigation
 
 // In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    
    if ([[segue destinationViewController] isKindOfClass:[WebPage class]]) {
        WebPage *destination =(WebPage *)segue.destinationViewController;
        destination.urlString = ObjectString;
    }else if ([[segue destinationViewController] isKindOfClass:[TextView class]]){
        TextView *destination =(TextView *)segue.destinationViewController;
        destination.text = TextViewText;
    }
}

@end
