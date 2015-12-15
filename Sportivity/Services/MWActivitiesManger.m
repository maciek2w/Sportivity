//
//  MWActivitiesManger.m
//  Sportivity
//
//  Created by Maciej Witaszek on 06/12/15.
//  Copyright © 2015 mawitech. All rights reserved.
//

#import "MWActivitiesManger.h"
#import "MWGradientColor.h"

@interface MWActivitiesManger ()
@property (nonatomic, strong) id<MWBackendServiceProtocol> backendService;
@property (nonatomic, strong) NSArray<id<MWActivityProtocol>> *activities;
@property (nonatomic, strong) NSArray<MWActivitySummary *> *activitiesSummary;
@property (nonatomic, strong) NSDictionary<NSString *, MWActivitySummary *> *activitiesSummaryDict;
@property (nonatomic, strong) MWGradientColor *gradientColor;
@end

@implementation MWActivitiesManger

- (instancetype)initWithBackendService:(id<MWBackendServiceProtocol>)backendService
{
    self = [super init];
    if (self) {
        self.backendService = backendService;
        self.gradientColor = [[MWGradientColor alloc] initWithStartColor:[UIColor colorWithRed:217.0/255.0 green:15.0/255.0 blue:43.0/255.0 alpha:1] //D90F2B
                                                                endColor:[UIColor colorWithRed:83.0/255.0 green:200.0/255.0 blue:14.0/255.0 alpha:1]]; //53C80E
    }
    
    return self;
}

- (void)downloadActivities
{
    [self.backendService downloadActivitiesWithBlock:^(NSArray<id<MWActivityProtocol>> *activities, NSError *error) {
        self.activities = activities;
        [self calculateActivitiesSummary];
        
        [[NSNotificationCenter defaultCenter] postNotificationName:@"activitiesManagerData" object:nil];
    }];
}

- (void)calculateActivitiesSummary
{
    NSMutableDictionary<NSString *, NSNumber *> *summaryDict = [[NSMutableDictionary alloc] init];
    
    for (id activity in self.activities) {
        NSString *type = activity[@"type"];
        
        if (type == nil) {
            type = @"";
        }
        
        NSTimeInterval typeSpentTime = [summaryDict[type] doubleValue];
        NSTimeInterval activitySpentTime = [activity[@"endsAt"] timeIntervalSinceDate:activity[@"startsAt"]];
        typeSpentTime += activitySpentTime;
        
        summaryDict[type] = @(typeSpentTime);
    }
    
    NSMutableArray<MWActivitySummary *> *activitiesSummary = [[NSMutableArray alloc] init];
    NSMutableDictionary<NSString *, MWActivitySummary *> *activitiesSummarMutableyDict = [[NSMutableDictionary alloc] init];
    
    [summaryDict enumerateKeysAndObjectsUsingBlock:^(NSString * _Nonnull key, NSNumber * _Nonnull obj, BOOL * _Nonnull stop) {
        MWActivitySummary *activitySummary = [[MWActivitySummary alloc] init];
        activitySummary.donutChartSegmentTitle = key;
        activitySummary.donutChartSegmentValue = [obj doubleValue];
        
        [activitiesSummary addObject:activitySummary];
        activitiesSummarMutableyDict[key] = activitySummary;
    }];
    
    self.activitiesSummaryDict = [activitiesSummarMutableyDict copy];
    
    self.activitiesSummary = [activitiesSummary sortedArrayUsingComparator:^NSComparisonResult(MWActivitySummary *obj1, MWActivitySummary *obj2) {
        if ( obj1.donutChartSegmentValue > obj2.donutChartSegmentValue ) {
            return (NSComparisonResult)NSOrderedAscending;
        } else if ( obj1.donutChartSegmentValue < obj2.donutChartSegmentValue ) {
            return (NSComparisonResult)NSOrderedDescending;
        } else {
            return (NSComparisonResult)NSOrderedSame;
        }
    }];
    
    [self assignColorToActivities];
}

- (void)assignColorToActivities
{
    NSInteger activitiesCount = [self.activitiesSummary count];
    
    [self.activitiesSummary enumerateObjectsUsingBlock:^(MWActivitySummary * _Nonnull activitySummary, NSUInteger idx, BOOL * _Nonnull stop) {
        CGFloat colorOffset = activitiesCount > 1 ? (CGFloat)idx++ / (activitiesCount - 1) : 0;
        
        activitySummary.donutChartSegmentColor = [self.gradientColor getColorWithOffset:colorOffset];
    }];
}

- (MWActivitySummary *)activitySummaryForType:(NSString *)type
{
    return self.activitiesSummaryDict[type];
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
