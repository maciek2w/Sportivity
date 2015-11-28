//
//  MWBackendSelector.m
//  Sportivity
//
//  Created by Maciej Witaszek on 28/11/15.
//  Copyright © 2015 mawitech. All rights reserved.
//

#import "MWBackendSelector.h"

@interface MWBackendSelector ()
@property (nonatomic, strong) id<MWBackendServiceProtocol> backendService;
@property (nonatomic, strong) id<MWLoginManagerProtocol> loginManager;
@end

@implementation MWBackendSelector

- (instancetype)initWithBackendName:(NSString *)backendName
{
    self = [super init];
    if (self) {
        if ([backendName isEqualToString:@"Parse"]) {
            self.backendService = [[MWParseBackendService alloc] init];
            self.loginManager = [[MWParseLoginManager alloc] init];
        }
        else {
            return nil;
        }
    }
    
    return self;
}
@end
