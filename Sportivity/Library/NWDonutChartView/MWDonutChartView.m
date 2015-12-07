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
    endPoint.x = cgPoint.x + sinf(angle + M_PI_2) * length;
    endPoint.y = cgPoint.y - cosf(angle + M_PI_2) * length;
    
    return endPoint;
}

@interface MWDonutChartView ()
@property (nonatomic, assign) double totalSum;
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
    
    [self.data enumerateObjectsUsingBlock:^(id<MWDonutChartViewItemProtocol>  _Nonnull item, NSUInteger idx, BOOL * _Nonnull stop) {
        CGFloat value = item.donutChartSegmentValue;
        
        CGFloat endAngle = startAngle + (M_PI * 2 * value / self.totalSum);
        
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
        shape.fillColor = item.donutChartSegmentColor.CGColor;
        shape.strokeColor = shape.fillColor;
        
        [self.layer addSublayer:shape];
        [self.shapes addObject:shape];
        startAngle = endAngle;
    }];
}

@end
