//
//  TweetsSerializer.m
//  MailTest
//
//  Created by a.korenev on 16.08.15.
//  Copyright (c) 2015 alexkorenev. All rights reserved.
//

#import "TweetsSerializer.h"
#import "Tweet.h"
#import "User.h"

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
                    NSDictionary *userDictionary = tweet[@"user"];
                    NSString *userId = userDictionary[@"id_str"];
                    NSString *userName = userDictionary[@"screen_name"];
                    NSString *profilePictureUrl = userDictionary[@"profile_image_url"];
                    
                    User *user = [[User alloc] initWithId:userId name:userName profilePictureUrl:profilePictureUrl];
                    
                    NSString *tweetId = tweet[@"id_str"];
                    NSString *text = tweet[@"text"];
                    
                    Tweet *currentTweet = [[Tweet alloc] initWithTweetId:tweetId text:text user:user];
                    
                    [resultArray addObject:currentTweet];
                }
            }
        }
    }
    
    return [NSArray arrayWithArray:resultArray];
}

@end
