//
//  DataManager.m
//  CrossmediaDemo
//
//  Created by Hendrik Näther on 04.05.13.
//  Copyright (c) 2013 Hendrik Näther. All rights reserved.
//

#import "DataManager.h"
#import "Feed.h"

@interface DataManager ()
@property (nonatomic, strong) NSString *filePath;
@end

@implementation DataManager
@synthesize filePath;

- (id)initWithFileName:(NSString *)fileName
{
    self = [super init];
    if(self)
    {
        self.filePath = [self pathForName:fileName];
    }
    return self;
}

- (NSString *)pathForName:(NSString *)fileName
{
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentsDirectory = [paths objectAtIndex:0];
    
    NSString *path = [documentsDirectory stringByAppendingPathComponent:fileName];
    if([[NSFileManager defaultManager] fileExistsAtPath:path])
        return path;
    
    NSLog(@"WARNING: Could not find file %@ - creating a new one", fileName);
    
    NSMutableDictionary *rootDictionary = [[NSMutableDictionary alloc] init];
    [rootDictionary writeToFile:path atomically:YES];
    
    return path;
}

- (void)createFileAtPath:(NSString *)filePath
{
    //[NSFileManager defaultManager] createFileAtPath:filePath contents:<#(NSData *)#> attributes:
}

- (void)resetStore
{
    [[NSFileManager defaultManager] removeItemAtPath:filePath error:nil];
}

- (void)saveFeed:(Feed *)feed
{
    NSMutableDictionary *dataDict = [[NSMutableDictionary alloc] initWithContentsOfFile:filePath];
    [dataDict setObject:feed.url.absoluteString forKey:feed.url.absoluteString];
    
    BOOL success = [dataDict writeToFile:filePath atomically:YES];
    if(!success)NSLog(@"WARN: Write to file %@ not successful.", filePath);
}

- (NSMutableArray *)loadFeeds
{
    NSMutableArray *feeds = [[NSMutableArray alloc] init];
    NSDictionary *dataDict = [[NSDictionary alloc] initWithContentsOfFile:filePath];
    
    NSString *element = nil;
    NSEnumerator *enumerator = dataDict.objectEnumerator;
    while (element = [enumerator nextObject]) {
        [feeds addObject:[[NSURL alloc] initWithString:element]];
    }
    return feeds;
}


@end
