//
//  ViewController.m
//  Sportivity
//
//  Created by Maciej Witaszek on 28/11/15.
//  Copyright © 2015 mawitech. All rights reserved.
//

#import "MWMainViewController.h"
#import "MWLoginManagerDelegate.h"
#import "MWActivitySummary.h"
#import "MWDonutChartView.h"

@interface MWMainViewController () <MWLoginManagerDelegate, UITableViewDataSource, UITableViewDelegate>
@property (weak, nonatomic) IBOutlet UIBarButtonItem *logoutButton;
@property (weak, nonatomic) IBOutlet UITableView *activitiesTableView;
@property (weak, nonatomic) IBOutlet MWDonutChartView *donutChartView;

@property (nonatomic, strong) NSArray<id<MWActivityProtocol>> *activities;
//@property (nonatomic, strong) NSArray<MWActivitySummary *> *activitiesSummary;
@property (nonatomic, strong) NSDictionary<NSString *, NSNumber *> *activitiesSummary;
@property (nonatomic, assign) NSTimeInterval totalActivitiesSpentTime;
@property (nonatomic, strong) NSDateFormatter *activityDateFormatter;

@end

@implementation MWMainViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.logoutButton.enabled = NO;
    
    self.activityDateFormatter = [[NSDateFormatter alloc] init];
    self.activityDateFormatter.timeStyle = NSDateFormatterShortStyle;
    self.activityDateFormatter.dateStyle = NSDateFormatterShortStyle;
}

- (void)viewDidAppear:(BOOL)animated
{
    if ([self.backendService isUserLoggedIn]) {
        self.logoutButton.enabled = YES;
        [self downloadActivities];
    }
    else {
        [self.loginManager presentLoginViewControllerInViewController:self];
    }
}

- (IBAction)didTapLogout:(id)sender
{
    [self.backendService logout];
    self.logoutButton.enabled = NO;
    [self.loginManager presentLoginViewControllerInViewController:self];
}

- (void)downloadActivities
{
    //TODO add linear progress indicator
    
    [self.backendService downloadActivitiesWithBlock:^(NSArray<id<MWActivityProtocol>> *activities, NSError *error) {
        if (error) {
            //TODO add error message
        }
        else {
            self.activities = activities;
            [self calculateActivitiesSummary];
            [self.activitiesTableView reloadData];
        }
    }];
}

- (void)calculateActivitiesSummary
{
    NSMutableDictionary<NSString *, NSNumber *> *activitiesSummary = [[NSMutableDictionary alloc] init];
    NSTimeInterval totalActivitiesSpentTime = 0;
    
    for (id activity in self.activities) {
        NSString *type = activity[@"type"];
        NSTimeInterval typeSpentTime = [activitiesSummary[type] doubleValue];
        NSTimeInterval activitySpentTime = [activity[@"endsAt"] timeIntervalSinceDate:activity[@"startsAt"]];
        typeSpentTime += activitySpentTime;
        totalActivitiesSpentTime += activitySpentTime;
        
        activitiesSummary[type] = @(typeSpentTime);
    }
    
    self.activitiesSummary = activitiesSummary;
    self.totalActivitiesSpentTime = totalActivitiesSpentTime;
    
    self.donutChartView.data = self.activitiesSummary;
}

#pragma mark - MWLoginManagerDelegate

- (void)didLoginUserWithLoginManager:(id<MWLoginManagerProtocol>)loginManager
{
    self.logoutButton.enabled = YES;
    
    [self downloadActivities];
}

- (void)loginViewController:(id<MWLoginManagerProtocol>)loginManager didFailToLogInWithError:(NSError *)error
{

}

#pragma mark - UITableViewDataSource, UITableViewDelegate

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [self.activities count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cellID"];
    
    return cell;
}

- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath
{
    id<MWActivityProtocol> activity = self.activities[indexPath.row];
    
    cell.textLabel.text = activity[@"type"];
    cell.detailTextLabel.text = [NSString stringWithFormat:@"%@ - %@",
                                 [self.activityDateFormatter stringFromDate:activity[@"startsAt"]],
                                 [self.activityDateFormatter stringFromDate:activity[@"endsAt"]]];
}
@end
