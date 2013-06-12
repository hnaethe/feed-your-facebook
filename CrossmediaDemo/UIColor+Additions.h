//
//  UIColor+Additions.h
//  SalesDJ
//
//  Created by Hendrik Näther on 27.12.12.
//  Copyright (c) 2012 itCampus. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIColor (Additions)

+ (UIColor *)calculatedColorWithRed:(int)red green:(int)green blue:(int)blue alpha:(int)alpha;

+ (UIColor *)colorFromHexString:(NSString *)hexString;

@end
