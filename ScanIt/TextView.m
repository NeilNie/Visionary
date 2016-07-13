//
//  TextView.m
//  Visionary
//
//  Created by Yongyang Nie on 3/13/16.
//  Copyright © 2016 Yongyang Nie. All rights reserved.
//

#import "TextView.h"

@interface TextView ()

@end

@implementation TextView

-(void)dismissReaderViewController:(ReaderViewController *)viewController{
    
    [self dismissViewControllerAnimated:YES completion:nil];
}

-(IBAction)generatePDF:(id)sender{

    PDFRender *render = [[PDFRender alloc] initWithName:@"userpdf" content:self.text];
    render.delegate = self;
    render.parentVC = self;
    [render generatePDF];
    [render showPDF];
}

- (IBAction)copy:(id)sender {

    UIPasteboard *pasteboard = [UIPasteboard generalPasteboard];
    pasteboard.string = self.text;
    
    UIAlertController* alert = [UIAlertController alertControllerWithTitle:@"Great!"
                                                                   message:@"Saved to pasteboard"
                                                            preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction* defaultAction = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleCancel
                                                          handler:^(UIAlertAction * action) {}];
    [alert addAction:defaultAction];
    [self presentViewController:alert animated:YES completion:nil];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.textView.text = self.text;
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
