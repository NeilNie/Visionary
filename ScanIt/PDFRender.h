//
//  PDFRender.h
//  Visionary
//
//  Created by Yongyang Nie on 7/12/16.
//  Copyright © 2016 Yongyang Nie. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreGraphics/CoreGraphics.h>
#import <CoreText/CoreText.h>
#import "ReaderViewController.h"

@protocol PDFRenderDelegate <NSObject>

@end

@interface PDFRender : NSObject <ReaderViewControllerDelegate>

@property (strong, nonatomic) NSString *pdfName;
@property (strong, nonatomic) UIViewController *parentVC;
@property (strong, nonatomic) NSString *pdfContent;
@property (nonatomic, assign) id delegate;

- (instancetype)initWithName:(NSString *)name content:(NSString *)content;
-(void)generatePDF;
-(void)showPDF;

@end
