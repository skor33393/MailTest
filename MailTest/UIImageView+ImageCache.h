//
//  UIImageView+ImageCache.h
//  MailTest
//
//  Created by a.korenev on 20.08.15.
//  Copyright © 2015 alexkorenev. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIImageView (ImageCache)

- (void)setImageWithUrl:(NSString *)url placeholderImage:(UIImage *)placeholder;

@end
