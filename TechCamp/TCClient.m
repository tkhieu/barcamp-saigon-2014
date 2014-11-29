//
//  TCClient.m
//  TechCamp
//
//  Created by KONG on 13/3/14.
//  Copyright (c) 2014 TechCamp. All rights reserved.
//

#import "TCClient.h"
#import <TMCache/TMCache.h>
#import "TCNotification.h"

#import "NSObject+Random.h"

@implementation TCClient

-(NSString*)uniqueIDForDevice
{
    NSString* uniqueIdentifier = nil;
    if( [UIDevice instancesRespondToSelector:@selector(identifierForVendor)] ) { // >=iOS 7
        uniqueIdentifier = [[[UIDevice currentDevice] identifierForVendor] UUIDString];
    } else { //<=iOS6, Use UDID of Device
        CFUUIDRef uuid = CFUUIDCreate(NULL);
        //uniqueIdentifier = ( NSString*)CFUUIDCreateString(NULL, uuid);- for non- ARC
        uniqueIdentifier = (NSString *)CFBridgingRelease(CFUUIDCreateString(NULL, uuid));// for ARC
        CFRelease(uuid);
    }
    return uniqueIdentifier;
}

- (NSString *)deviceId {
    return [self uniqueIDForDevice];
}

- (void)voteWithTopicID:(NSString *)topicID block:(YAIdResultBlock)block {
    
    if (!topicID) {
        return;
    }
    
    NSString *urlPath = [NSString stringWithFormat:@"/voting/topic/vote"];
    
    NSDictionary *params = @{@"id": [self deviceId], @"topic_id": topicID};
    
    [self postJsonWithPath:urlPath params:params block:^(id object, NSError *error) {
        DLogObj(error);
        DLogObj(object);
        
        if (error == nil && object != nil ) {
            
        }
        
        if (block) block(object, error);
    }];

}

- (void)favoriteWithTopicID:(NSString *)topicID block:(YAIdResultBlock)block {
    if (!topicID) {
        return;
    }
    
    NSString *urlPath = [NSString stringWithFormat:@"/voting/topic/fav"];
    
    NSDictionary *params = @{@"id": [self deviceId], @"topic_id": topicID};
    
    [self postJsonWithPath:urlPath params:params block:^(id object, NSError *error) {
        DLogObj(error);
        DLogObj(object);
        
        if (error == nil && object != nil ) {
            
        }
        
        if (block) block(object, error);
    }];

}


- (void)registerPushWithDeviceToken:(NSString *)deviceToken block:(YAIdResultBlock)block {
    if (!deviceToken) {
        return;
    }
    
    NSString *urlPath = [NSString stringWithFormat:@"/voting/notification/register"];
    
    NSDictionary *params = @{@"device_token": deviceToken, @"platform": @"iOS"};
    
    [self postJsonWithPath:urlPath params:params block:^(id object, NSError *error) {
        
        if (error == nil && object != nil ) {
            
        }
        
        if (block) block(object, error);
    }];
}



- (NSArray *)notificationsFromJson:(id)json {
    
    NSMutableArray *notifications = [NSMutableArray array];
    for (NSDictionary *notificationJson in json) {
        TCNotification *notification = [TCNotification objectFromJson:notificationJson];
        
        [notifications addObject:notification];
    }
    
    
    [notifications sortUsingComparator:^NSComparisonResult(TCNotification *obj1, TCNotification *obj2) {
        return [obj2.createdAt compare:obj1.createdAt];
    }];
    
    return notifications;
}

- (id)cachedNotifications {
    NSString *urlPath = [NSString stringWithFormat:@"/voting/notification/list"];
    
    id json = [[TMCache sharedCache] objectForKey:urlPath];
    NSArray *notifications = [self notificationsFromJson:json];
    
    return notifications;
}

- (void)getNotificationsWithBlock:(YAArrayResultBlock)block {
    NSString *urlPath = [NSString stringWithFormat:@"/voting/notification/list"];
    
    [self getJsonWithPath:urlPath params:nil block:^(id object, NSError *error) {
        
        NSArray *notifications = nil;
        if (object && !error) {
            [[TMCache sharedCache] setObject:object forKey:urlPath];
            notifications = [self notificationsFromJson:object];
        }
        
        block(notifications, error);
    }];
}

@end
