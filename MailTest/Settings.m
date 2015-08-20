//
//  Settings.m
//  MailTest
//
//  Created by a.korenev on 20.08.15.
//  Copyright © 2015 alexkorenev. All rights reserved.
//

#import "Settings.h"

static NSString * const SHOULD_SHOW_AVATAR_USER_DEFAULTS_KEY = @"shouldShowAvatar";
NSString * const SHOULD_SHOW_AVATAR_VALUE_CHANGED_NOTIFICATION = @"shouldShowAvatarValueChangedNotification";

@implementation Settings

+ (instancetype)currentSettings {
    static Settings *currentSettings = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        currentSettings = [[Settings alloc] init];
    });
    
    return currentSettings;
}

- (instancetype)init {
    if (self = [super init]) {
        NSNumber *shouldShowAvatar = [[NSUserDefaults standardUserDefaults] objectForKey:SHOULD_SHOW_AVATAR_USER_DEFAULTS_KEY];
        if (shouldShowAvatar) {
            _shouldShowAvatar = [shouldShowAvatar boolValue];
        }
        else {
            _shouldShowAvatar = YES;
            [[NSUserDefaults standardUserDefaults] setObject:@(YES) forKey:SHOULD_SHOW_AVATAR_USER_DEFAULTS_KEY];
            [[NSUserDefaults standardUserDefaults] synchronize];
        }
    }
    
    return self;
}

- (void)setShouldShowAvatar:(BOOL)shouldShowAvatar {
    if (shouldShowAvatar != _shouldShowAvatar) {
        _shouldShowAvatar = shouldShowAvatar;
        
        [[NSUserDefaults standardUserDefaults] setObject:@(shouldShowAvatar) forKey:SHOULD_SHOW_AVATAR_USER_DEFAULTS_KEY];
        [[NSUserDefaults standardUserDefaults] synchronize];
        
        [[NSNotificationCenter defaultCenter] postNotificationName:SHOULD_SHOW_AVATAR_VALUE_CHANGED_NOTIFICATION object:self];
    }
}

@end
