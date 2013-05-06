//
//  FacebookHandler.h
//  CrossmediaDemo
//
//  Created by Hendrik Näther on 25.04.13.
//  Copyright (c) 2013 Hendrik Näther. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <FacebookSDK/FacebookSDK.h>

extern NSString *const FBUserDidLoginNotification;
extern NSString *const FBUserDidLogoutNotification;

@class FeedItem;
@interface FacebookHandler : NSObject

@property (nonatomic, strong, readonly) NSDictionary<FBGraphUser> *fbUser;

+ (id)sharedInstance;

- (void)publishStoryWithFeedItem:(FeedItem *)item;


- (BOOL)isLoggedIn;

- (void)loginIfNeeded;

- (void)logout;

@end
