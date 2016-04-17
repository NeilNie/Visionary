//
//  WebPage.h
//  Visionary
//
//  Created by Yongyang Nie on 3/13/16.
//  Copyright © 2016 Yongyang Nie. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface WebPage : UIViewController

@property (nonatomic, strong) NSString *urlString;
@property (weak, nonatomic) IBOutlet UIWebView *webView;

@end
