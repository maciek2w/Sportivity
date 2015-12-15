//
//  MWSecondScreenViewController.h
//  Sportivity
//
//  Created by Maciej Witaszek on 13/12/15.
//  Copyright © 2015 mawitech. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MWBackendServiceProtocol.h"
#import "MWActivitiesManger.h"

@interface MWSecondScreenViewController : UIViewController
@property (nonatomic, strong) MWActivitiesManger *activitiesManager;
@end
