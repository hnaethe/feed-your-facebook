//
//  FacebookHandler.m
//  CrossmediaDemo
//
//  Created by Hendrik Näther on 25.04.13.
//  Copyright (c) 2013 Hendrik Näther. All rights reserved.
//

#import "FacebookHandler.h"
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
        [self openSession];
    } else {
        NSLog(@"manual login");
        [self openSession];
        
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

- (void)openSession
{
    [FBSession openActiveSessionWithReadPermissions:nil
                                       allowLoginUI:YES
                                  completionHandler:
     ^(FBSession *session,
       FBSessionState state, NSError *error) {
         [self sessionStateChanged:session state:state error:error];
     }];
}

@end
