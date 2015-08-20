//
//  User.h
//  MailTest
//
//  Created by a.korenev on 19.08.15.
//  Copyright © 2015 alexkorenev. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface User : NSObject

@property (nonatomic, readonly, copy) NSNumber *userId;
@property (nonatomic, readonly, copy) NSString *userName;
@property (nonatomic, readonly, copy) NSString *userProfilePictureUrl;

- (instancetype)initWithId:(NSNumber *)userId name:(NSString *)userName profilePictureUrl:(NSString *)profilePictureUrl;

@end
