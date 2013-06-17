//
//  SettingsViewController.m
//  CrossmediaDemo
//
//  Created by Hendrik Näther on 25.04.13.
//  Copyright (c) 2013 Hendrik Näther. All rights reserved.
//

#import "SettingsViewController.h"
#import "FacebookHandler.h"

@interface SettingsViewController ()
@property (nonatomic, strong) UITableView *settingsTable;
@end

@implementation SettingsViewController
@synthesize settingsTable;


- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    settingsTable = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height) style:UITableViewStyleGrouped];
    settingsTable.delegate = self;
    settingsTable.dataSource = self;
    
    if([settingsTable respondsToSelector:@selector(backgroundView)])
    {
        settingsTable.backgroundView = nil;
    }
    
    settingsTable.backgroundColor = [UIColor clearColor];
    
    [self.view addSubview:settingsTable];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(userDidLoginToFacebook:) name:FBUserDidLoginNotification object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(userDidLogoutFromFacebook:) name:FBUserDidLogoutNotification object:nil];
    
	// Do any additional setup after loading the view.
}

#pragma mark - TableView DataSource methods

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    switch (section)
    {
        case HNSettingsSectionFacebookAccount:
            return [[FacebookHandler sharedInstance] isLoggedIn] ? 3 : 2; // Facebook section
            break;
       
        case HNSettingsSectionFeed:
            return 0; // Feed section
            break;
            
        default:
            return 0;
            break;
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *identifier = @"SettingsCell";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:identifier];
    }
    
	// reset dequeued cells
	cell.accessoryView = nil;
	cell.detailTextLabel.text = nil;
    cell.backgroundColor = [UIColor clearColor];
    cell.detailTextLabel.textColor = [UIColor blackColor];
    cell.accessoryType = UITableViewCellAccessoryNone;
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
        
    switch (indexPath.section) {
        case HNSettingsSectionFacebookAccount:
        {
            if(indexPath.row == 0)
            {
                cell.textLabel.text = @"Status";
                cell.detailTextLabel.text = [[FacebookHandler sharedInstance] isLoggedIn] ? NSLocalizedString(@"angemeldet", @"") : NSLocalizedString(@"nicht angemeldet", @"");
                cell.detailTextLabel.textColor = [[FacebookHandler sharedInstance] isLoggedIn] ? [UIColor greenColor] : [UIColor redColor];
            }
            
            if(indexPath.row == 1)
            {
                if([[FacebookHandler sharedInstance] isLoggedIn])
                {
                    cell.textLabel.text = @"Account";
                    cell.detailTextLabel.text = [[[FacebookHandler sharedInstance] fbUser] name];
                }
                else
                {
                    UIButton *loginButton = [UIButton buttonWithType:UIButtonTypeRoundedRect];
                    loginButton.frame = CGRectMake(40, 10, 200, 30);
                    [loginButton setTitleColor:[UIColor blueColor] forState:UIControlStateNormal];
                    [loginButton setTitle:@"Anmelden" forState:UIControlStateNormal];
                    [loginButton addTarget:self action:@selector(didTouchLoginButton:) forControlEvents:UIControlEventTouchUpInside];
                    [cell addSubview:loginButton];
                }
            }
            
            if(indexPath.row == 2)
            {
                UIButton *logoutButton = [UIButton buttonWithType:UIButtonTypeRoundedRect];
                logoutButton.frame = CGRectMake(0, 0, 200, 30);
                [logoutButton setTitleColor:[UIColor redColor] forState:UIControlStateNormal];
                [logoutButton setTitle:@"Abmelden" forState:UIControlStateNormal];
                [logoutButton addTarget:self action:@selector(didTouchLogoutButton:) forControlEvents:UIControlEventTouchUpInside];
                [cell addSubview:logoutButton];
            }
            
            break;
        }
           
        default:
            break;
    }
    
    return cell;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return HNSettingsSectionCount;
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
    switch (section) {
        case HNSettingsSectionFacebookAccount:
            return @"Facebook-Account";
            break;
        case HNSettingsSectionFeed:
            return @"Feed-Einstellungen";
            break;
            
        default:
            return @"";
            break;
    }
}

#pragma mark - TableView Delegate methods

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 60;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Events

- (void)didTouchLoginButton:(id)sender
{
    [[FacebookHandler sharedInstance] loginIfNeeded];
}

- (void)userDidLoginToFacebook:(NSNotification *)notification
{
    NSInteger numberOfRows = [self tableView:self.settingsTable numberOfRowsInSection:HNSettingsSectionFacebookAccount];
	NSMutableArray *indexPaths = [NSMutableArray array];
	for (NSInteger i = 2; i < numberOfRows; i++) {
		[indexPaths addObject:[NSIndexPath indexPathForRow:i inSection:HNSettingsSectionFacebookAccount]];
	}
	
	[self.settingsTable insertRowsAtIndexPaths:indexPaths withRowAnimation:UITableViewRowAnimationAutomatic];
	[self.settingsTable reloadRowsAtIndexPaths:[NSArray arrayWithObjects:[NSIndexPath indexPathForRow:0 inSection:HNSettingsSectionFacebookAccount], [NSIndexPath indexPathForRow:1 inSection:HNSettingsSectionFacebookAccount], nil] withRowAnimation:UITableViewRowAnimationFade];
	[self.settingsTable reloadData];
}

- (void)didTouchLogoutButton:(id)sender
{
    [[FacebookHandler sharedInstance] logout];
}

- (void)userDidLogoutFromFacebook:(NSNotification *)notification
{
    [self.settingsTable deleteRowsAtIndexPaths:[NSArray arrayWithObject:[NSIndexPath indexPathForRow:2 inSection:HNSettingsSectionFacebookAccount]] withRowAnimation:UITableViewRowAnimationAutomatic];
    
    [self.settingsTable reloadRowsAtIndexPaths:[NSArray arrayWithObject:[NSIndexPath indexPathForRow:1 inSection:HNSettingsSectionFacebookAccount]] withRowAnimation:UITableViewRowAnimationFade];
}

@end
