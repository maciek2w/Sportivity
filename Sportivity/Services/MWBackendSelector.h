//
//  MWBackendSelector.h
//  Sportivity
//
//  Created by Maciej Witaszek on 28/11/15.
//  Copyright © 2015 mawitech. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "MWParseBackendService.h"
#import "MWParseLoginManager.h"

@interface MWBackendSelector : NSObject
@property (nonatomic, readonly) id<MWBackendServiceProtocol> backendService;
@property (nonatomic, readonly) id<MWLoginManagerProtocol> loginManager;

- (instancetype) initWithBackendName:(NSString *)backendName;
@end
