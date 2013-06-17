//
//  NetworkManager.m
//  CrossmediaDemo
//
//  Created by Hendrik Näther on 12.06.13.
//  Copyright (c) 2013 Hendrik Näther. All rights reserved.
//

#import "NetworkManager.h"
#import "Reachability.h"
#import <SystemConfiguration/SystemConfiguration.h>

@implementation NetworkManager

+ (NetworkManager *)sharedInstance
{
    //  Static local predicate must be initialized to 0
    static NetworkManager *sharedInstance = nil;
    static dispatch_once_t onceToken = 0;
    dispatch_once(&onceToken, ^{
        sharedInstance = [[NetworkManager alloc] init];
        // Do any other initialisation stuff here
    });
    return sharedInstance;
}

- (BOOL)hasInternetConnection
{
    Reachability *reachability = [Reachability reachabilityForInternetConnection];
    NetworkStatus networkStatus = [reachability currentReachabilityStatus];
    return !(networkStatus == NotReachable);
}

- (void)showInternetError
{
    Reachability* reach = [Reachability reachabilityWithHostname:@"www.google.com"];
    
    // set the blocks
    reach.reachableBlock = ^(Reachability*reach)
    {
        [reach stopNotifier];
    };
    
    reach.unreachableBlock = ^(Reachability*reach)
    {
        
    };
    
    // start the notifier which will cause the reachability object to retain itself!
    [reach startNotifier];
}


@end
