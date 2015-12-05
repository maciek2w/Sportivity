//
//  MWRoundImageView.m
//  Sportivity
//
//  Created by Maciej Witaszek on 05/12/15.
//  Copyright © 2015 mawitech. All rights reserved.
//

#import "MWRoundImageView.h"

@implementation MWRoundImageView

- (instancetype)initWithImage:(UIImage *)image
{
    self = [super initWithImage:image];
    if (self) {
        [self setupView];
    }
    return self;
}

- (void)awakeFromNib
{
    [super awakeFromNib];
    
    [self setupView];
}

- (void)setupView
{
    self.clipsToBounds = YES;
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    
    self.layer.cornerRadius = self.frame.size.width / 2;
}

@end
