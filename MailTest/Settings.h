//
//  Settings.h
//  MailTest
//
//  Created by a.korenev on 20.08.15.
//  Copyright © 2015 alexkorenev. All rights reserved.
//

#import <Foundation/Foundation.h>

extern NSString * const SHOULD_SHOW_AVATAR_VALUE_CHANGED_NOTIFICATION;

@interface Settings : NSObject

+ (instancetype)currentSettings;

@property (nonatomic) BOOL shouldShowAvatar;

@end
