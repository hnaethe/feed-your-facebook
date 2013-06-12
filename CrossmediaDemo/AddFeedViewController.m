//
//  AddFeedViewController.m
//  CrossmediaDemo
//
//  Created by Hendrik Näther on 12.06.13.
//  Copyright (c) 2013 Hendrik Näther. All rights reserved.
//

#import "AddFeedViewController.h"
#import "MediaController.h"

@interface AddFeedViewController ()
@end

@implementation AddFeedViewController
@synthesize textField = _textField;

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
    
    self.navigationItem.title = @"Neuer Feed";
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemAdd target:self  action:@selector(didTouchSave:)];
    // Do any additional setup after loading the view from its nib.
}

- (void)didTouchSave:(id)sender
{
    if(!self.textField.hasText || [self.textField.text isEqualToString:@""]) return;
    [[MediaController sharedInstance] createFeedWithURL:self.textField.text];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
