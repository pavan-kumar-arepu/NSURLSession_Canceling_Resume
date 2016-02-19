//
//  ViewController.h
//  Sessions
//
//  Created by Pavankumar Arepu on 16/02/2016.
//  Copyright © 2016 ppam. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ViewController : UIViewController<NSURLSessionDelegate, NSURLSessionDownloadDelegate>
{
     NSURLSession *_session;
}

@property (strong, nonatomic) NSURLSessionDownloadTask *downloadTask;
@property (strong, nonatomic) NSData *resumeData;

@property(nonatomic,strong) NSString *myString;




@property (weak, nonatomic) IBOutlet UIImageView *imageView;
@property (weak, nonatomic) IBOutlet UIProgressView *progressView;

@property (weak, nonatomic) IBOutlet UIButton *cancelButton;
@property (weak, nonatomic) IBOutlet UIButton *resumeButton;


- (IBAction)cancelTask:(id)sender;
- (IBAction)resumeTask:(id)sender;


@end

