//
//  ImageDownloadManager.m
//  MailTest
//
//  Created by a.korenev on 20.08.15.
//  Copyright © 2015 alexkorenev. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "ImageDownloadManager.h"
#import "ImageCache.h"

@interface ImageDownloadManager ()

@property (strong, nonatomic) NSURLSession *session;

@end

@implementation ImageDownloadManager

- (instancetype)init {
    if (self = [super init]) {
        NSURLSessionConfiguration *config = [NSURLSessionConfiguration defaultSessionConfiguration];
        _session = [NSURLSession sessionWithConfiguration:config];
    }
    
    return self;
}

+ (instancetype)sharedManager {
    static ImageDownloadManager *sharedManager;
    
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedManager = [[ImageDownloadManager alloc] init];
    });
    
    return sharedManager;
}

- (NSOperation *)getImageByUrl:(NSString *)url withCompletionBlock:(void (^)(UIImage *))completionBlock {
    NSBlockOperation *operation = [[NSBlockOperation alloc] init];
    __weak NSBlockOperation *wOperation = operation;
    [operation addExecutionBlock:^{
        if ([wOperation isCancelled]) {
            completionBlock(nil);
            return;
        }
        [[ImageCache sharedCache] getImageByUrl:url
                            withCompletionBlock:^(UIImage *image) {
                                if (image) {
                                    completionBlock(image);
                                }
                                else {
                                    if ([wOperation isCancelled]) {
                                        completionBlock(nil);
                                        return;
                                    }
                                    NSURLSessionDataTask *task = [self.session dataTaskWithURL:[NSURL URLWithString:url]
                                                 completionHandler:^(NSData * __nullable data, NSURLResponse * __nullable response, NSError * __nullable error) {
                                                     if (data) {
                                                         dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
                                                             UIImage *image = [UIImage imageWithData:data];
                                                             if (image) {
                                                                 [[ImageCache sharedCache] saveImage:image
                                                                                             withUrl:url
                                                                                           onSuccess:^{} onFailure:^(NSError *error) {}];
                                                             }
                                                             completionBlock(image);
                                                         });
                                                     }
                                                     else {
                                                         completionBlock(nil);
                                                     }
                                                 }];
                                    [task resume];
                                }
                            }];
    }];
    
    return operation;
}

@end
