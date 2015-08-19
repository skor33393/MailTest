//
//  User.h
//  MailTest
//
//  Created by a.korenev on 19.08.15.
//  Copyright © 2015 alexkorenev. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface User : NSObject

@property (nonatomic, readonly, copy) NSString *userId;
@property (nonatomic, readonly, copy) NSString *userName;
@property (nonatomic, readonly, copy) NSString *userProfilePictureUrl;

- (instancetype)initWithId:(NSString *)userId name:(NSString *)userName profilePictureUrl:(NSString *)profilePictureUrl;

@end
