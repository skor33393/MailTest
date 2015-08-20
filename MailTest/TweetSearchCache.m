//
//  TweetSearchCache.m
//  MailTest
//
//  Created by a.korenev on 18.08.15.
//  Copyright (c) 2015 alexkorenev. All rights reserved.
//

#import "TweetSearchCache.h"
#import "Tweet.h"
#import "User.h"
#import <FMDB.h>

static NSString * const DATABASE_NAME = @"mailtest.sqlite";

@interface TweetSearchCache ()

@property (strong, nonatomic) FMDatabaseQueue *dbQueue;
@property (nonatomic) BOOL isDatabaseConfigured;

@end

@implementation TweetSearchCache

- (instancetype)init {
    if (self = [super init]) {
        NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
        NSString *docsPath = [paths objectAtIndex:0];
        NSString *path = [docsPath stringByAppendingPathComponent:DATABASE_NAME];
                
        _dbQueue = [FMDatabaseQueue databaseQueueWithPath:path];
        [_dbQueue inDatabase:^(FMDatabase *db) {
            [db executeUpdate:@"CREATE TABLE IF NOT EXISTS user (userId INT8 primary key, userName text, profilePictureUrl text)"];
            [db executeUpdate:@"CREATE TABLE IF NOT EXISTS tweet (tweetId INT8 primary key, tweetText text, tweetUserId text, foreign key(tweetUserId) references user(userId))"];
        }];
    }
    
    return self;
}

- (void)insertTweets:(NSArray *)tweets {
    [self.dbQueue inTransaction:^(FMDatabase *db, BOOL *rollback) {
        for (Tweet *tweet in tweets) {
            [db executeUpdate:@"INSERT OR REPLACE INTO user VALUES (?, ?, ?)", tweet.user.userId, tweet.user.userName, tweet.user.userProfilePictureUrl];
            [db executeUpdate:@"INSERT OR REPLACE INTO tweet VALUES (?, ?, ?)", tweet.tweetId, tweet.text, tweet.user.userId, nil];
        }
    }];
}

- (void)getTweetsWithCompletionBlock:(void (^) (NSArray *))completionBlock {
    [self.dbQueue inDatabase:^(FMDatabase *db) {
        FMResultSet *tweets = [db executeQuery:@"SELECT *, * FROM tweet, user WHERE tweet.tweetUserId = user.userId ORDER BY tweet.tweetId desc"];
        NSMutableArray *resultTweets = [[NSMutableArray alloc] init];
        
        while ([tweets next]) {
            NSNumber *userId = @([tweets unsignedLongLongIntForColumn:@"userId"]);
            NSString *userName = [tweets stringForColumn:@"userName"];
            NSString *profilePictureUrl = [tweets stringForColumn:@"profilePictureUrl"];
            User *user = [[User alloc] initWithId:userId name:userName profilePictureUrl:profilePictureUrl];
            
            NSNumber *tweetId = @([tweets unsignedLongLongIntForColumn:@"tweetId"]);
            NSString *tweetText = [tweets stringForColumn:@"tweetText"];
            Tweet *tweet = [[Tweet alloc] initWithTweetId:tweetId text:tweetText user:user];
            
            [resultTweets addObject:tweet];
        }
        
        completionBlock(resultTweets);
    }];
}

@end
