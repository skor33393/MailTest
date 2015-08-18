//
//  TweetsSerializer.m
//  MailTest
//
//  Created by a.korenev on 16.08.15.
//  Copyright (c) 2015 alexkorenev. All rights reserved.
//

#import "TweetsSerializer.h"
#import "Tweet.h"

@implementation TweetsSerializer

- (NSArray *)serializeTweetsWithData:(NSData *)data {
    NSMutableArray *resultArray = [[NSMutableArray alloc] init];
    
    NSError *serializationError;
    id obj = [NSJSONSerialization JSONObjectWithData:data
                                             options:NSJSONReadingMutableContainers
                                               error:&serializationError];
    
    if ([obj isKindOfClass:[NSDictionary class]]) {
        NSDictionary *response = (NSDictionary *)obj;
        NSArray *statuses = response[@"statuses"];
        if (statuses) {
            @autoreleasepool {
                for (NSDictionary *tweet in statuses) {
                    NSString *tweetId = tweet[@"id_str"];
                    
                    NSDictionary *author = tweet[@"user"];
                    NSString *authorName = author[@"name"];
                    
                    NSString *text = tweet[@"text"];
                    
                    Tweet *currentTweet = [[Tweet alloc] initWithTweetId:tweetId authorName:authorName text:text];
                    
                    [resultArray addObject:currentTweet];
                }
            }
        }
    }
    
    return [NSArray arrayWithArray:resultArray];
}

@end
