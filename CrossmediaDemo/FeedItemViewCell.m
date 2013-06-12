//
//  FeedItemViewCell.m
//  CrossmediaDemo
//
//  Created by Hendrik Näther on 22.04.13.
//  Copyright (c) 2013 Hendrik Näther. All rights reserved.
//

#import "FeedItemViewCell.h"
#import "FeedItem.h"
#import "UIColor+Additions.h"

@interface FeedItemViewCell ()
@property (nonatomic, strong) UIImageView *imageView;
@property (nonatomic, strong) UILabel *titleLabel;
@property (nonatomic, strong) UILabel *pubDateLabel;
@end

@implementation FeedItemViewCell
@synthesize imageView, titleLabel, pubDateLabel;

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
        
        imageView = [[UIImageView alloc] initWithFrame:CGRectMake(5, 15, 43, 43)];
        imageView.backgroundColor = [UIColor colorFromHexString:@"#dddddd"];
        
        titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(53, 17, 240, 40)];
        [titleLabel setFont:[UIFont fontWithName:@"HelveticaNeue" size:14]];
        [titleLabel setBackgroundColor:[UIColor clearColor]];
        titleLabel.numberOfLines = 2;
        [titleLabel setTextColor: [UIColor darkGrayColor]];
        //titleLabel.backgroundColor = [UIColor lightGrayColor];
        
        pubDateLabel = [[UILabel alloc] initWithFrame:CGRectMake(245, 4, 70, 20)];
        [pubDateLabel setFont:[UIFont fontWithName:@"HelveticaNeue" size:10]];
        [pubDateLabel setBackgroundColor:[UIColor clearColor]];
        pubDateLabel.textAlignment = NSTextAlignmentRight;
        [pubDateLabel setTextColor:[UIColor lightGrayColor]];
        //pubDateLabel.backgroundColor = [UIColor darkGrayColor];
        
        [self.contentView addSubview:imageView];
        [self.contentView addSubview:titleLabel];
        [self.contentView addSubview:pubDateLabel];
        
    }
    return self;
}

- (void)setFeedItem:(FeedItem *)feedItem
{
    titleLabel.text = feedItem.title;
    
    static NSDateFormatter *formatter = nil;
    if(!formatter)
    {
        formatter  = [[NSDateFormatter alloc] init];
        [formatter setLocale:[[NSLocale alloc] initWithLocaleIdentifier:@"de_DE"]];
        [formatter setTimeZone:[NSTimeZone systemTimeZone]];
        [formatter setDateFormat:@"dd. MMMM, HH:mm"];
        
    }
    pubDateLabel.text = [formatter stringFromDate:feedItem.pubDate];
    
    if(feedItem.image)
    {
        imageView.image = feedItem.image;
    }
    else
    {
        imageView.image = nil;
    }
    
    //self.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
