//
//  Feed.h
//  CrossmediaDemo
//
//  Created by Hendrik Näther on 20.04.13.
//  Copyright (c) 2013 Hendrik Näther. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ImageObject.h"

@interface Feed : ImageObject;
@property (nonatomic, assign) BOOL isParsing;
@property (nonatomic, assign) BOOL cannotBeParsed;

@property (nonatomic, strong) NSString *title;
@property (nonatomic, strong) NSURL *url;

@property (nonatomic, strong) NSString *linkToWebsite;
@property (nonatomic, strong) NSString *description;
@property (nonatomic, strong) NSDate *pubDate;
@property (nonatomic, strong) NSDate *lastBuildDate;

@property (nonatomic, strong) NSMutableArray *feedItems;

- (id)initWithURL:(NSURL *)feedUrl;

- (void)stringValue;

- (BOOL)hasNotBeenParsed;

@end
