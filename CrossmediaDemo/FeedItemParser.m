//
//  FeedFetcher.m
//  CrossmediaDemo
//
//  Created by Hendrik Näther on 19.04.13.
//  Copyright (c) 2013 Hendrik Näther. All rights reserved.
//

#import "FeedItemParser.h"
#import "Feed.h"
#import "FeedItem.h"

@interface FeedItemParser()
@property (nonatomic, strong) FeedItem *feedItem;
@end

@implementation FeedItemParser
@synthesize delegate;
@synthesize feed;
@synthesize feedItem;

BOOL didEndFeedHeader;
BOOL foundTitleForFeed;
NSString *currentlyParsedText;
NSString *resultText;
int tagDepth;

/*
 rss
    channel
        title 
        link
        description
        language
        pubDate
        lastBuildDate
        image
            title
            link
            url
        
        item
            title
            link
            description ->img in CDATA
            pubDate
            content:encoded ->img
            enclosure ->img
 */

- (void)parseFeedItemsFromFeed:(Feed *)rssFeed
{
    self.feed = rssFeed;
    didEndFeedHeader = NO;
    foundTitleForFeed = NO;
    tagDepth = 0;
    NSXMLParser *parser = [[NSXMLParser alloc] initWithContentsOfURL:feed.url];
    [parser setDelegate:self];
    [parser parse];

}

- (void)parser:(NSXMLParser *)parser didStartElement:(NSString *)elementName namespaceURI:(NSString *)namespaceURI qualifiedName:(NSString *)qualifiedName attributes:(NSDictionary *)attributeDict
{
    tagDepth++;
    NSLog(@"Started element: %@ with depth: %d",elementName, tagDepth);
    
    if([elementName isEqualToString:@"item"])
    {
        feedItem = [[FeedItem alloc] init];
        didEndFeedHeader = YES;
    }
}

- (void)parser:(NSXMLParser *)parser foundCharacters:(NSString *)string
{
    //if([string isEqualToString:@""] || [string isEqualToString:@" "]) return;
    currentlyParsedText = string; //bricht teilweise bei äöü ab, deswegen konkatenieren
}

- (void)parser:(NSXMLParser *)parser didEndElement:(NSString *)elementName namespaceURI:(NSString *)namespaceURI qualifiedName:(NSString *)qName
{
    tagDepth--;
    resultText = currentlyParsedText;
    currentlyParsedText = @"";

    if(!didEndFeedHeader)
    {

        if([elementName isEqualToString:@"title"] && !foundTitleForFeed)
        {
            feed.title = resultText;
            foundTitleForFeed = YES;
            return;
        }
        
        if([elementName isEqualToString:@"link"])
        {
            feed.linkToWebsite = resultText;
            return;
        }
        
        if([elementName isEqualToString:@"description"])
        {
            feed.description = resultText;
            return;
        }
        
        if([elementName isEqualToString:@"pubDate"])
        {
            
            feed.pubDate = [self dateForString:resultText];
            return;
        }
        
        if([elementName isEqualToString:@"lastBuildDate"])
        {
            feed.lastBuildDate = [self dateForString:resultText];
            return;
        }
        
        if([elementName isEqualToString:@"url"])
        {
            feed.imageURL = [NSURL URLWithString:resultText];
            
            // this is done synchronously so consider this to be lame as hell!
           /* NSData *data = [NSData dataWithContentsOfURL:feed.imageURL];
            feed.image = [[UIImage alloc] initWithData:data];*/
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
            feedItem.title = resultText;
        }
        
        if([elementName isEqualToString:@"link"])
        {
            feedItem.link = resultText;
        }
        
        if([elementName isEqualToString:@"description"])
        {
            feedItem.description = resultText;
        }
        
        if([elementName isEqualToString:@"pubDate"])
        {
            
            feedItem.pubDate = [self dateForString:resultText];
        }
    }
    
    NSLog(@"Tiefe für Element %@ ist %d", elementName, tagDepth);
}

- (void)parserDidEndDocument:(NSXMLParser *)parser
{
    [delegate feedItemParserDidFinish:self];
}

- (void)parser:(NSXMLParser *)parser parseErrorOccurred:(NSError *)parseError {
    
    NSString *errorString = [NSString stringWithFormat:@"Error code %i", [parseError code]];
    NSLog(@"Error parsing XML: %@", errorString);
    
}

- (NSString *)urlFromString:(NSString *)string
{
    NSError *error = NULL;
    NSRegularExpression *regex = [NSRegularExpression regularExpressionWithPattern:@"(http://|https://).+(jpg|png)"
                                                                           options:NSRegularExpressionCaseInsensitive
                                                                             error:&error];
    
    NSArray *matches = [regex matchesInString:string options:0 range:NSMakeRange(0, [string length])];
    NSTextCheckingResult *match = [matches objectAtIndex:0];
    NSString *matchString = [string substringWithRange:[match range]];
    
    return matchString;
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
