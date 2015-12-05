//
//  MWDonutChartView.m
//  Sportivity
//
//  Created by Maciej Witaszek on 30/11/15.
//  Copyright © 2015 mawitech. All rights reserved.
//

#import "MWDonutChartView.h"
#import "MWGradientColor.h"

CGPoint calculateCGPointFromCGPoint(const CGPoint cgPoint, CGFloat angle, CGFloat length)
{
    CGPoint endPoint;
    endPoint.x = roundf(cgPoint.x + sinf(angle + M_PI_2) * length);
    endPoint.y = roundf(cgPoint.y - cosf(angle + M_PI_2) * length);
    
    return endPoint;
}

@interface MWDonutChartView ()
@property (nonatomic, assign) double totalSum;
@property (nonatomic, strong) NSArray *sortedValues;
@property (nonatomic, strong) MWGradientColor *gradient;
@end

@implementation MWDonutChartView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self setupView];
    }
    
    return self;
}

- (instancetype)initWithCoder:(NSCoder *)aDecoder
{
    self = [super initWithCoder:aDecoder];
    if (self) {
        [self setupView];
    }
    
    return self;
}

- (void)setupView
{
    self.percentageInnerCutout = 0.5;
    self.outerRadiusMargin = 20.0;
    self.gradient = [[MWGradientColor alloc] initWithStartColor:[UIColor colorWithRed:1 green:0 blue:0 alpha:1]
                                                       endColor:[UIColor colorWithRed:0 green:0 blue:1 alpha:1]];
}

- (void)setData:(NSDictionary<NSString *,NSNumber *> *)data
{
    [self willChangeValueForKey:NSStringFromSelector(@selector(data))];
    _data = data;
    [self didChangeValueForKey:NSStringFromSelector(@selector(data))];
    
    [self sortValues:_data];
    [self updateLayers];
}

- (void)sortValues:(NSDictionary<NSString *,NSNumber *> *)data
{
    NSMutableArray *values = [NSMutableArray array];
    
     __block CGFloat totalSum = 0;
    
    [data enumerateKeysAndObjectsUsingBlock:^(NSString * _Nonnull key, NSNumber * _Nonnull value, BOOL * _Nonnull stop) {
        totalSum += [value doubleValue];
        [values addObject:@{@"title": key, @"value": value}];
    }];
    
    self.totalSum = totalSum;
    
    self.sortedValues = [values sortedArrayUsingComparator:^NSComparisonResult(NSDictionary *obj1, NSDictionary *obj2) {
        return [obj1[@"value"] compare:obj2[@"value"]] == NSOrderedAscending;
    }];
}

- (void)updateLayers
{
    CGFloat radiusExternal = CGRectGetHeight(self.bounds) / 2.0 - self.outerRadiusMargin;
    CGFloat radiusInternal = self.percentageInnerCutout * radiusExternal;

    __block CGFloat startAngle = - M_PI_2;
    NSInteger valuesCount = [self.sortedValues count];
    
    [self.sortedValues enumerateObjectsUsingBlock:^(NSDictionary *obj, NSUInteger idx, BOOL * _Nonnull stop) {
        NSString *key = obj[@"title"];
        NSNumber *value = obj[@"value"];
        
        double doubleValue = [value doubleValue];
        CGFloat endAngle = startAngle + (M_PI * 2 * doubleValue / self.totalSum);
        
        CGFloat colorOffset = (CGFloat)idx / valuesCount;
        
        UIColor *color = [self.gradient getColorWithOffset:colorOffset];
        
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
        shape.fillColor = color.CGColor;
        shape.strokeColor = shape.fillColor;
        
        [self.layer addSublayer:shape];
        startAngle = endAngle;
        
        NSLog(@"type: %@ value: %.02f color:%@", key, doubleValue / self.totalSum, color);
    }];
}

@end