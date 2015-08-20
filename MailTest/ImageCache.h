//
//  ImageCache.h
//  MailTest
//
//  Created by a.korenev on 19.08.15.
//  Copyright © 2015 alexkorenev. All rights reserved.
//

#import <Foundation/Foundation.h>

@class UIImage;

@interface ImageCache : NSObject

+ (instancetype)sharedCache;

- (void)saveImage:(UIImage *)image withUrl:(NSString *)url onSuccess:(void (^) ())successBlock onFailure:(void (^) (NSError *error))error;
- (void)getImageByUrl:(NSString *)url withCompletionBlock:(void (^)(UIImage *image))completionBlock;
@end
