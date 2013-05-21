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

- (id)init
{
    self = [super init];
    if(self)
    {
        self.imageURL = [NSURL URLWithString:@"http://www.mountainpanoramas.com/___p/_panos/2012_V4/2012_V4_t.png"];
    }
    return self;
}

- (void)stringValue
{
    NSLog(@"title: %@", title);
    NSLog(@"link: %@", link);
    NSLog(@"description: %@", description);
    NSLog(@"pubDate: %@", pubDate);
    NSLog(@"imageuRL: %@", imageURL);
}

@end
