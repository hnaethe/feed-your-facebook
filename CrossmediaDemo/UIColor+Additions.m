//
//  UIColor+Additions.m
//  SalesDJ
//
//  Created by Hendrik Näther on 27.12.12.
//  Copyright (c) 2012 itCampus. All rights reserved.
//

#import "UIColor+Additions.h"

@implementation UIColor (Additions)

+ (UIColor *)calculatedColorWithRed:(int)red green:(int)green blue:(int)blue alpha:(int)alpha
{
    if(alpha == 1){
        return [UIColor colorWithRed:red/255.f green:green/255.f blue:blue/255.f alpha:255.f];

    }
    return [UIColor colorWithRed:red/255.f green:green/255.f blue:blue/255.f alpha:alpha/255.f];
}

+ (UIColor *)colorFromHexString:(NSString *)hexString
{
    unsigned rgbValue = 0;
    NSScanner *scanner = [NSScanner scannerWithString:hexString];
    [scanner setScanLocation:1]; // bypass '#' character
    [scanner scanHexInt:&rgbValue];
    return [UIColor colorWithRed:((rgbValue & 0xFF0000) >> 16)/255.0 green:((rgbValue & 0xFF00) >> 8)/255.0 blue:(rgbValue & 0xFF)/255.0 alpha:1.0];
}
@end
