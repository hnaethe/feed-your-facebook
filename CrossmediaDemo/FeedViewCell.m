//
//  FeedViewCell.m
//  CrossmediaDemo
//
//  Created by Hendrik Näther on 21.04.13.
//  Copyright (c) 2013 Hendrik Näther. All rights reserved.
//


#import "FeedViewCell.h"
#import "Feed.h"

@interface FeedViewCell()

@property (nonatomic, strong) UILabel *loadingLabel;
@property (nonatomic, strong) UIActivityIndicatorView *activityIndicator;

@property (nonatomic, strong) UIImageView *imageView;
@property (nonatomic, strong) UILabel *titleLabel;
@property (nonatomic, strong) UILabel *pubDateLabel;
@end


@implementation FeedViewCell
@synthesize loadingLabel, activityIndicator, imageView, titleLabel, pubDateLabel;

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
        
        loadingLabel = [[UILabel alloc] initWithFrame:CGRectMake(45, 3, 260, 45)];
        [loadingLabel setFont:[UIFont fontWithName:@"HelveticaNeue" size:14]];
        [loadingLabel setBackgroundColor:[UIColor clearColor]];
        [loadingLabel setTextColor: [UIColor darkGrayColor]];
        [loadingLabel setNumberOfLines:2];
        
        activityIndicator = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
        activityIndicator.frame = CGRectMake(8, 10, 30, 30);
        activityIndicator.hidden = YES;
        
        
        imageView = [[UIImageView alloc] initWithFrame:CGRectMake(5, 5, 43, 43)];
        imageView.backgroundColor = [UIColor orangeColor];
        imageView.image = [UIImage imageNamed:@"song-placeholder.png"];
        
        titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(61, 7, 220, 20)];
        [titleLabel setFont:[UIFont fontWithName:@"HelveticaNeue" size:14]];
        [titleLabel setBackgroundColor:[UIColor clearColor]];
        [titleLabel setTextColor: [UIColor darkGrayColor]];
        
        pubDateLabel = [[UILabel alloc] initWithFrame:CGRectMake(61, 25, 220, 20)];
        [pubDateLabel setFont:[UIFont fontWithName:@"HelveticaNeue" size:12]];
        [pubDateLabel setBackgroundColor:[UIColor clearColor]];
        [pubDateLabel setTextColor:[UIColor lightGrayColor]];
        
        
        [self.contentView addSubview:loadingLabel];
        [self.contentView addSubview:activityIndicator];
        
        [self.contentView addSubview:imageView];
        [self.contentView addSubview:titleLabel];
        [self.contentView addSubview:pubDateLabel];

    }
    return self;
}

- (void)setFeed:(Feed *)feed
{
    
    if(feed.isParsing)
    {
        [self showLoadingState:feed];
    }
    else
    {
        [self showNormalState:feed];
    }
}

- (void)showLoadingState:(Feed *)feed
{
    titleLabel.hidden = YES;
    pubDateLabel.hidden = YES;
    imageView.hidden = YES;
    
    loadingLabel.hidden = NO;
    loadingLabel.text = [NSString stringWithFormat:@"Lade Daten von %@", feed.url];
    
    activityIndicator.hidden = NO;
    [activityIndicator startAnimating];
}

- (void)showNormalState:(Feed *)feed
{
    [activityIndicator stopAnimating];
    activityIndicator.hidden = YES;
    
    titleLabel.hidden = NO;
    pubDateLabel.hidden = NO;
    imageView.hidden = NO;
    
    loadingLabel.hidden = YES;
    
    
    titleLabel.text = feed.title;
    
    static NSDateFormatter *formatter = nil;
    if(!formatter)
    {
        formatter  = [[NSDateFormatter alloc] init];
        [formatter setDateFormat:@"dd. MMMM, HH:mm:ss"];
        
    }
    pubDateLabel.text = [formatter stringFromDate:feed.pubDate];
    
    if(feed.image)
    {
        imageView.image = feed.image;
    }
    
    
    if([feed.feedItems count] > 0 )
    {
        self.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    }
    else
    {
        self.accessoryType = UITableViewCellAccessoryNone;
    }

}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
