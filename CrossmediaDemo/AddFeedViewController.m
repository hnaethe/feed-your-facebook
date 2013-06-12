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
    
    self.textField.delegate = self;
    [self.textField becomeFirstResponder];
    self.textField.text = @"http://www.";
    // Do any additional setup after loading the view from its nib.
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    if(!textField.hasText || [textField.text isEqualToString:@""]) return NO;
    [textField resignFirstResponder];
    
    [[MediaController sharedInstance] createFeedWithURL:self.textField.text];
    [self.navigationController popViewControllerAnimated:YES];
    return YES;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
