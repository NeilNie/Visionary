//
//  GenerateQR.m
//  Visionary
//
//  Created by Yongyang Nie on 3/14/16.
//  Copyright © 2016 Yongyang Nie. All rights reserved.
//

#import "GenerateQR.h"

@interface GenerateQR ()

@end

@implementation GenerateQR

- (IBAction)delete:(id)sender {
    
    [UIView animateWithDuration:0.5 animations:^{
        self.constraint.constant = 0;
        [self.view layoutIfNeeded];
    }];
    self.textfield.text = @"";
}

- (IBAction)save:(id)sender {
    
    UIImageWriteToSavedPhotosAlbum(self.image.image, nil, nil, nil);    
    UIAlertController* alert = [UIAlertController alertControllerWithTitle:@"Great!"
                                                                   message:@"QR code saved"
                                                            preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction* defaultAction = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleCancel
                                                          handler:^(UIAlertAction * action) {}];
    [alert addAction:defaultAction];
    [self presentViewController:alert animated:YES completion:nil];
}

-(IBAction)generate:(id)sender{
    
    self.image.image = [self createQRForString:self.textfield.text];
    [UIView animateWithDuration:0.5 animations:^{
        self.constraint.constant = 300;
        [self.view layoutIfNeeded];
    }];
    self.saveButton.enabled = YES;
}

- (UIImage *)createQRForString:(NSString *)qrString {
    
    CIFilter *filter = [CIFilter filterWithName:@"CIQRCodeGenerator"];
    
    [filter setDefaults];
    
    NSData *data = [qrString dataUsingEncoding:NSUTF8StringEncoding];
    [filter setValue:data forKey:@"inputMessage"];
    
    CIImage *outputImage = [filter outputImage];
    
    CIContext *context = [CIContext contextWithOptions:nil];
    CGImageRef cgImage = [context createCGImage:outputImage
                                       fromRect:[outputImage extent]];
    
    UIImage *image = [UIImage imageWithCGImage:cgImage
                                         scale:1.
                                   orientation:UIImageOrientationUp];
    
    // Resize without interpolating
    UIImage *resized = [self resizeImage:image
                             withQuality:kCGInterpolationNone rate:50.0];
    CGImageRelease(cgImage);
    
    return resized;
    
}

- (UIImage *)resizeImage:(UIImage *)image
             withQuality:(CGInterpolationQuality)quality
                    rate:(CGFloat)rate
{
    UIImage *resized = nil;
    CGFloat width = image.size.width * rate;
    CGFloat height = image.size.height * rate;
    
    UIGraphicsBeginImageContext(CGSizeMake(width, height));
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextSetInterpolationQuality(context, quality);
    [image drawInRect:CGRectMake(0, 0, width, height)];
    resized = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    return resized;
}


- (void)viewDidLoad {
    
    [super viewDidLoad];
    self.saveButton.enabled = NO;
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
