//
//  MWActivityProtocol.h
//  Sportivity
//
//  Created by Maciej Witaszek on 30/11/15.
//  Copyright © 2015 mawitech. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol MWActivityProtocol <NSObject>
@property (nonatomic, strong) NSString *type;
@property (nonatomic, strong) NSDate *startAt;
@property (nonatomic, strong) NSString *endsAt;

@end
