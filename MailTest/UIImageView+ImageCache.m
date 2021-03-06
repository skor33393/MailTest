//
//  UIImageView+ImageCache.m
//  MailTest
//
//  Created by a.korenev on 20.08.15.
//  Copyright © 2015 alexkorenev. All rights reserved.
//

#import "UIImageView+ImageCache.h"
#import "ImageDownloadManager.h"

#import <objc/runtime.h>

@implementation UIImageView (ImageCache)

static char kAssociatedObjectKey;
static char kOperationQueueKey;

- (NSOperationQueue *)operationQueue {
    NSOperationQueue *opQueue = objc_getAssociatedObject(self, &kOperationQueueKey);
    if (!opQueue) {
        opQueue = [[NSOperationQueue alloc] init];
        opQueue.maxConcurrentOperationCount = 1;
        objc_setAssociatedObject(self, &kOperationQueueKey, opQueue, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    }
    
    return opQueue;
}

- (void)setImageWithUrl:(NSString *)url placeholderImage:(UIImage *)placeholder {
    objc_setAssociatedObject(self, &kAssociatedObjectKey, url, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    
    __weak typeof(self)wSelf = self;
    
    dispatch_async(dispatch_get_main_queue(), ^{
        wSelf.image = placeholder;
    });
    
    [[self operationQueue] cancelAllOperations];
    
    NSOperation *operation = [[ImageDownloadManager sharedManager] getImageByUrl:url
                                    withCompletionBlock:^(UIImage *image) {
                                        typeof(self) sSelf = wSelf;
                                        if (!operation.isCancelled) {
                                            NSString *associatedUrl = objc_getAssociatedObject(sSelf, &kAssociatedObjectKey);
                                            if ([associatedUrl isEqualToString:url] && image) {
                                                dispatch_async(dispatch_get_main_queue(), ^{
                                                    sSelf.image = image;
                                                });
                                            }
                                        }
                                    }];
    [[self operationQueue] addOperation:operation];
}



@end
