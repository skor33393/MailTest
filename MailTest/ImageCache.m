//
//  ImageCache.m
//  MailTest
//
//  Created by a.korenev on 19.08.15.
//  Copyright © 2015 alexkorenev. All rights reserved.
//

#import "ImageCache.h"
#import <UIKit/UIKit.h>
#import <FMDB.h>

static NSString * const IMAGE_DATABASE_PATH = @"image.sqlite";

@interface ImageCache ()

@property (strong, nonatomic) NSCache *inMemoryCache;
@property (strong, nonatomic) FMDatabaseQueue *dbQueue;

@end

@implementation ImageCache

+ (instancetype)sharedCache {
    static ImageCache *sharedCache = nil;
    
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedCache = [[ImageCache alloc] init];
    });
    
    return sharedCache;
}

- (instancetype)init {
    if (self = [super init]) {
        _inMemoryCache = [[NSCache alloc] init];
        
        NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
        NSString *docsPath = [paths objectAtIndex:0];
        NSString *path = [docsPath stringByAppendingPathComponent:IMAGE_DATABASE_PATH];
        
        _dbQueue = [FMDatabaseQueue databaseQueueWithPath:path];
        [_dbQueue inDatabase:^(FMDatabase *db) {
            [db executeUpdate:@"CREATE TABLE IF NOT EXISTS image (imageUrl text unique, imageData blob)"];
        }];
    }
    
    return self;
}

- (void)saveImage:(UIImage *)image withUrl:(NSString *)url onSuccess:(void (^)())successBlock onFailure:(void (^)(NSError *))error {
    if (![self.inMemoryCache objectForKey:url]) {
        @synchronized(self) {
            [self.inMemoryCache setObject:image forKey:url];
        }
        [self.dbQueue inDatabase:^(FMDatabase *db) {
            NSData *imageData = UIImagePNGRepresentation(image);
            [db executeUpdate:@"INSERT OR REPLACE INTO image VALUES (?, ?)", url, imageData];
        }];
    }
    else {
        successBlock();
    }
}

- (void)getImageByUrl:(NSString *)url withCompletionBlock:(void (^)(UIImage *))completionBlock {
    UIImage *inMemoryImage = [self.inMemoryCache objectForKey:url];
    if (!inMemoryImage) {
        [self.dbQueue inDatabase:^(FMDatabase *db) {
            NSString *imageQuery = [NSString stringWithFormat:@"SELECT imageData FROM image WHERE imageUrl = \'%@\'", url];
            FMResultSet *imageSet = [db executeQuery:imageQuery];
            NSData *imageData = nil;
            while ([imageSet next]) {
                imageData = [imageSet dataForColumn:@"imageData"];
            }
            
            UIImage *imageFromData = [UIImage imageWithData:imageData];
            if (imageFromData != nil) {
                [self.inMemoryCache setObject:imageFromData forKey:url];
            }
            
            completionBlock(imageFromData);
        }];
    }
    else {
        completionBlock(inMemoryImage);
    }
}

@end
