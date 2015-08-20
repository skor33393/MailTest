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

- (void)setImageWithUrl:(NSString *)url {
    objc_setAssociatedObject(self, &kAssociatedObjectKey, url, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    
    [[ImageDownloadManager sharedManager] getImageByUrl:url
                                    withCompletionBlock:^(UIImage *image) {
                                        NSString *associatedUrl = objc_getAssociatedObject(self, &kAssociatedObjectKey);
                                        if ([associatedUrl isEqualToString:url] && image) {
                                            [[NSOperationQueue mainQueue] addOperationWithBlock:^{
                                                self.image = image;
                                            }];
                                        }
                                    }];
}

@end
