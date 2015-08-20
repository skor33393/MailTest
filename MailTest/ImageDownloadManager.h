//
//  ImageDownloadManager.h
//  MailTest
//
//  Created by a.korenev on 20.08.15.
//  Copyright © 2015 alexkorenev. All rights reserved.
//

#import <Foundation/Foundation.h>

@class UIImage;

@interface ImageDownloadManager : NSObject

+ (instancetype)sharedManager;

- (void)getImageByUrl:(NSString *)url withCompletionBlock:(void (^) (UIImage *image))completionBlock;

@end
