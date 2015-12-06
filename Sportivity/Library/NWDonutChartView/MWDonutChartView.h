//
//  MWDonutChartView.h
//  Sportivity
//
//  Created by Maciej Witaszek on 30/11/15.
//  Copyright © 2015 mawitech. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MWDonutChartViewItemProtocol.h"

@interface MWDonutChartView : UIView
@property (nonatomic, assign) CGFloat percentageInnerCutout;
@property (nonatomic, assign) CGFloat outerRadiusMargin;
@property (nonatomic, strong) NSArray<id<MWDonutChartViewItemProtocol>> *data;
@end
