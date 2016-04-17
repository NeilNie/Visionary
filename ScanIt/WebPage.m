//
//  WebPage.m
//  Visionary
//
//  Created by Yongyang Nie on 3/13/16.
//  Copyright © 2016 Yongyang Nie. All rights reserved.
//

#import "WebPage.h"

@interface WebPage ()

@end

@implementation WebPage

- (void)viewDidLoad {
    
    NSURL *url;
    if ([self.urlString containsString:@"www"]) {
        url = [NSURL URLWithString:self.urlString];
    }else{
        url = [NSURL URLWithString:[NSString stringWithFormat:@"https://www.google.com/#q=%@", self.urlString]];
    }
    NSURLRequest *request = [NSURLRequest requestWithURL:url];
    [self.webView loadRequest:request];
    
    [super viewDidLoad];
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
