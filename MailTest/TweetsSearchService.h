//
//  TweetsSearchService.h
//  MailTest
//
//  Created by a.korenev on 16.08.15.
//  Copyright (c) 2015 alexkorenev. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface TweetsSearchService : NSObject

- (void)searchTweetsByHashtag:(NSString *)hashtag onSuccess:(void (^) (NSArray *tweets))successBlock onFailure:(void (^) (NSError *error))failureBlock;

@end
