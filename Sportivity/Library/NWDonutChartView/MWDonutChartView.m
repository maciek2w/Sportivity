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
@property (nonatomic, strong) MWGradientColor *gradient;
@property (nonatomic, strong) NSMutableArray *shapes;
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
    self.gradient = [[MWGradientColor alloc] initWithStartColor:[UIColor colorWithRed:217.0/255.0 green:15.0/255.0 blue:43.0/255.0 alpha:1] //D90F2B
                                                       endColor:[UIColor colorWithRed:83.0/255.0 green:200.0/255.0 blue:14.0/255.0 alpha:1]]; //53C80E
}

- (void)setData:(NSArray<id<MWDonutChartViewItemProtocol>> *)data
{
    [self willChangeValueForKey:NSStringFromSelector(@selector(data))];
    _data = data;
    [self didChangeValueForKey:NSStringFromSelector(@selector(data))];
    
    [self calculateTotalSumWithData:_data];
    [self updateLayers];
}

- (NSMutableArray *)shapes
{
    if (_shapes == nil) {
        _shapes = [NSMutableArray array];
    }
    
    return _shapes;
}

- (void)calculateTotalSumWithData:(NSArray<id<MWDonutChartViewItemProtocol>> *)data
{
    CGFloat totalSum = 0;
    
    for (id<MWDonutChartViewItemProtocol> obj in data) {
        totalSum += obj.donutChartSegmentValue;
    }
    
    self.totalSum = totalSum;
}

- (void)updateLayers
{
    for (CAShapeLayer *shape in self.shapes) {
        [shape removeFromSuperlayer];
    }
    
    self.shapes = nil;
    
    CGFloat radiusExternal = CGRectGetHeight(self.bounds) / 2.0 - self.outerRadiusMargin;
    CGFloat radiusInternal = self.percentageInnerCutout * radiusExternal;

    __block CGFloat startAngle = - M_PI_2;
    NSInteger valuesCount = [self.data count];
    
    NSMutableDictionary *colorAssignment = [[NSMutableDictionary alloc] init];
    
    [self.data enumerateObjectsUsingBlock:^(id<MWDonutChartViewItemProtocol>  _Nonnull item, NSUInteger idx, BOOL * _Nonnull stop) {
        NSString *key = item.donutChartSegmentTitle;
        CGFloat value = item.donutChartSegmentValue;
        
        CGFloat endAngle = startAngle + (M_PI * 2 * value / self.totalSum);
        
        CGFloat colorOffset = valuesCount > 0 ? (CGFloat)idx / (valuesCount - 1) : 0;
        
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
        [self.shapes addObject:shape];
        colorAssignment[key] = color;
        startAngle = endAngle;
        
        NSLog(@"type: %@ value: %.02f color:%@", key, value / self.totalSum, color);
    }];
}

@end
