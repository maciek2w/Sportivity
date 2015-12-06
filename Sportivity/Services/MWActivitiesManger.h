//
//  MWActivitiesManger.h
//  Sportivity
//
//  Created by Maciej Witaszek on 06/12/15.
//  Copyright © 2015 mawitech. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MWActivityProtocol.h"
#import "MWActivitySummary.h"

@interface MWActivitiesManger : NSObject

@property (nonatomic, readonly) NSArray<MWActivitySummary *> *activitiesSummary;;

- (instancetype)initWithActivities:(NSArray<id<MWActivityProtocol>> *)activities;

- (NSInteger) count;
- (id<MWActivityProtocol>) objectAtIndexedSubscript:(NSUInteger)idx;

@end
