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

@synthesize isParsing, cannotBeParsed;

@synthesize title;
@synthesize url;

@synthesize linkToWebsite;
@synthesize description;
@synthesize pubDate;
@synthesize lastBuildDate;

@synthesize feedItems;


- (id)initWithURL:(NSURL *)feedUrl
{
    if((self = [super init]))
    {
        self.isParsing = NO;
        self.cannotBeParsed = NO;
        self.url = feedUrl;
        self.feedItems = [[NSMutableArray alloc] init];
        self.iconSize = 43;
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
    if(self.imageURL) return NO;
    
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
    NSLog(@"imageURL: %@", self.imageURL);
    
    
    for (FeedItem *item in feedItems) {
        //[item stringValue];
    }
}
@end
