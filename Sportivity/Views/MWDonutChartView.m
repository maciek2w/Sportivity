//
//  MWDonutChartView.m
//  Sportivity
//
//  Created by Maciej Witaszek on 30/11/15.
//  Copyright © 2015 mawitech. All rights reserved.
//

#import "MWDonutChartView.h"

CGPoint calculateCGPointFromCGPoint(const CGPoint cgPoint, CGFloat angle, CGFloat length)
{
    CGPoint endPoint;
    endPoint.x = roundf(cgPoint.x + sinf(angle + M_PI_2) * length);
    endPoint.y = roundf(cgPoint.y - cosf(angle + M_PI_2) * length);
    
    return endPoint;
}

@implementation MWDonutChartView

- (void)setData:(NSDictionary<NSString *,NSNumber *> *)data
{
    [self willChangeValueForKey:NSStringFromSelector(@selector(data))];
    _data = data;
    [self didChangeValueForKey:NSStringFromSelector(@selector(data))];
    
    [self updateLayers];
}

- (void)updateLayers
{
    __block double totalTime = 0;
    [self.data enumerateKeysAndObjectsUsingBlock:^(NSString * _Nonnull key, NSNumber * _Nonnull value, BOOL * _Nonnull stop) {
        totalTime += [value doubleValue];
    }];
    
    CGFloat radiusExternal = CGRectGetHeight(self.bounds) / 2.0 - 30;
    CGFloat radiusInternal = radiusExternal - 30;

    __block CGFloat startAngle = 0;
    
    [self.data enumerateKeysAndObjectsUsingBlock:^(NSString * _Nonnull key, NSNumber * _Nonnull value, BOOL * _Nonnull stop) {
        double doubleValue = [value doubleValue];
        //doubleValue = 30;
        //totalTime = 100;
        CGFloat endAngle = startAngle + (M_PI * 2 * doubleValue / totalTime);
        
        UIBezierPath *path = [UIBezierPath bezierPath];
        [path moveToPoint:calculateCGPointFromCGPoint(self.center, startAngle, radiusInternal)];
        [path addLineToPoint:calculateCGPointFromCGPoint(self.center, startAngle, radiusExternal)];
        [path addArcWithCenter:self.center
                        radius:radiusExternal
                    startAngle:startAngle
                      endAngle:endAngle
                     clockwise:YES];
        [path addLineToPoint:calculateCGPointFromCGPoint(self.center, endAngle, radiusInternal)];
        
        [path addArcWithCenter:self.center
                        radius:radiusInternal
                    startAngle:endAngle
                      endAngle:startAngle
                     clockwise:NO];
        [path closePath];
        
        CAShapeLayer *shape = [CAShapeLayer layer];
        shape.path = path.CGPath;
        shape.fillColor = [UIColor colorWithRed:255/255.0 green:(doubleValue / totalTime) blue:147/255.0 alpha:1].CGColor;
        
        [self.layer addSublayer:shape];
        startAngle = endAngle;
        
        NSLog(@"type: %@ value: %.02f", key, doubleValue / totalTime);
    }];
}

@end
