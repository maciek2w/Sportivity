//
//  ViewController.m
//  Sportivity
//
//  Created by Maciej Witaszek on 28/11/15.
//  Copyright © 2015 mawitech. All rights reserved.
//

#import "MWMainViewController.h"
#import "MWLoginManagerDelegate.h"

@interface MWMainViewController () <MWLoginManagerDelegate>
@property (weak, nonatomic) IBOutlet UIBarButtonItem *logoutButton;

@end

@implementation MWMainViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.logoutButton.enabled = NO;
}

- (void)viewDidAppear:(BOOL)animated
{
    if ([self.backendService isUserLoggedIn]) {
        self.logoutButton.enabled = YES;
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

#pragma mark - MWLoginManagerDelegate

- (void)didLoginUserWithLoginManager:(id<MWLoginManagerProtocol>)loginManager
{
    self.logoutButton.enabled = YES;
}

- (void)loginViewController:(id<MWLoginManagerProtocol>)loginManager didFailToLogInWithError:(NSError *)error
{

}
@end
