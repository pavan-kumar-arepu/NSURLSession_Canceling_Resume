//
//  ViewController.m
//  Sessions
//
//  Created by Pavankumar Arepu on 16/02/2016.
//  Copyright © 2016 ppam. All rights reserved.
//

#import "ViewController.h"

@interface ViewController ()

@end

@implementation ViewController


- (NSURLSession *)session
{
    if (!_session) {
        // Create Session Configuration
        NSURLSessionConfiguration *sessionConfiguration = [NSURLSessionConfiguration defaultSessionConfiguration];
        
        // Create Session
        _session = [NSURLSession sessionWithConfiguration:sessionConfiguration delegate:self delegateQueue:nil];
    }
    
    return _session;
}


//-(NSString*)myString
//{
//    return @"Kumar";
//}
//
//-(void)setMyString:(NSString *)myString
//{
//    myString = @"kumar";
//}


- (void)viewDidLoad {
    [super viewDidLoad];
    
    
    // Add Observer
    [self addObserver:self forKeyPath:@"resumeData" options:NSKeyValueObservingOptionNew context:NULL];
    [self addObserver:self forKeyPath:@"downloadTask" options:NSKeyValueObservingOptionNew context:NULL];
    
    // Setup User Interface
    [self.cancelButton setHidden:YES];
    [self.resumeButton setHidden:YES];
    
    
    // Create Download Task
    self.downloadTask = [self.session downloadTaskWithURL:[NSURL URLWithString:@"http://cdn.tutsplus.com/mobile/uploads/2014/01/5a3f1-sample.jpg"]];
    
    // Resume Download Task
    [self.downloadTask resume];

   
}





-(void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context
{
    if ([keyPath isEqualToString:@"resumeData"]) {
        dispatch_async(dispatch_get_main_queue(), ^{
            [self.resumeButton setHidden:(self.resumeData == nil)];
        });
        
    } else if ([keyPath isEqualToString:@"downloadTask"]) {
        dispatch_async(dispatch_get_main_queue(), ^{
            [self.cancelButton setHidden:(self.downloadTask == nil)];
        });
    }
}


- (IBAction)cancelTask:(id)sender
{
    if (!self.downloadTask) return;
    
    // Hide Cancel Button
    [self.cancelButton setHidden:YES];
    
    [self.downloadTask cancelByProducingResumeData:^(NSData *resumeData) {
        if (!resumeData) return;
        [self setResumeData:resumeData];
        [self setDownloadTask:nil];
    }];
}

- (IBAction)resumeTask:(id)sender
{
    if (!self.resumeData) return;
    
    // Hide Resume Button
    [self.resumeButton setHidden:YES];
    
    // Create Download Task
    self.downloadTask = [self.session downloadTaskWithResumeData:self.resumeData];
    
    // Resume Download Task
    [self.downloadTask resume];
    
    // Cleanup
    [self setResumeData:nil];
}
- (void)URLSession:(NSURLSession *)session downloadTask:(NSURLSessionDownloadTask *)downloadTask didFinishDownloadingToURL:(NSURL *)location {
    NSData *data = [NSData dataWithContentsOfURL:location];
    
    dispatch_async(dispatch_get_main_queue(), ^{
        [self.cancelButton setHidden:YES];
        [self.progressView setHidden:YES];
        [self.imageView setImage:[UIImage imageWithData:data]];
    });
    
    // Invalidate Session
    [session finishTasksAndInvalidate];
}

- (void)URLSession:(NSURLSession *)session downloadTask:(NSURLSessionDownloadTask *)downloadTask didResumeAtOffset:(int64_t)fileOffset expectedTotalBytes:(int64_t)expectedTotalBytes

{
    NSLog(@"session:%@",session);
    NSLog(@"downloadTask:%@",downloadTask);
    NSLog(@"fileOffset:%lld",fileOffset);
    NSLog(@"expectedTotalBytes:%lld",expectedTotalBytes);
    
    
}

- (void)URLSession:(NSURLSession *)session downloadTask:(NSURLSessionDownloadTask *)downloadTask didWriteData:(int64_t)bytesWritten totalBytesWritten:(int64_t)totalBytesWritten totalBytesExpectedToWrite:(int64_t)totalBytesExpectedToWrite
{
    float progress = (double)totalBytesWritten / (double)totalBytesExpectedToWrite;
    
    dispatch_async(dispatch_get_main_queue(), ^{
        [self.progressView setProgress:progress];
    });
}




@end
