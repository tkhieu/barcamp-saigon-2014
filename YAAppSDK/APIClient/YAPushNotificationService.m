//
//  ALPushNotificationService.m
//  ApolloLearning
//
//  Created by KONG on 6/3/14.
//  Copyright (c) 2014 Y Academy. All rights reserved.
//

#import "YAPushNotificationService.h"
#import "NSObject+JSON.h"

#import "TCClient.h"
#import "BCTopicClient.h"
@implementation YAPushNotificationService

+ (id)sharedService {
    
    static YAPushNotificationService *service;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        service = [[[self class] alloc] init];
    });
    return service;
}

- (id)init {
    self = [super init];
    
    if (self) {
    }
    return self;
}

#pragma mark Registering

- (void)setupNotification {
    if ([[[UIDevice currentDevice] systemVersion] floatValue] >= 8.0)
    {
        [[UIApplication sharedApplication] registerUserNotificationSettings:[UIUserNotificationSettings settingsForTypes:(UIUserNotificationTypeSound | UIUserNotificationTypeAlert | UIUserNotificationTypeBadge) categories:nil]];
        [[UIApplication sharedApplication] registerForRemoteNotifications];
    }
    else
    {
        [[UIApplication sharedApplication] registerForRemoteNotificationTypes:
         (UIUserNotificationTypeBadge | UIUserNotificationTypeSound | UIUserNotificationTypeAlert)];
    }
}

- (void)removePushNotification {
    
    NSString *deviceToken = [NSDEF objectForKey:kInstallationDeviceToken];
    
    if (deviceToken == nil) {
        return;
    }
    
    [[BCTopicClient defaultClient] registerPushWithDeviceToken:deviceToken block:^(id object, NSError *error) {
        
        if (error == nil && object) {
            DLog(@"finished remove device token for user");
            [NSDEF removeObjectForKey:kInstallationDeviceToken];
            [NSDEF synchronize];
        }
    }];
}


#pragma mark UIApplication Delegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    
    application.applicationIconBadgeNumber = 0;
    if(launchOptions!=nil){
        //        NSString *msg = [NSString stringWithFormat:@"%@", launchOptions];
        //        NSLog(@"%@",msg);
        [self createAlert:launchOptions];
    }
    
    if (![NSDEF objectForKey:kInstallationDeviceToken]) {
        [self setupNotification];
    }
    return YES;
}

- (void)application:(UIApplication*)application didRegisterForRemoteNotificationsWithDeviceToken:(NSData*)deviceTokenData {
    
    NSString *deviceToken = [[deviceTokenData description] stringByTrimmingCharactersInSet:[NSCharacterSet characterSetWithCharactersInString:@"<>"]];
    deviceToken = [deviceToken stringByReplacingOccurrencesOfString:@" " withString:@""];
    
    NSLog(@"deviceToken: %@", deviceToken);
    
    [[BCTopicClient defaultClient] registerPushWithDeviceToken:deviceToken block:^(id object, NSError *error) {
        
        if (error == nil && object) {
            DLog(@"finished registering device token");
            [NSDEF setObject:deviceToken forKey:kInstallationDeviceToken];
            [NSDEF synchronize];
        }
    }];
}

- (void)application:(UIApplication*)application didFailToRegisterForRemoteNotificationsWithError:(NSError*)error {
    NSLog(@"Failed to register with error : %@", error);
}

- (void)application:(UIApplication *)application didReceiveRemoteNotification:(NSDictionary *)userInfo {
    application.applicationIconBadgeNumber = 0;
    //    NSString *msg = [NSString stringWithFormat:@"%@", userInfo];
    //    NSLog(@"%@",msg);
    [self createAlert:userInfo];
}


#pragma mark Handle Notification


- (void)createAlert:(NSDictionary *)userInfo {
    
    NSDictionary *data = [userInfo objectForKey:@"aps"];
    
    NSString *alert = [data objectForKey:@"alert"];
    
    if (alert) {
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"TechCamp" message:[NSString stringWithFormat:@"%@", alert] delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil];
        [alertView show];
    }
    
}


@end
