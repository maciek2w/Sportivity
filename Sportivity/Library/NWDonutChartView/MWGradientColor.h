//
//  MWGradientColor.h
//  Sportivity
//
//  Created by Maciej Witaszek on 05/12/15.
//  Copyright © 2015 mawitech. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MWGradientColor : NSObject
- (instancetype)initWithStartColor:(UIColor *)startColor endColor:(UIColor *)endColor;
- (UIColor *)getColorWithOffset:(CGFloat)offset;
@end
