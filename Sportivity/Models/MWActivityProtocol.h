//
//  MWActivityProtocol.h
//  Sportivity
//
//  Created by Maciej Witaszek on 30/11/15.
//  Copyright © 2015 mawitech. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol MWActivityProtocol <NSObject>

- (id)objectForKeyedSubscript:(NSString *)key;
- (void)setObject:(id)object forKeyedSubscript:(NSString *)key;

@end
