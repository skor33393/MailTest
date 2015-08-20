//
//  SettingsViewController.m
//  MailTest
//
//  Created by a.korenev on 20.08.15.
//  Copyright © 2015 alexkorenev. All rights reserved.
//

#import "SettingsViewController.h"
#import "Settings.h"

@interface SettingsViewController ()

@property (weak, nonatomic) IBOutlet UISwitch *switchView;

@end

@implementation SettingsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.switchView.on = [[Settings currentSettings] shouldShowAvatar];
}

- (IBAction)switchValueChanged:(id)sender {
    [[Settings currentSettings] setShouldShowAvatar:self.switchView.isOn];
}

@end
