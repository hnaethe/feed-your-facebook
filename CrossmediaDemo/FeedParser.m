//
//  FeedFetcher.m
//  CrossmediaDemo
//
//  Created by Hendrik Näther on 19.04.13.
//  Copyright (c) 2013 Hendrik Näther. All rights reserved.
//

#import "FeedParser.h"
#import "Feed.h"
#import "FeedItem.h"

@interface FeedParser()
@property (nonatomic, strong) FeedItem *feedItem;
@end

@implementation FeedParser
@synthesize delegate;
@synthesize feed;
@synthesize feedItem;

BOOL didEndFeedHeader;
BOOL foundTitleForFeed;
NSString *currentlyParsedText;

- (void)parseXMLFileFromFeed:(Feed *)rssFeed
{
    self.feed = rssFeed;
    didEndFeedHeader = NO;
    foundTitleForFeed = NO;
    NSXMLParser *parser = [[NSXMLParser alloc] initWithContentsOfURL:feed.url];
    [parser setDelegate:self];
    [parser parse];

}

- (void)parser:(NSXMLParser *)parser didStartElement:(NSString *)elementName namespaceURI:(NSString *)namespaceURI qualifiedName:(NSString *)qualifiedName attributes:(NSDictionary *)attributeDict
{
    if([elementName isEqualToString:@"item"])
    {
        feedItem = [[FeedItem alloc] init];
        didEndFeedHeader = YES;
    }
}

- (void)parser:(NSXMLParser *)parser foundCharacters:(NSString *)string
{
    currentlyParsedText = string;
}

- (void)parser:(NSXMLParser *)parser didEndElement:(NSString *)elementName namespaceURI:(NSString *)namespaceURI qualifiedName:(NSString *)qName
{

    if(!didEndFeedHeader)
    {

        if([elementName isEqualToString:@"title"] && !foundTitleForFeed)
        {
            feed.title = currentlyParsedText;
            foundTitleForFeed = YES;
            return;
        }
        
        if([elementName isEqualToString:@"link"])
        {
            feed.linkToWebsite = currentlyParsedText;
            return;
        }
        
        if([elementName isEqualToString:@"description"])
        {
            feed.description = currentlyParsedText;
            return;
        }
        
        if([elementName isEqualToString:@"pubDate"])
        {
            
            feed.pubDate = [self dateForString:currentlyParsedText];
            return;
        }
        
        if([elementName isEqualToString:@"lastBuildDate"])
        {
            feed.lastBuildDate = [self dateForString:currentlyParsedText];
            return;
        }
        
        if([elementName isEqualToString:@"url"])
        {
            feed.imageURL = [NSURL URLWithString:currentlyParsedText];
            
            // this is done synchronously so consider this to be lame as hell!
           /* NSData *data = [NSData dataWithContentsOfURL:feed.imageURL];
            feed.image = [[UIImage alloc] initWithData:data];*/
            return;
        }
        
        if([elementName isEqualToString:@"width"])
        {
            feed.imageWidth = @([currentlyParsedText intValue]);
            return;
        }
        
        if([elementName isEqualToString:@"height"])
        {
            feed.imageHeight = @([currentlyParsedText intValue]);
            return;
        }
        
        return;
    }
    
    if([elementName isEqualToString:@"item"])
    {
        [feed.feedItems addObject:feedItem];
    }
    else
    {
        if([elementName isEqualToString:@"title"])
        {
            feedItem.title = currentlyParsedText;
        }
        
        if([elementName isEqualToString:@"link"])
        {
            feedItem.link = currentlyParsedText;
        }
        
        if([elementName isEqualToString:@"description"])
        {
            feedItem.description = currentlyParsedText;
        }
        
        if([elementName isEqualToString:@"pubDate"])
        {
            
            feedItem.pubDate = [self dateForString:currentlyParsedText];
        }
    }
}

- (void)parserDidEndDocument:(NSXMLParser *)parser
{
    [feed stringValue];
    [delegate parserDidFinish:self];
}

- (void)parser:(NSXMLParser *)parser parseErrorOccurred:(NSError *)parseError {
    
    NSString *errorString = [NSString stringWithFormat:@"Error code %i", [parseError code]];
    NSLog(@"Error parsing XML: %@", errorString);
    
}

- (NSDate *)dateForString:(NSString*)dateString
{
    //Tue, 16 Apr 2013 21:06:06 +0100
    static NSDateFormatter *formatter = nil;
    if (!formatter) {
        formatter = [[NSDateFormatter alloc] init];
        [formatter setFormatterBehavior:NSDateFormatterBehavior10_4];
        // Need to force US locale when generating otherwise it might not be 822 compatible
        [formatter setLocale:[[NSLocale alloc] initWithLocaleIdentifier:@"en_US"]];
        [formatter setTimeZone:[NSTimeZone timeZoneForSecondsFromGMT:0]];
        [formatter setDateFormat:@"EEE, dd MMM yyyy HH:mm:ss ZZZ"];
    }
    return [formatter dateFromString:dateString];
}


@end
