//
//  Tweet.h
//  MailTest
//
//  Created by a.korenev on 16.08.15.
//  Copyright (c) 2015 alexkorenev. All rights reserved.
//

#import <Foundation/Foundation.h>

@class User;

@interface Tweet : NSObject

@property (nonatomic, readonly, copy) NSNumber *tweetId;
@property (nonatomic, readonly, copy) NSString *text;
@property (strong, nonatomic, readonly) User *user;

- (instancetype)initWithTweetId:(NSNumber *)tweetId text:(NSString *)text user:(User *)user;

@end
