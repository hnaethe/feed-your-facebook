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

@synthesize isParsing;

@synthesize title;
@synthesize url;

@synthesize linkToWebsite;
@synthesize description;
@synthesize pubDate;
@synthesize lastBuildDate;

@synthesize image;
@synthesize imageURL;

@synthesize feedItems;


- (id)initWithURL:(NSURL *)feedUrl
{
    if((self = [super init]))
    {
        self.isParsing = NO;
        self.url = feedUrl;
        self.feedItems = [[NSMutableArray alloc] init];
    }
    return self;
}

- (BOOL)hasNotBeenParsed
{
    if(title) return NO;
    if(linkToWebsite)return NO;
    if(description)return NO;
    if(pubDate) return NO;
    if(lastBuildDate) return NO;
    if(imageURL) return NO;
    
    return YES;
}

- (void)stringValue
{
    NSLog(@"-----Feed-----");
    NSLog(@"URL: %@", url);
    NSLog(@"title: %@", title);
    NSLog(@"link: %@", linkToWebsite);
    NSLog(@"description: %@", description);
    NSLog(@"pubDate: %@", pubDate);
    NSLog(@"lastBuildDate: %@", lastBuildDate);
    NSLog(@"imageURL: %@", imageURL);
    
    
    for (FeedItem *item in feedItems) {
        //[item stringValue];
    }
}
@end
