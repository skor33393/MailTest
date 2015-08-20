//
//  ViewController.m
//  MailTest
//
//  Created by a.korenev on 16.08.15.
//  Copyright (c) 2015 alexkorenev. All rights reserved.
//

#import "TweetsViewController.h"
#import "TweetsSearchService.h"
#import "TweetTableViewCell.h"
#import "User.h"
#import "ImageCache.h"
#import "UIImageView+ImageCache.h"
#import "Settings.h"

static NSString * const HASHTAG = @"putin";
static NSString * const CELL_IDENTIFIER = @"TweetCell";
static const NSTimeInterval REFRESH_INTERVAL = 60.0;
static const NSUInteger MAX_COUNT_OF_CACHED_TWEETS = 20.0;

@interface TweetsViewController () <UISearchBarDelegate>

@property (strong, nonatomic) TweetsSearchService *tweetSearchService;
@property (strong, nonatomic) NSArray *tweets;
@property (strong, nonatomic) NSArray *cachedTweets;

@property (strong, nonatomic) UIActivityIndicatorView *activityIndicator;
@property (strong, nonatomic) UILabel *timerLabel;

@property (nonatomic) NSUInteger timeLeft;

@end

@implementation TweetsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.activityIndicator = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
    UIBarButtonItem *barButton = [[UIBarButtonItem alloc] initWithCustomView:self.activityIndicator];
    self.navigationItem.rightBarButtonItem = barButton;
    
    self.timeLeft = REFRESH_INTERVAL;
    
    self.timerLabel = [[UILabel alloc] initWithFrame:CGRectMake(0.0, 0.0, 40.0, 20.0)];
    self.timerLabel.text = @(self.timeLeft).stringValue;
    UIBarButtonItem *leftBarButton = [[UIBarButtonItem alloc] initWithCustomView:self.timerLabel];
    self.navigationItem.leftBarButtonItem = leftBarButton;
    
    _tweetSearchService = [[TweetsSearchService alloc] init];
    
    __weak typeof(self) wSelf = self;
    [self.tweetSearchService cachedTweetsWithMaxCount:MAX_COUNT_OF_CACHED_TWEETS withCompletionBlock:^(NSArray *tweets) {
        typeof(self) sSelf = wSelf;
        if ([tweets count]) {
            _cachedTweets = tweets;
            dispatch_async(dispatch_get_main_queue(), ^{
                [sSelf.tableView reloadData];
                
                NSTimer *timer = [NSTimer scheduledTimerWithTimeInterval:1.0
                                                 target:sSelf
                                               selector:@selector(updateTimer)
                                               userInfo:nil repeats:YES];
                [[NSRunLoop mainRunLoop] addTimer:timer forMode:NSRunLoopCommonModes];
                
                [sSelf loadTweetsSinceTweet:[_cachedTweets firstObject]];
            });
        }
    }];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(shouldShowAvatarValueChanged:) name:SHOULD_SHOW_AVATAR_VALUE_CHANGED_NOTIFICATION object:nil];
}

- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

#pragma mark - Timer

- (void)updateTimer {
    self.timerLabel.text = @(--self.timeLeft).stringValue;
    if (self.timeLeft == 0) {
        self.timeLeft = REFRESH_INTERVAL;
        [self loadTweetsSinceTweet:[self.tweets firstObject]];
    }
}

#pragma mark - Tweets load

- (void)loadTweetsSinceTweet:(Tweet *)tweet {
    dispatch_async(dispatch_get_main_queue(), ^{
        [self.activityIndicator startAnimating];
    });
    
    __weak typeof(self) wSelf = self;
    [self.tweetSearchService searchTweetsByHashtag:HASHTAG
                                        sinceTweet:tweet
                                         onSuccess:^(NSArray *tweets) {
                                             typeof(self) sSelf = wSelf;
                                             
                                             NSMutableArray *temporaryArray = [[NSMutableArray alloc] init];
                                             [temporaryArray addObjectsFromArray:tweets];
                                             [temporaryArray addObjectsFromArray:self.tweets];
                                             
                                             NSMutableArray *indexPaths = [[NSMutableArray alloc] initWithCapacity:[tweets count]];
                                             for (int i = 0; i < [tweets count]; i++) {
                                                 [indexPaths addObject:[NSIndexPath indexPathForItem:i inSection:0]];
                                             }
                                             
                                             self.tweets = [NSArray arrayWithArray:temporaryArray];
                                             
                                             dispatch_async(dispatch_get_main_queue(), ^{
                                                 [sSelf.activityIndicator stopAnimating];
                                                 
                                                 [sSelf.tableView beginUpdates];
                                                 [sSelf.tableView insertRowsAtIndexPaths:indexPaths
                                                                       withRowAnimation:UITableViewRowAnimationAutomatic];
                                                 [sSelf.tableView endUpdates];
                                             });
                                         } onFailure:^(NSError *error) {
                                             typeof(self) sSelf = wSelf;
                                             
                                             dispatch_async(dispatch_get_main_queue(), ^{
                                                 [sSelf.activityIndicator stopAnimating];
                                                 
                                                 [[[UIAlertView alloc] initWithTitle:@"Error"
                                                                             message:@"An error occured"
                                                                            delegate:nil
                                                                   cancelButtonTitle:@"OK"
                                                                   otherButtonTitles:nil] show];
                                             });
                                         }];
}

#pragma mark - UITableViewDelegate

- (CGFloat)tableView:(nonnull UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    if (section == 1) {
        return 44.0f;
    }
    
    return 0;
}

- (nullable UIView *)tableView:(nonnull UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    if (section == 1) {
        UIView *headerView = [[UIView alloc] init];
        headerView.backgroundColor = [UIColor lightGrayColor];
    }
    
    return nil;
}

#pragma mark - UITableViewDataSource

- (NSInteger)numberOfSectionsInTableView:(nonnull UITableView *)tableView {
    return 2;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return section == 0 ? [self.tweets count] : [self.cachedTweets count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CELL_IDENTIFIER];
    
    NSArray *tweetsArray = indexPath.section == 0 ? self.tweets : self.cachedTweets;
    Tweet *correspondingTweet = [tweetsArray objectAtIndex:indexPath.item];
    TweetTableViewCell *tweetCell = (TweetTableViewCell *)cell;
    tweetCell.tweetText.text = correspondingTweet.text;
    tweetCell.userName.text = correspondingTweet.user.userName;
    
    UIImage *placeholderImage = [UIImage imageNamed:@"avatarPlaceholder"];
    if ([[Settings currentSettings] shouldShowAvatar]) {
        [tweetCell.userAvatar setImageWithUrl:correspondingTweet.user.userProfilePictureUrl placeholderImage:placeholderImage];
    }
    else {
        tweetCell.userAvatar.image = placeholderImage;
    }
    
    return cell;
}

#pragma mark - Notifications

- (void)shouldShowAvatarValueChanged:(NSNotification *)notification {
    dispatch_async(dispatch_get_main_queue(), ^{
        [self.tableView reloadData];
    });
}

@end
