//
//  TweetSearchCache.m
//  MailTest
//
//  Created by a.korenev on 18.08.15.
//  Copyright (c) 2015 alexkorenev. All rights reserved.
//

#import "TweetSearchCache.h"
#import "Tweet.h"
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
        
        NSLog(@"%@", path);
        
        _dbQueue = [FMDatabaseQueue databaseQueueWithPath:path];
        [_dbQueue inDatabase:^(FMDatabase *db) {
            [db executeUpdate:@"CREATE TABLE IF NOT EXISTS user (userId text primary key, userName text)"];
            [db executeUpdate:@"CREATE TABLE IF NOT EXISTS tweet (tweetId text primary key, tweetText text, tweetUserId text, userId text, foreign key(userId) references user(userId))"];
        }];
    }
    
    return self;
}

- (void)insertTweets:(NSArray *)tweets {
    [self.dbQueue inDatabase:^(FMDatabase *db) {
        for (Tweet *tweet in tweets) {
            //[db executeUpdate:@"INSERT OR REPLACE INTO tweet VALUES (?, ?)", tweet.tweetId, tweet.text, nil];
        }
    }];
}

- (void)getTweets {
    [self.dbQueue inDatabase:^(FMDatabase *db) {
        FMResultSet *tweets = [db executeQuery:@"select * from tweet"];
        while ([tweets next]) {
            //NSLog(@"~%@", [tweets stringForColumn:@"tweetText"]);
        }
    }];
}

@end
