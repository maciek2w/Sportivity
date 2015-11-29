//
//  MWParseBackendService.m
//  Sportivity
//
//  Created by Maciej Witaszek on 28/11/15.
//  Copyright © 2015 mawitech. All rights reserved.
//

#import "MWParseBackendService.h"
#import <Parse/Parse.h>

@implementation MWParseBackendService

- (instancetype) init
{
    self = [super init];
    if (self) {
        [Parse setApplicationId:@"5u2Bow78GMPsz7QKsTJlQ30LzMwfwwR5HnhtffJu"
                      clientKey:@"MVIkDRa5DuZDThgJiOt2LXM5iBrMCA5IRdISmNis"];
    }
    
    return self;
}

- (BOOL)isUserLoggedIn
{
    return [PFUser currentUser] != nil;
}

- (void)logout
{
    [PFUser logOut];
}

@end
