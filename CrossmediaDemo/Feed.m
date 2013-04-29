//
//  Feed.m
//  CrossmediaDemo
//
//  Created by Hendrik Näther on 20.04.13.
//  Copyright (c) 2013 Hendrik Näther. All rights reserved.
//

#import "Feed.h"
#import "FeedItem.h"

@implementation Feed
@synthesize title;
@synthesize url;

@synthesize linkToWebsite;
@synthesize description;
@synthesize pubDate;
@synthesize lastBuildDate;

@synthesize image;
@synthesize imageWidth;
@synthesize imageHeight;
@synthesize imageURL;

@synthesize feedItems;


- (id)initWithURL:(NSURL *)feedUrl
{
    if((self = [super init]))
    {
        self.url = feedUrl;
        self.feedItems = [[NSMutableArray alloc] init];
    }
    return self;
}

- (BOOL)hasNotBeenParsed
{
    if(!title) return YES;
    if(!linkToWebsite)return YES;
    if(!description)return YES;
    if(!pubDate) return YES;
    if(!lastBuildDate) return YES;
    if(!imageURL) return YES;
    if([feedItems count] == 0) return YES;
    
    return NO;
}

- (void)stringValue
{
    
    NSLog(@"title: %@", title);
    NSLog(@"link: %@", linkToWebsite);
    NSLog(@"description: %@", description);
    NSLog(@"pubDate: %@", pubDate);
    NSLog(@"lastBuildDate: %@", lastBuildDate);
    NSLog(@"imageWidth: %@", imageWidth);
    NSLog(@"imageHeight: %@", imageHeight);
    NSLog(@"imageURL: %@", imageURL);
    
    
    for (FeedItem *item in feedItems) {
        [item stringValue];
    }
}
@end
