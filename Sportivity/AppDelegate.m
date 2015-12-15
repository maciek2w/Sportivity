//
//  AppDelegate.m
//  Sportivity
//
//  Created by Maciej Witaszek on 28/11/15.
//  Copyright © 2015 mawitech. All rights reserved.
//

#import "AppDelegate.h"
#import "MWBackendSelector.h"
#import "MWMainViewController.h"
#import "MWSecondScreenViewController.h"
#import "MWActivitiesManger.h"

@interface AppDelegate ()
@property (nonatomic, strong) id<MWBackendServiceProtocol> backendService;
@property (nonatomic, strong) id<MWLoginManagerProtocol> loginManager;
@property (nonatomic, strong) MWActivitiesManger *activitiesManager;

@property (nonatomic, strong) MWSecondScreenViewController *secondScreenVC;

@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    MWBackendSelector *backendSelector = [[MWBackendSelector alloc] initWithBackendName:@"Parse"];
    self.backendService = backendSelector.backendService;
    self.loginManager = backendSelector.loginManager;
    
    self.activitiesManager = [[MWActivitiesManger alloc] initWithBackendService:self.backendService];
    
    UINavigationController *navVC = (UINavigationController *) self.window.rootViewController;
    MWMainViewController *mainVC = (MWMainViewController *)navVC.viewControllers.firstObject;
    mainVC.backendService = self.backendService;
    mainVC.loginManager = self.loginManager;
    mainVC.activitiesManager = self.activitiesManager;
    
    [self setupScreenConnectionNotificationHandlers];
    [self setupSecondScreen];
    
    return YES;
}

- (void)applicationWillResignActive:(UIApplication *)application {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application {
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

- (void)applicationWillEnterForeground:(UIApplication *)application {
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application {
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}

- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}

- (void)setupScreenConnectionNotificationHandlers
{
    NSNotificationCenter *center = [NSNotificationCenter defaultCenter];
    
    [center addObserver:self selector:@selector(handleScreenDidConnectNotification:)
                   name:UIScreenDidConnectNotification object:nil];
    
    [center addObserver:self selector:@selector(handleScreenDidDisconnectNotification:)
                   name:UIScreenDidDisconnectNotification object:nil];
}

- (void)setupSecondScreen
{
    if ([[UIScreen screens] count] > 1)
    {
        UIScreen *secondScreen = [[UIScreen screens] objectAtIndex:1];
        [self createSecondWindowWithScreen:secondScreen];
    }
}

- (void)handleScreenDidConnectNotification:(NSNotification*)notification
{
    UIScreen *newScreen = [notification object];
    
    if (self.secondWindow == nil)
    {
        [self createSecondWindowWithScreen:newScreen];
    }
}

- (void)handleScreenDidDisconnectNotification:(NSNotification*)aNotification
{
    if (self.secondWindow)
    {
        // Hide and then delete the window.
        self.secondWindow.hidden = YES;
        self.secondWindow = nil;
    }
}

- (void)createSecondWindowWithScreen:(UIScreen *)screen
{
    self.secondWindow = [[UIWindow alloc] initWithFrame:screen.bounds];
    self.secondWindow.screen = screen;
    UIStoryboard *storyboard = self.window.rootViewController.storyboard;
    
    self.secondScreenVC = [storyboard instantiateViewControllerWithIdentifier:@"secondScreenVC"];
    self.secondScreenVC.activitiesManager = self.activitiesManager;
    
    self.secondWindow.rootViewController = self.secondScreenVC;
    self.secondWindow.hidden = NO;
}
@end
