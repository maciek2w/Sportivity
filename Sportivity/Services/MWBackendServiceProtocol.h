//
//  MWBackendServiceProtocol.h
//  Sportivity
//
//  Created by Maciej Witaszek on 28/11/15.
//  Copyright © 2015 mawitech. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "MWActivityProtocol.h"

@protocol MWBackendServiceProtocol <NSObject>

- (BOOL)isUserLoggedIn;
- (void)userWithBlock:(void (^)(NSString *photoUrl, NSString *username))block;

- (void)logout;
- (void)downloadActivitiesWithBlock:(void (^)(NSArray<id<MWActivityProtocol>> *activities, NSError *error))block;
@end
