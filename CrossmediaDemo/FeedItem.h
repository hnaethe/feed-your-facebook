//
//  FeedItem.h
//  CrossmediaDemo
//
//  Created by Hendrik Näther on 20.04.13.
//  Copyright (c) 2013 Hendrik Näther. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ImageObject.h"

@interface FeedItem : ImageObject
@property (nonatomic, strong) NSString *title;
@property (nonatomic, strong) NSString *link;
@property (nonatomic, strong) NSString *description;
@property (nonatomic, strong) NSDate *pubDate;

- (void)stringValue;

@end
