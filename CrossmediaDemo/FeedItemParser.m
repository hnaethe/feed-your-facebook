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
@property (nonatomic, strong) NSString *currentlyParsedText;
@property (nonatomic, strong) NSString *resultText;
@property (nonatomic, assign) int depth, cachedDepth;
@property (nonatomic, assign) BOOL foundItems;
@property (nonatomic, strong) FeedItem *feedItem;

@end

@implementation FeedItemParser
@synthesize delegate = _delegate;
@synthesize feed = _feed;
@synthesize feedItem = _feedItem;
@synthesize depth, cachedDepth;
@synthesize foundItems;

/*
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
    depth = 0;
    self.resultText = @"";
    foundItems = NO;
    
    NSXMLParser *parser = [[NSXMLParser alloc] initWithContentsOfURL:self.feed.url];
    [parser setDelegate:self];
    [parser parse];

}

- (void)parser:(NSXMLParser *)parser didStartElement:(NSString *)elementName namespaceURI:(NSString *)namespaceURI qualifiedName:(NSString *)qualifiedName attributes:(NSDictionary *)attributeDict
{
    if([elementName isEqualToString:@"item"])
    {
        foundItems = YES;
        self.feedItem = [[FeedItem alloc] init];
    }
    
    if(foundItems)
    {
        depth++;
        NSLog(@"Started element: %@ with depth: %d",elementName, depth);
        
        if([elementName isEqualToString:@"enclosure"] && ([[attributeDict valueForKey:@"type"] isEqualToString:@"image/jpg"] || [[attributeDict valueForKey:@"mime-type"] isEqualToString:@"image/jpeg"]))
        {
            self.feedItem.imageURL = [NSURL URLWithString:[attributeDict valueForKey:@"url"]];
        }
    }
}

- (void)parser:(NSXMLParser *)parser foundCharacters:(NSString *)string
{
    if(!foundItems) return;
    
    self.currentlyParsedText = string;
    
    if(cachedDepth == depth)
    {
        self.resultText = [self.resultText stringByAppendingString:self.currentlyParsedText];
    }
    else
    {
        self.resultText = self.currentlyParsedText;
    }
    
    cachedDepth = depth;
}

- (void)parser:(NSXMLParser *)parser didEndElement:(NSString *)elementName namespaceURI:(NSString *)namespaceURI qualifiedName:(NSString *)qName
{
    if(!foundItems) return;
    
    if([elementName isEqualToString:@"item"])
    {
        [self.feed.feedItems addObject:self.feedItem];
        if(self.delegate) [self.delegate feedItemParserFinishedItem:self.feedItem];
        
        self.resultText = @"";
        depth--;
        return;
    }
    
    if([elementName isEqualToString:@"title"])
    {
        self.feedItem.title = self.resultText;
        self.resultText = @"";
        depth--;
        return;
    }
        
    if([elementName isEqualToString:@"link"])
    {
        self.feedItem.link = self.resultText;
        self.resultText = @"";
        depth--;
        return;
    }
        
    if([elementName isEqualToString:@"description"])
    {
        self.feedItem.description = self.resultText;
        
        
        if(!self.feedItem.imageURL) [self parseImageIfPossible];
        
        self.resultText = @"";
        depth--;
        return;
    }
        
    if([elementName isEqualToString:@"pubDate"])
    {
        self.feedItem.pubDate = [self dateForString:self.resultText];
        self.resultText = @"";
        depth--;
        return;
    }
    
    if([elementName rangeOfString:@"content"].location != NSNotFound)
    {
        if(!self.feedItem.imageURL) [self parseImageIfPossible];
    }
    
    // if enclosure is part of the elementName string
    if([elementName rangeOfString:@"enclosure"].location != NSNotFound)
    {
        if(!self.feedItem.imageURL) [self parseImageIfPossible];
    }

    depth--;
    cachedDepth = depth;
}

- (void)parserDidEndDocument:(NSXMLParser *)parser
{
    [self.delegate feedItemParserDidFinish:self];
}

- (void)parser:(NSXMLParser *)parser parseErrorOccurred:(NSError *)parseError {
    
    NSString *errorString = [NSString stringWithFormat:@"Error code %i", [parseError code]];
    NSLog(@"Error parsing XML: %@", errorString);
    
}

- (void)parseImageIfPossible
{
    NSString *imageUrl = [self urlFromString:self.resultText];
    if(imageUrl)
    {
        self.feedItem.imageURL = [NSURL URLWithString:imageUrl];
    }
}

- (NSString *)urlFromString:(NSString *)string
{
    NSError *error = NULL;
    
    //(http://|https://)[^'\"<>]+(jpg|png|jpeg|gif) das [^'\"<>]+ bedeutet dass alle Zeichen außer denen in der Klammer
    // verwendet werden dürfen. Verhindert, dass ein bei einem Text mit mehreren Bildern auch mehrere Bilder als ein match gesehen werden
    // bspw. http://bild.jpg"> <bla> ... andersbild.jpg würde sonst auch matchen da ja alles Zeichen zwischen http und jpg zugelassen sind
    NSRegularExpression *regex = [NSRegularExpression regularExpressionWithPattern:@"(http://|https://)[^'\"<>]+(jpg|png|jpeg|gif)"
                                                                           options:NSRegularExpressionCaseInsensitive
                                                                             error:&error];
    
    NSArray *matches = [regex matchesInString:string options:0 range:NSMakeRange(0, [string length])];
    if([matches count] == 0) return nil;
    
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
