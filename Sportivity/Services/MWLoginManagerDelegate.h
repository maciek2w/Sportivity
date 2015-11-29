//
//  MWLoginManagerDelegate.h
//  Sportivity
//
//  Created by Maciej Witaszek on 29/11/15.
//  Copyright © 2015 mawitech. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol MWLoginManagerProtocol;

@protocol MWLoginManagerDelegate <NSObject>
- (void)didLoginUserWithLoginManager:(id<MWLoginManagerProtocol>)loginManager;
- (void)loginViewController:(id<MWLoginManagerProtocol>)loginManager didFailToLogInWithError:(NSError *)error;
@end
