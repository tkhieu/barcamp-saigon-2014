//
//  TCAppDelegate.m
//  TechCamp
//
//  Created by KONG on 13/3/14.
//  Copyright (c) 2014 TechCamp. All rights reserved.
//

#import "AppDelegate.h"
#import <FormatterKit/TTTColorFormatter.h>



//#import "YAFakeAPIServer.h"

#import "YAPushNotificationService.h"


@implementation AppDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    // Override point for customization after application launch.
    
//    [YAFakeAPIServer registerFakeServerWithHost:SERVER_API_HOST];

    [self setupAppearance];
    
    [[YAPushNotificationService sharedService] application:application didFinishLaunchingWithOptions:launchOptions];
    
    // iOS 8 PN
    
    if ([[UIDevice currentDevice].systemVersion integerValue] >= 8) {
        //Right, that is the point
        UIUserNotificationSettings *settings = [UIUserNotificationSettings settingsForTypes:(UIRemoteNotificationTypeBadge
                                                                                             |UIRemoteNotificationTypeSound
                                                                                             |UIRemoteNotificationTypeAlert) categories:nil];
        [[UIApplication sharedApplication] registerUserNotificationSettings:settings];
    }
    
    else {
        //register to receive notifications
        UIRemoteNotificationType myTypes = UIRemoteNotificationTypeBadge | UIRemoteNotificationTypeAlert | UIRemoteNotificationTypeSound;
        [[UIApplication sharedApplication] registerForRemoteNotificationTypes:myTypes];
    }
    
    return YES;
}

#ifdef __IPHONE_8_0
- (void)application:(UIApplication *)application didRegisterUserNotificationSettings:(UIUserNotificationSettings *)notificationSettings
{
    //register to receive notifications
    [application registerForRemoteNotifications];
}

- (void)application:(UIApplication *)application handleActionWithIdentifier:(NSString *)identifier forRemoteNotification:(NSDictionary *)userInfo completionHandler:(void(^)())completionHandler
{
    //handle the actions
    if ([identifier isEqualToString:@"declineAction"]){
    }
    else if ([identifier isEqualToString:@"answerAction"]){
    }
}
#endif
							
- (void)applicationWillResignActive:(UIApplication *)application
{
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application
{
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later. 
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

- (void)applicationWillEnterForeground:(UIApplication *)application
{
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application
{
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}

- (void)applicationWillTerminate:(UIApplication *)application
{
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}


- (void)setupAppearance {
    
//    UIColor *techcampTintColor = [[[TTTColorFormatter alloc] init] colorFromHexadecimalString:@"db4f4f"];
    
    
    if (IS_OS_7_OR_LATER) {
        [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleLightContent];
        
        UIColor *barTintColor = [[[TTTColorFormatter alloc] init] colorFromHexadecimalString:@"FF1300"];
        //FF1300
        UIColor *tintColor = [UIColor whiteColor];
        
        [[UINavigationBar appearance] setBarTintColor:barTintColor];
        [[UINavigationBar appearance] setTintColor:tintColor];
        
        [[UIToolbar appearance] setBarTintColor:barTintColor];
        [[UIToolbar appearance] setTintColor:tintColor];
        
        [[UINavigationBar appearance] setTitleTextAttributes:@{UITextAttributeTextColor: tintColor}];
        
        self.window.tintColor = barTintColor;
    }
    
    
}


#pragma mark Push Notification

- (void)application:(UIApplication*)application didRegisterForRemoteNotificationsWithDeviceToken:(NSData*)deviceTokenData {
    
    [[YAPushNotificationService sharedService] application:application didRegisterForRemoteNotificationsWithDeviceToken:deviceTokenData];
        NSLog(@"Did Register for Remote Notifications with Device Token (%@)", deviceTokenData);
}

- (void)application:(UIApplication*)application didFailToRegisterForRemoteNotificationsWithError:(NSError*)error{
	[[YAPushNotificationService sharedService] application:application didFailToRegisterForRemoteNotificationsWithError:error];
    NSLog(@"Did Fail to Register for Remote Notifications");
    NSLog(@"%@, %@", error, error.localizedDescription);
}

- (void)application:(UIApplication *)application didReceiveRemoteNotification:(NSDictionary *)userInfo {
    
    [[YAPushNotificationService sharedService] application:application didReceiveRemoteNotification:userInfo];
}


@end
