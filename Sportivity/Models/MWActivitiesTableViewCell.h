//
//  MWActivitiesTableViewCell.h
//  Sportivity
//
//  Created by Maciej Witaszek on 07/12/15.
//  Copyright © 2015 mawitech. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MWActivitiesTableViewCell : UITableViewCell
@property (nonatomic, strong) IBOutlet UIView *colorIndicator;
@property (nonatomic, strong) IBOutlet UILabel *typeLabel;
@property (nonatomic, strong) IBOutlet UILabel *datesLabel;
@end
