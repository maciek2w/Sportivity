//
//  MWDonutChartViewItemProtocol.h
//  Sportivity
//
//  Created by Maciej Witaszek on 06/12/15.
//  Copyright © 2015 mawitech. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol MWDonutChartViewItemProtocol <NSObject>
@property (nonatomic, strong) NSString *donutChartSegmentTitle;
@property (nonatomic, strong) UIColor *donutChartSegmentColor;
@property (nonatomic, assign) CGFloat donutChartSegmentValue;
@end
