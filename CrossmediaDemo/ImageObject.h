//
//  ImageObject.h
//  CrossmediaDemo
//
//  Created by Hendrik Näther on 10.06.13.
//  Copyright (c) 2013 Hendrik Näther. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ImageObject : NSObject
@property (nonatomic, strong) NSURL *imageURL;
@property (nonatomic, strong) UIImage *image;
@property (nonatomic, assign) int iconSize;
@end
