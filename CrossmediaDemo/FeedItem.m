//
//  FeedItem.m
//  CrossmediaDemo
//
//  Created by Hendrik Näther on 20.04.13.
//  Copyright (c) 2013 Hendrik Näther. All rights reserved.
//

#import "FeedItem.h"

@implementation FeedItem
@synthesize title = _title;
@synthesize link = _link;
@synthesize description = _description;
@synthesize pubDate = _pubDate;

- (id)init
{
    self = [super init];
    if(self)
    {
        self.iconSize = 53;
    }
    return self;
}

- (void)stringValue
{
    NSLog(@"title: %@", self.title);
    NSLog(@"link: %@", self.link);
    NSLog(@"description: %@", self.description);
    NSLog(@"pubDate: %@", self.pubDate);
    NSLog(@"imageuRL: %@", self.imageURL);
}

@end
