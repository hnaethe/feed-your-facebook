//
//  ChannelParser.m
//  CrossmediaDemo
//
//  Created by Hendrik Näther on 09.06.13.
//  Copyright (c) 2013 Hendrik Näther. All rights reserved.
//

#import "ChannelParser.h"
#import "Feed.h"

@interface ChannelParser ()
@property (nonatomic, strong) NSString *currentlyParsedText;
@property (nonatomic, strong) NSString *resultText;
@property (nonatomic, assign) int depth, cachedDepth;
@property (nonatomic, assign) BOOL didFinish;
@end

@implementation ChannelParser
@synthesize delegate = _delegate;
@synthesize feed = _feed;
@synthesize currentlyParsedText = _currentlyParsedText;
@synthesize resultText = _resultText;
@synthesize depth, cachedDepth;
@synthesize didFinish;

- (void)parseChannelFromFeed:(Feed *)rssFeed
{
    self.feed = rssFeed;
    depth = 0;
    cachedDepth = 0;
    didFinish = NO;
    self.resultText = @"";
    
    NSXMLParser *parser = [[NSXMLParser alloc] initWithContentsOfURL:self.feed.url];
    [parser setDelegate:self];
    [parser parse];
    
}

- (void)parser:(NSXMLParser *)parser didStartElement:(NSString *)elementName namespaceURI:(NSString *)namespaceURI qualifiedName:(NSString *)qualifiedName attributes:(NSDictionary *)attributeDict
{
    if(didFinish) return;
    
    depth++;
    NSLog(@"Started element: %@ depth: %d",elementName, depth);
    
    if([elementName isEqualToString:@"item"])
    {
        didFinish = YES;
    }
}

- (void)parser:(NSXMLParser *)parser foundCharacters:(NSString *)string
{
    self.currentlyParsedText = string;
}

- (void)parser:(NSXMLParser *)parser didEndElement:(NSString *)elementName namespaceURI:(NSString *)namespaceURI qualifiedName:(NSString *)qName
{
    if(didFinish) return;
    
    //means that the parser did not step into the the next element but remains still in the same element
    if(cachedDepth == depth)
    {
        self.resultText = [self.resultText stringByAppendingString:self.currentlyParsedText];
    }
    else
    {
        self.resultText = self.currentlyParsedText;
    }
    
    if([elementName isEqualToString:@"title"])
    {
        if(depth == 3)
        {
            self.feed.title = self.resultText;
            self.resultText = @"";
            
        }
        depth--;
        // ist Tiefe noch tiefer kann es nur der Titel des Images sein
        return;
    }
        
    if([elementName isEqualToString:@"link"])
    {
        self.feed.linkToWebsite = self.resultText;
        self.resultText = @"";
        depth--;
        return;
    }
        
    if([elementName isEqualToString:@"description"])
    {
        self.feed.description = self.resultText;
        self.resultText = @"";
        depth--;
        return;
    }
        
    if([elementName isEqualToString:@"pubDate"])
    {
        self.feed.pubDate = [self dateForString:self.resultText];
        self.resultText = @"";
        depth--;
        return;
    }
        
    if([elementName isEqualToString:@"lastBuildDate"])
    {
        self.feed.lastBuildDate = [self dateForString:self.resultText];
        self.resultText = @"";
        depth--;
        return;
    }
        
    if([elementName isEqualToString:@"url"])
    {
        self.feed.imageURL = [NSURL URLWithString:self.resultText];
        self.resultText = @"";
        depth--;
        return;
    }
    
    depth--;
    cachedDepth = depth;
}

- (void)parserDidEndDocument:(NSXMLParser *)parser
{
    if(self.delegate)
    {
        [self.delegate channelParserDidFinish:self];
    }
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
