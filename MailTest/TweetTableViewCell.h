//
//  TweetTableViewCell.h
//  MailTest
//
//  Created by a.korenev on 18.08.15.
//  Copyright (c) 2015 alexkorenev. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface TweetTableViewCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UIImageView *userAvatar;
@property (weak, nonatomic) IBOutlet UILabel *tweetText;

@end
