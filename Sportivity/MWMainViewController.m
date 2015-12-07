//
//  ViewController.m
//  Sportivity
//
//  Created by Maciej Witaszek on 28/11/15.
//  Copyright © 2015 mawitech. All rights reserved.
//

#import "MWMainViewController.h"
#import "MWLoginManagerDelegate.h"
#import "MWActivitiesManger.h"
#import "MWActivitySummary.h"
#import "MWDonutChartView.h"
#import "MWActivitiesTableViewCell.h"

@interface MWMainViewController () <MWLoginManagerDelegate, UITableViewDataSource, UITableViewDelegate>
@property (weak, nonatomic) IBOutlet UIBarButtonItem *logoutButton;
@property (weak, nonatomic) IBOutlet UITableView *activitiesTableView;
@property (weak, nonatomic) IBOutlet MWDonutChartView *donutChartView;
@property (weak, nonatomic) IBOutlet UIImageView *userPhotoImageView;
@property (weak, nonatomic) IBOutlet UIProgressView *progressView;
@property (nonatomic, strong) IBOutlet NSLayoutConstraint *userPhotoImageViewConstraintOutsideView;


@property (nonatomic, strong) MWActivitiesManger *activitiesManager;
@property (nonatomic, strong) NSDateFormatter *activityDateFormatter;

@property (nonatomic, assign) BOOL isFirstTimePresented;

@end

@implementation MWMainViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.logoutButton.enabled = NO;
    
    self.activityDateFormatter = [[NSDateFormatter alloc] init];
    self.activityDateFormatter.timeStyle = NSDateFormatterShortStyle;
    self.activityDateFormatter.dateStyle = NSDateFormatterShortStyle;
    
    [self hideDataViewsWithAnimation:NO];
}

- (void)viewDidAppear:(BOOL)animated
{
    if (self.isFirstTimePresented == NO) {
        self.isFirstTimePresented = YES;
        if ([self.backendService isUserLoggedIn]) {
            [self userLoggedIn];
        }
        else {
            [self.loginManager presentLoginViewControllerInViewController:self];
        }
    }
}

- (IBAction)didTapLogout:(id)sender
{
    [self.backendService logout];
    self.logoutButton.enabled = NO;
    self.userPhotoImageView.image = nil;
    self.title = nil;
    [self.loginManager presentLoginViewControllerInViewController:self];
    [self hideUserPhotoWithAnimation:NO];
    [self hideDataViewsWithAnimation:NO];
}

- (void)downloadActivities
{
    [self.backendService downloadActivitiesWithBlock:^(NSArray<id<MWActivityProtocol>> *activities, NSError *error) {
        if (error) {
            //TODO add error message
        }
        else {
            [self.progressView setProgress:0.66 animated:NO];
            self.activitiesManager = [[MWActivitiesManger alloc] initWithActivities:activities];
            self.donutChartView.data = self.activitiesManager.activitiesSummary;
            [self.activitiesTableView reloadData];
            
            [self showDataViewsWithAnimation:YES];
        }
    }];
}

- (void)updateUserInfo
{
    [self.backendService userWithBlock:^(NSString *photoUrl, NSString *username) {
        dispatch_async(dispatch_get_main_queue(), ^{
            self.title = username;
        });
        
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_BACKGROUND, 0), ^{
            UIImage *image = [UIImage imageWithData:[NSData dataWithContentsOfURL:[NSURL URLWithString:photoUrl]]];
            
            dispatch_async(dispatch_get_main_queue(), ^{
                if (image) {
                    [self.view layoutIfNeeded];
                    [UIView animateWithDuration:1.0
                                          delay:0.0
                                        options:UIViewAnimationOptionCurveEaseInOut
                                     animations:^{
                                         [self.view removeConstraint:self.userPhotoImageViewConstraintOutsideView];
                                         [self.view layoutIfNeeded];
                                     } completion:NULL];
                }
                else {
                    [self hideUserPhotoWithAnimation:YES];
                }
                self.userPhotoImageView.image = image;
            });
        });
    }];
}

- (void)hideUserPhotoWithAnimation:(BOOL)animated
{
    [self.view layoutIfNeeded];
    [UIView animateWithDuration:animated ? 1.0 : 0.0
                          delay:0.0
                        options:UIViewAnimationOptionCurveEaseIn
                     animations:^{
                         [self.view addConstraint:self.userPhotoImageViewConstraintOutsideView];
                         [self.view layoutIfNeeded];
                     } completion:^(BOOL finished) {
                         self.userPhotoImageView.image = nil;
                     }];
}

- (void)hideDataViewsWithAnimation:(BOOL)animated
{
    [UIView animateWithDuration:animated ? 1.0 : 0.0
                     animations:^{
                         self.donutChartView.alpha = 0.0;
                         self.activitiesTableView.alpha = 0.0;
                     }];
}

- (void)showDataViewsWithAnimation:(BOOL)animated
{
    [UIView animateWithDuration:animated ? 1.0 : 0.0
                     animations:^{
                         self.progressView.alpha = 0.0;
                         self.donutChartView.alpha = 1.0;
                         self.activitiesTableView.alpha = 1.0;
                     }];
}

- (void)userLoggedIn
{
    [self.progressView setProgress:0];
    self.progressView.alpha = 1.0;
    [self.progressView setProgress:0.33 animated:NO];
    self.logoutButton.enabled = YES;
    [self updateUserInfo];
    [self downloadActivities];
}

#pragma mark - MWLoginManagerDelegate

- (void)didLoginUserWithLoginManager:(id<MWLoginManagerProtocol>)loginManager
{
    [self userLoggedIn];
}

- (void)loginViewController:(id<MWLoginManagerProtocol>)loginManager didFailToLogInWithError:(NSError *)error
{

}

#pragma mark - UITableViewDataSource, UITableViewDelegate

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [self.activitiesManager count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cellID"];
    
    return cell;
}

- (void)tableView:(UITableView *)tableView willDisplayCell:(MWActivitiesTableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath
{
    id<MWActivityProtocol> activity = self.activitiesManager[indexPath.row];
    
    NSString *type = activity[@"type"];
    
    MWActivitySummary *activitySummary = [self.activitiesManager activitySummaryForType:type];
    
    cell.colorIndicator.backgroundColor = activitySummary.donutChartSegmentColor;
    cell.typeLabel.text = type;
    cell.datesLabel.text = [NSString stringWithFormat:@"%@ - %@",
                            [self.activityDateFormatter stringFromDate:activity[@"startsAt"]],
                            [self.activityDateFormatter stringFromDate:activity[@"endsAt"]]];
}

@end
