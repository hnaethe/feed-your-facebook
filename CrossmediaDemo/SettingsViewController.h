//
//  SettingsViewController.h
//  CrossmediaDemo
//
//  Created by Hendrik Näther on 25.04.13.
//  Copyright (c) 2013 Hendrik Näther. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef enum {
	HNSettingsSectionFacebookAccount = 0,
    HNSettingsSectionFeed,
    HNSettingsSectionCount,
} HNSettingsSection;

@interface SettingsViewController : UIViewController <UITableViewDataSource, UITableViewDelegate>

@end
