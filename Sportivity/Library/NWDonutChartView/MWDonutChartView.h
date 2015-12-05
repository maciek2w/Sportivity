//
//  MWDonutChartView.h
//  Sportivity
//
//  Created by Maciej Witaszek on 30/11/15.
//  Copyright © 2015 mawitech. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MWDonutChartView : UIView
@property (nonatomic, assign) CGFloat percentageInnerCutout;
@property (nonatomic, assign) CGFloat outerRadiusMargin;
@property (nonatomic, strong) NSDictionary<NSString *, NSNumber *> *data;
@end
