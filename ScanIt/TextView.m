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
- (IBAction)copy:(id)sender {

    UIPasteboard *pasteboard = [UIPasteboard generalPasteboard];
    pasteboard.string = self.text;
    
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Saved to pasteboard"
                                                    message:nil
                                                   delegate:self
                                          cancelButtonTitle:@"OK"
                                          otherButtonTitles:nil];
    [alert show];
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
