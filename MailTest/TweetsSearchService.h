//
//  TweetsSearchService.h
//  MailTest
//
//  Created by a.korenev on 16.08.15.
//  Copyright (c) 2015 alexkorenev. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Tweet.h"

@interface TweetsSearchService : NSObject

- (void)searchLatestTweetsByHashtag:(NSString *)hashtag onSuccess:(void (^) (NSArray *tweets))successBlock onFailure:(void (^) (NSError *error))failureBlock;
- (void)searchTweetsByHashtag:(NSString *)hashtag sinceTweet:(Tweet *)tweet onSuccess:(void (^) (NSArray *tweets))successBlock onFailure:(void (^) (NSError *error))failureBlock;

- (void)cachedTweets;

@end
