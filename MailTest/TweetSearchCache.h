//
//  TweetSearchCache.h
//  MailTest
//
//  Created by a.korenev on 18.08.15.
//  Copyright (c) 2015 alexkorenev. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface TweetSearchCache : NSObject

- (void)insertTweets:(NSArray *)tweets;
- (void)getTweets;

@end
