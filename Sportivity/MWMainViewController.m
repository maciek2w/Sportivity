//
//  ViewController.m
//  Sportivity
//
//  Created by Maciej Witaszek on 28/11/15.
//  Copyright © 2015 mawitech. All rights reserved.
//

#import "MWMainViewController.h"
#import "MWLoginManagerDelegate.h"

@interface MWMainViewController () <MWLoginManagerDelegate, UITableViewDataSource, UITableViewDelegate>
@property (weak, nonatomic) IBOutlet UIBarButtonItem *logoutButton;
@property (weak, nonatomic) IBOutlet UITableView *activitiesTableView;

@property (nonatomic, strong) NSArray<id<MWActivityProtocol>> *activities;
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
            
        }
        else {
            self.activities = activities;
            [self.activitiesTableView reloadData];
        }
    }];
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
