//
//  User.m
//  MailTest
//
//  Created by a.korenev on 19.08.15.
//  Copyright © 2015 alexkorenev. All rights reserved.
//

#import "User.h"

@interface User ()

@property (nonatomic, readwrite, copy) NSNumber *userId;
@property (nonatomic, readwrite, copy) NSString *userName;
@property (nonatomic, readwrite, copy) NSString *userProfilePictureUrl;

@end

@implementation User

- (instancetype)initWithId:(NSNumber *)userId name:(NSString *)userName profilePictureUrl:(NSString *)profilePictureUrl {
    if (self = [super init]) {
        _userId = userId;
        _userName = userName;
        _userProfilePictureUrl = profilePictureUrl;
    }
    
    return self;
}

@end
