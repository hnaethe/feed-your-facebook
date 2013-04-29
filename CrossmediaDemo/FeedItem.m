//
//  FeedItem.m
//  CrossmediaDemo
//
//  Created by Hendrik Näther on 20.04.13.
//  Copyright (c) 2013 Hendrik Näther. All rights reserved.
//

#import "FeedItem.h"

@implementation FeedItem
@synthesize title;
@synthesize link;
@synthesize description;
@synthesize pubDate;
@synthesize image;
@synthesize imageURL;


- (void)stringValue
{
    NSLog(@"title: %@", title);
    NSLog(@"link: %@", link);
    NSLog(@"description: %@", description);
    NSLog(@"pubDate: %@", pubDate);
    NSLog(@"imageuRL: %@", imageURL);
}

@end
