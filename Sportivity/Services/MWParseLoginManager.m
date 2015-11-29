//
//  MWParseLoginManager.m
//  Sportivity
//
//  Created by Maciej Witaszek on 28/11/15.
//  Copyright © 2015 mawitech. All rights reserved.
//

#import "MWParseLoginManager.h"
#import "MWLoginManagerDelegate.h"
#import <ParseUI/PFLogInViewController.h>

@interface MWParseLoginManager () <PFLogInViewControllerDelegate>
@property(nonatomic, strong) id<MWLoginManagerDelegate> delegate;
@end

@implementation MWParseLoginManager

- (void)presentLoginViewControllerInViewController:(UIViewController<MWLoginManagerDelegate> *)viewController
{
    PFLogInViewController *logInController = [[PFLogInViewController alloc] init];
    logInController.fields = (PFLogInFieldsUsernameAndPassword | PFLogInFieldsLogInButton);
    UILabel *logoLabel = [[UILabel alloc] init];
    logoLabel.text = @"Sportivity";
    logInController.logInView.logo = logoLabel;
    logInController.delegate = self;
    self.delegate = viewController;
    [viewController presentViewController:logInController animated:YES completion:nil];
}

#pragma mark - PFLogInViewControllerDelegate

- (void)logInViewController:(PFLogInViewController *)controller
               didLogInUser:(PFUser *)user
{
    if ([self.delegate respondsToSelector:@selector(didLoginUserWithLoginManager:)]) {
        [self.delegate didLoginUserWithLoginManager:self];
    }
    
    [controller dismissViewControllerAnimated:YES completion:nil];
    
}

- (void)logInViewController:(PFLogInViewController *)logInController didFailToLogInWithError:(NSError *)error
{
    UIAlertAction *alertAction = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault handler:NULL];
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"Error"
                                                                   message:[error localizedDescription]
                                                            preferredStyle:UIAlertControllerStyleAlert];
    [alert addAction:alertAction];
    [logInController presentViewController:alert animated:YES completion:NULL];
    
    if ([self.delegate respondsToSelector:@selector(loginViewController:didFailToLogInWithError:)]) {
        [self.delegate loginViewController:self didFailToLogInWithError:error];
    }
}

@end
