//
//  ViewController.h
//  Sportivity
//
//  Created by Maciej Witaszek on 28/11/15.
//  Copyright © 2015 mawitech. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MWBackendServiceProtocol.h"
#import "MWLoginManagerProtocol.h"

@interface MWMainViewController : UIViewController
@property (nonatomic, strong) id<MWBackendServiceProtocol> backendService;
@property (nonatomic, strong) id<MWLoginManagerProtocol> loginManager;
@end

