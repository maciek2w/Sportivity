//
//  MWSecondScreenViewController.m
//  Sportivity
//
//  Created by Maciej Witaszek on 13/12/15.
//  Copyright © 2015 mawitech. All rights reserved.
//

#import "MWSecondScreenViewController.h"
#import "MWDonutChartView.h"

@interface MWSecondScreenViewController ()
@property (weak, nonatomic) IBOutlet MWDonutChartView *donutChartView;

@end

@implementation MWSecondScreenViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(didReceiveNotification:) name:@"activitiesManagerData" object:nil];
    
    if (self.activitiesManager.activitiesSummary) {
        self.donutChartView.data = self.activitiesManager.activitiesSummary;
    }
}

- (void)viewDidDisappear:(BOOL)animated
{
    [super viewDidDisappear:animated];
    
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (void)didReceiveNotification:(NSNotification *)notification
{
    self.donutChartView.data = self.activitiesManager.activitiesSummary;
}

@end
