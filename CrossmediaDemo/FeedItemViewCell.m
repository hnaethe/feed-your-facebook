//
//  FeedItemViewCell.m
//  CrossmediaDemo
//
//  Created by Hendrik Näther on 22.04.13.
//  Copyright (c) 2013 Hendrik Näther. All rights reserved.
//

#import "FeedItemViewCell.h"
#import "FeedItem.h"

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
        
        imageView = [[UIImageView alloc] initWithFrame:CGRectMake(5, 5, 43, 43)];
        imageView.backgroundColor = [UIColor orangeColor];
        
        titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(61, 7, 220, 20)];
        [titleLabel setFont:[UIFont fontWithName:@"HelveticaNeue" size:14]];
        [titleLabel setBackgroundColor:[UIColor clearColor]];
        [titleLabel setTextColor: [UIColor darkGrayColor]];
        
        pubDateLabel = [[UILabel alloc] initWithFrame:CGRectMake(61, 25, 220, 20)];
        [pubDateLabel setFont:[UIFont fontWithName:@"HelveticaNeue" size:12]];
        [pubDateLabel setBackgroundColor:[UIColor clearColor]];
        [pubDateLabel setTextColor:[UIColor lightGrayColor]];
        
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
        [formatter setDateFormat:@"dd. MMMM, HH:mm:ss"];
        
    }
    pubDateLabel.text = [formatter stringFromDate:feedItem.pubDate];
    
    if(feedItem.image)
    {
        imageView.image = feedItem.image;
    }
    
    self.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
