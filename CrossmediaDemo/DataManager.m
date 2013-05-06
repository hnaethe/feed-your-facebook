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
    
    path = [[NSBundle mainBundle] pathForResource:@"test" ofType:@"plist"];
    if([[NSFileManager defaultManager] fileExistsAtPath:path])
        return path;
    
    NSLog(@"ERROR: Could not find file %@", fileName);
    
    return path;
}

- (void)createFileAtPath:(NSString *)filePath
{
    //[NSFileManager defaultManager] createFileAtPath:filePath contents:<#(NSData *)#> attributes:
}

- (void)saveFeed:(Feed *)feed
{
    NSMutableDictionary *dataDict = [[NSMutableDictionary alloc] initWithContentsOfFile:filePath];
    [dataDict setObject:feed.url forKey:feed.url];
    
    [dataDict writeToFile:filePath atomically:YES];
}

- (NSArray *)loadFeeds
{
    
    NSMutableArray *array = @[];
    NSDictionary *dataDict = [[NSDictionary alloc] initWithContentsOfFile:filePath];
    
    
    NSEnumerator
}


@end
