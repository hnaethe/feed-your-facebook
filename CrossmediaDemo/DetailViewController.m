//
//  DetailViewController.m
//  CrossmediaDemo
//
//  Created by Hendrik Näther on 12.06.13.
//  Copyright (c) 2013 Hendrik Näther. All rights reserved.
//

#import "DetailViewController.h"

@interface DetailViewController ()

@end

@implementation DetailViewController
@synthesize webView = _webView;
@synthesize url = _url;
@synthesize activityIndicator = _activityIndicator;

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
    
    self.webView = [[UIWebView alloc] init];
    [self.view addSubview:self.webView];
    self.webView.delegate = self;
    
    self.activityIndicator = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
    self.activityIndicator.frame = CGRectMake(self.view.frame.size.width/2, self.view.frame.size.height/2, 30, 30);
    [self.view addSubview:self.activityIndicator];
    [self.activityIndicator startAnimating];
    
    // Do any additional setup after loading the view from its nib.
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    
    CGRect frame = self.view.frame;
    self.webView.frame = frame;
    
    NSURLRequest *requestObj = [NSURLRequest requestWithURL:self.url];
    [self.webView performSelectorInBackground:@selector(loadRequest:) withObject:requestObj];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)webViewDidFinishLoad:(UIWebView *)webView
{
    NSLog(@"Success");
    [self.activityIndicator stopAnimating];
}

- (void)webView:(UIWebView *)webView didFailLoadWithError:(NSError *)error
{
    NSLog(@"Errör");
    [self.activityIndicator stopAnimating];
}

@end
