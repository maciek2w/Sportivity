//
//  MWActivitiesManger.m
//  Sportivity
//
//  Created by Maciej Witaszek on 06/12/15.
//  Copyright © 2015 mawitech. All rights reserved.
//

#import "MWActivitiesManger.h"

@interface MWActivitiesManger ()
@property (nonatomic, strong) NSArray<id<MWActivityProtocol>> *activities;
@property (nonatomic, strong) NSArray<MWActivitySummary *> *activitiesSummary;
@end

@implementation MWActivitiesManger

- (instancetype)initWithActivities:(NSArray<id<MWActivityProtocol>> *)activities
{
    self = [super init];
    if (self) {
        self.activities = activities;
        [self calculateActivitiesSummary];
    }
    
    return self;
}

- (void)calculateActivitiesSummary
{
    NSMutableDictionary<NSString *, NSNumber *> *activitiesSummaryDict = [[NSMutableDictionary alloc] init];
    
    for (id activity in self.activities) {
        NSString *type = activity[@"type"];
        NSTimeInterval typeSpentTime = [activitiesSummaryDict[type] doubleValue];
        NSTimeInterval activitySpentTime = [activity[@"endsAt"] timeIntervalSinceDate:activity[@"startsAt"]];
        typeSpentTime += activitySpentTime;
        
        activitiesSummaryDict[type] = @(typeSpentTime);
    }
    
    NSMutableArray<MWActivitySummary *> *activitiesSummary = [[NSMutableArray alloc] init];
    
    [activitiesSummaryDict enumerateKeysAndObjectsUsingBlock:^(NSString * _Nonnull key, NSNumber * _Nonnull obj, BOOL * _Nonnull stop) {
        MWActivitySummary *activitySummary = [[MWActivitySummary alloc] init];
        activitySummary.donutChartSegmentTitle = key;
        activitySummary.donutChartSegmentColor = [UIColor redColor]; //TODO update
        activitySummary.donutChartSegmentValue = [obj doubleValue];
        [activitiesSummary addObject:activitySummary];
    }];
    
    self.activitiesSummary = [activitiesSummary sortedArrayUsingComparator:^NSComparisonResult(MWActivitySummary *obj1, MWActivitySummary *obj2) {
        if ( obj1.donutChartSegmentValue > obj2.donutChartSegmentValue ) {
            return (NSComparisonResult)NSOrderedAscending;
        } else if ( obj1.donutChartSegmentValue < obj2.donutChartSegmentValue ) {
            return (NSComparisonResult)NSOrderedDescending;
        } else {
            return (NSComparisonResult)NSOrderedSame;
        }
    }];
}

- (NSInteger)count
{
    return [self.activities count];
}

- (id<MWActivityProtocol>)objectAtIndexedSubscript:(NSUInteger)idx
{
    return self.activities[idx];
}

@end
