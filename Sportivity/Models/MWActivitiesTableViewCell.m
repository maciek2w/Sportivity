//
//  MWActivitiesTableViewCell.m
//  Sportivity
//
//  Created by Maciej Witaszek on 07/12/15.
//  Copyright © 2015 mawitech. All rights reserved.
//

#import "MWActivitiesTableViewCell.h"

@implementation MWActivitiesTableViewCell

- (void)layoutSubviews
{
    [super layoutSubviews];
    self.colorIndicator.layer.cornerRadius = self.colorIndicator.frame.size.width / 2;
}
@end
