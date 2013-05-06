//
//  FacebookHandler.m
//  CrossmediaDemo
//
//  Created by Hendrik Näther on 25.04.13.
//  Copyright (c) 2013 Hendrik Näther. All rights reserved.
//

#import "FacebookHandler.h"
#import "FeedItem.h"
#import <FacebookSDK/FacebookSDK.h>

NSString *const FBUserDidLoginNotification = @"FBUserDidLoginNotification";
NSString *const FBUserDidLogoutNotification = @"FBUserDidLogoutNotification";

@interface FacebookHandler ()
@property (nonatomic, strong) NSDictionary<FBGraphUser> *fbUser;
@end

@implementation FacebookHandler
@synthesize fbUser;

+ (id)sharedInstance
{
    static FacebookHandler *instance = nil;
    if(instance == nil)
    {
        @synchronized(self)
        {
            instance = [[FacebookHandler alloc] init];
        }
    }
    
    return instance;
}

- (void)loginIfNeeded
{
    if (FBSession.activeSession.state == FBSessionStateCreatedTokenLoaded) {
       
        NSLog(@"cached Login");
        if(![self openSessionFromCache:YES])
        {
            NSLog(@"manual login");
            [self openSessionFromCache:NO];
        }
    }
    else
    {
         NSLog(@"manual login");
        [self openSessionFromCache:NO];
    }
}

- (void)logout
{
    [FBSession.activeSession closeAndClearTokenInformation];
}

- (BOOL)isLoggedIn
{
    return (FBSession.activeSession.isOpen);
}

- (void)sessionStateChanged:(FBSession *)session
                      state:(FBSessionState) state
                      error:(NSError *)error
{
    switch (state)
    {
        case FBSessionStateOpen:
        {
            [self fetchUserDetails];
            [[NSNotificationCenter defaultCenter] postNotificationName:FBUserDidLoginNotification object:session];
            break;
        }
            
        
        case FBSessionStateClosed:
            [[NSNotificationCenter defaultCenter] postNotificationName:FBUserDidLogoutNotification object:session];
            break;
        case FBSessionStateClosedLoginFailed:
            // Once the user has logged in, we want them to
            // be looking at the root view.
            
            [FBSession.activeSession closeAndClearTokenInformation];
            
            // maybe try to openSession again
            break;
        default:
            break;
    }
    
    if (error)
    {
        UIAlertView *alertView = [[UIAlertView alloc]
                                  initWithTitle:@"Error connecting to Facebook"
                                  message:error.localizedDescription
                                  delegate:nil
                                  cancelButtonTitle:@"OK"
                                  otherButtonTitles:nil];
        [alertView show];
    }
}

- (void)fetchUserDetails
{
    if (FBSession.activeSession.isOpen)
    {
        [[FBRequest requestForMe] startWithCompletionHandler:
         ^(FBRequestConnection *connection,
           NSDictionary<FBGraphUser> *user,
           NSError *error) {
             if (!error) {
                 self.fbUser = user;
             }
         }];
    }
}

- (void)getAccessIfNeeded
{
    if ([FBSession.activeSession.permissions indexOfObject:@"publish_actions"] == NSNotFound) {
        // if we don't already have the permission, then we request it now
        [FBSession.activeSession requestNewPublishPermissions:@[@"publish_actions"]
                                              defaultAudience:FBSessionDefaultAudienceFriends
                                            completionHandler:^(FBSession *session, NSError *error) {
                                                if (!error) {
                                                   
                                                }
                                                //For this example, ignore errors (such as if user cancels).
                                            }];
    }
}

- (void)publishStoryWithFeedItem:(FeedItem *)item
{
    [self getAccessIfNeeded];
    
    /*NSDictionary *parameters = [NSDictionary dictionaryWithObjectsAndKeys:
        item.title , @"caption",
        item.description, @"description",
        item.imageURL.relativePath, @"picture",
        item.description, @"message",
    nil];
    
    NSString *element;
    
    NSEnumerator *enumerator = parameters.objectEnumerator;
    while (element = [enumerator nextObject]) {
        NSLog(@"Jo: %@", element);
    }*/
    
    static NSDateFormatter *formatter = nil;
    if(!formatter)
    {
        formatter  = [[NSDateFormatter alloc] init];
        [formatter setDateFormat:@"dd. MMMM, HH:mm:ss"];
        
    }
    
    NSDictionary *parameters = [[NSMutableDictionary alloc] initWithObjectsAndKeys:
        item.link, @"link",
      item.title, @"name",
     [formatter stringFromDate:item.pubDate],  @"caption",
     item.description, @"description",
     nil];
    
    
    
    [FBRequestConnection
     startWithGraphPath:@"me/feed"
     parameters:parameters
     HTTPMethod:@"POST"
     completionHandler:^(FBRequestConnection *connection,
                         id result,
                         NSError *error) {
         NSString *alertText;
         if (error) {
             alertText = [NSString stringWithFormat:
                          @"error: domain = %@, code = %d",
                          error.domain, error.code];
         } else {
             alertText = [NSString stringWithFormat:
                          @"Posted action, id: %@",
                          [result objectForKey:@"id"]];
         }
         // Show the result in an alert
         [[[UIAlertView alloc] initWithTitle:@"Result"
                                     message:alertText
                                    delegate:self
                           cancelButtonTitle:@"OK!"
                           otherButtonTitles:nil]
          show];
     }];
}

- (BOOL)openSessionFromCache:(BOOL)isCache
{
   return [FBSession openActiveSessionWithReadPermissions:nil
                                       allowLoginUI:!isCache
                                  completionHandler:
     ^(FBSession *session,
       FBSessionState state, NSError *error) {
         [self sessionStateChanged:session state:state error:error];
     }];
}

@end
