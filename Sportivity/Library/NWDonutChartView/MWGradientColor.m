//
//  MWGradientColor.m
//  Sportivity
//
//  Created by Maciej Witaszek on 05/12/15.
//  Copyright © 2015 mawitech. All rights reserved.
//

#import "MWGradientColor.h"

@interface MWGradientColor () {
    CGFloat _red1, _green1, _blue1;
    CGFloat _red2, _green2, _blue2;
}
@property (nonatomic, strong) UIColor *startColor;
@property (nonatomic, strong) UIColor *endColor;
@end

@implementation MWGradientColor

- (instancetype)initWithStartColor:(UIColor *)startColor endColor:(UIColor *)endColor
{
    self = [super init];
    if (self) {
        [startColor getRed:&_red1 green:&_green1 blue:&_blue1 alpha:NULL];
        [endColor getRed:&_red2 green:&_green2 blue:&_blue2 alpha:NULL];
    }
    
    return self;
}

- (UIColor *)getColorWithOffset:(CGFloat)offset
{
    CGFloat resultRed = _red1 + offset * (_red2 - _red1);
    CGFloat resultGreen = _green1 + offset * (_green2 - _green1);
    CGFloat resultBlue = _blue1 + offset * (_blue2 - _blue1);
    
    UIColor *color = [UIColor colorWithRed:resultRed green:resultGreen blue:resultBlue alpha:1];
    
    return color;
}
@end
