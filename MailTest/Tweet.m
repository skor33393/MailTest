//
//  Tweet.m
//  MailTest
//
//  Created by a.korenev on 16.08.15.
//  Copyright (c) 2015 alexkorenev. All rights reserved.
//

#import "Tweet.h"

@interface Tweet ()

@property (nonatomic, readwrite, copy) NSNumber *tweetId;
@property (nonatomic, readwrite, copy) NSString *text;
@property (strong, nonatomic, readwrite) User *user;

@end

@implementation Tweet

- (instancetype)initWithTweetId:(NSNumber *)tweetId text:(NSString *)text user:(User *)user {
    if (self = [super init]) {
        _tweetId = tweetId;
        _user = user;
        _text = text;
    }
    
    return self;
}

@end
