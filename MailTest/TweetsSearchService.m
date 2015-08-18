//
//  TweetsSearchService.m
//  MailTest
//
//  Created by a.korenev on 16.08.15.
//  Copyright (c) 2015 alexkorenev. All rights reserved.
//

#import "TweetsSearchService.h"
#import "TweetsSerializer.h"
#import "Tweet.h"

static NSString * const SEARCH_ENDPOINT = @"https://api.twitter.com/1.1/search/tweets.json";
static NSString * const ACCESS_TOKEN = @"AAAAAAAAAAAAAAAAAAAAAJ5PhAAAAAAAOyF5kZsNuo87yB9MABWtHnhQoWw%3DH6wI0u0ITEdyOaKQqJCNT1d6knKheuJqzFRko37QaeZzMfsAsb";

@interface TweetsSearchService () <NSURLConnectionDataDelegate, NSURLConnectionDelegate>

@property (strong, nonatomic) NSURLSession *session;
@property (strong, nonatomic) TweetsSerializer *serializer;

@end

@implementation TweetsSearchService

- (instancetype)init {
    if (self = [super init]) {
        NSURLSessionConfiguration *sessionConfiguration = [NSURLSessionConfiguration defaultSessionConfiguration];
        _session = [NSURLSession sessionWithConfiguration:sessionConfiguration];
        
        _serializer = [[TweetsSerializer alloc] init];
    }
    
    return self;
}

#pragma mark - Search

- (void)searchLatestTweetsByHashtag:(NSString *)hashtag onSuccess:(void (^)(NSArray *))successBlock onFailure:(void (^)(NSError *))failureBlock {
    NSURLRequest *searchRequest = [self requestForSearchTweetsByHashtag:hashtag];
    
    [[self.session dataTaskWithRequest:searchRequest
                    completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
                        if (!error) {
                            NSArray *tweets = [_serializer serializeTweetsWithData:data];
                            if (tweets) {
                                successBlock(tweets);
                            }
                        }
                        else {
                            failureBlock(error);
                        }
                    }] resume];
}

- (void)searchTweetsByHashtag:(NSString *)hashtag sinceTweet:(Tweet *)tweet onSuccess:(void (^)(NSArray *))successBlock onFailure:(void (^)(NSError *))failureBlock {
    NSString *query = [[NSString stringWithFormat:@"q=#%@&since_id=%@&result_type=recent", hashtag, tweet.tweetId] stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    NSString *parametrizedUrl = [SEARCH_ENDPOINT stringByAppendingString:[NSString stringWithFormat:@"?%@", query]];
    NSURL *url = [NSURL URLWithString:parametrizedUrl];
    
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc] initWithURL:url];
    request.HTTPMethod = @"GET";
    [request addValue:[NSString stringWithFormat:@"Bearer %@", ACCESS_TOKEN] forHTTPHeaderField:@"Authorization"];
    
    [[self.session dataTaskWithRequest:request
                    completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
                        if (!error) {
                            NSArray *tweets = [_serializer serializeTweetsWithData:data];
                            if (tweets) {
                                successBlock(tweets);
                            }
                        }
                        else {
                            failureBlock(error);
                        }
                    }] resume];
}

#pragma mark - Search requests

- (NSURLRequest *)requestForSearchTweetsByHashtag:(NSString *)hashtag {
    NSString *query = [[NSString stringWithFormat:@"q=#%@&result_type=recent", hashtag] stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    NSString *parametrizedUrl = [SEARCH_ENDPOINT stringByAppendingString:[NSString stringWithFormat:@"?%@", query]];
    NSURL *url = [NSURL URLWithString:parametrizedUrl];
    
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc] initWithURL:url];
    request.HTTPMethod = @"GET";
    [request addValue:[NSString stringWithFormat:@"Bearer %@", ACCESS_TOKEN] forHTTPHeaderField:@"Authorization"];
    
    return request;
}

@end