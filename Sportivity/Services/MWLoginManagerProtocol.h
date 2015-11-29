//
//  MWLoginManagerProtocol.h
//  Sportivity
//
//  Created by Maciej Witaszek on 28/11/15.
//  Copyright © 2015 mawitech. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol MWLoginManagerDelegate;

@protocol MWLoginManagerProtocol <NSObject>
- (void)presentLoginViewControllerInViewController:(UIViewController<MWLoginManagerDelegate> *)viewController;
@end
