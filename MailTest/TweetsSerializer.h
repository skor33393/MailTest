//
//  TweetsSerializer.h
//  MailTest
//
//  Created by a.korenev on 16.08.15.
//  Copyright (c) 2015 alexkorenev. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface TweetsSerializer : NSObject

- (NSArray *)serializeTweetsWithData:(NSData *)data;

@end
