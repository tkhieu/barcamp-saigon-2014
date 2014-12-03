//
//  BCTopicClient.m
//  TechCamp
//
//  Created by Tran Tu Duong on 11/28/14.
//  Copyright (c) 2014 TechCamp. All rights reserved.
//

#import "BCTopicClient.h"
#import <TMCache/TMCache.h>
#import "NSObject+Random.h"
#import "BCTopic.h"
#import "BCQuestion.h"
#import "TCNotification.h"

@implementation BCTopicClient

- (void)voteWithTopicID:(NSString *)topicID QRCode:(NSString *)QRCode block:(YAIdResultBlock)block {
    
    if (!topicID) {
        return;
    }
    
    NSString *urlPath = [NSString stringWithFormat:@"/topics/vote"];
    
    NSDictionary *params = @{@"token": QRCode, @"topic_id": topicID, @"action" : @"add"};
     
    [self postFormWithPath:urlPath params:params block:^(id object, NSError *error) {
        DLogObj(error);
        DLogObj(object);
        
        if (error == nil && object != nil ) {
            
        }
        
        if (block) block(object, error);
    }];
    
}

- (void)answer:(NSString *)questionId QRCode:(NSString *)QRCode answerId:(NSString *)answerId block:(YAIdResultBlock)block {
    
    if (!questionId || !answerId || !QRCode) {
        return;
    }
    
    NSString *urlPath = [NSString stringWithFormat:@"/answer"];
    
    NSDictionary *params = @{@"token": QRCode, @"question_id": questionId, @"answer_id" : answerId};
    
    [self postFormWithPath:urlPath params:params block:^(id object, NSError *error) {
        DLogObj(error);
        DLogObj(object);
        
        if (error == nil && object != nil ) {
            
        }
        
        if (block) block(object, error);
    }];
    
}

- (id)parseFromDictionary:(NSDictionary *)dictionary class:(Class)class
{
    JsonSerializable *obj = nil;
    if ([class isSubclassOfClass:[JsonSerializable class]]) {
        NSError *error = nil;
        obj = [[class alloc] initWithDictionary:dictionary error:&error];
        
        if (error) {
            NSLog(@"Parse json failed: %@", error);
        }
    }
    
    return obj;
}

- (NSArray *)topicsFromJson:(id)json {
    
    NSMutableArray *talks = [NSMutableArray array];
    for (NSDictionary *topicJson in json) {
        BCTopic *topic = [BCTopic objectFromJson:topicJson];
        [talks addObject:topic];
    }
    
    return talks;
}

- (void)getTopicsWithBlock:(YAArrayResultBlock)block {
    
    NSString *token = [NSDEF objectForKey:kInstallationDeviceToken];
    NSString *urlPath = [NSString stringWithFormat:@"/topics?token=%@", token];
    
    [self getJsonWithPath:urlPath params:nil block:^(id object, NSError *error) {
        
        NSArray *topics = nil;
        if (object && !error) {
            [[TMCache sharedCache] setObject:object forKey:urlPath];
            topics = [self topicsFromJson:object];
        }
        
        block(topics, error);
    }];
}

- (void)getNotificationsWithBlock:(YAArrayResultBlock)block {
    NSString *urlPath = [NSString stringWithFormat:@"/announcements"];
    
    [self getJsonWithPath:urlPath params:nil block:^(id object, NSError *error) {
        
        NSArray *notifications = nil;
        if (object && !error) {
            [[TMCache sharedCache] setObject:object forKey:urlPath];
            notifications = [self notificationsFromJson:object];
        }
        
        block(notifications, error);
    }];
}

- (void)loginWithQRCode:(NSString *)QRCode block:(YAArrayResultBlock)block {

    NSString *urlPath = [NSString stringWithFormat:@"/qrcode"];
    NSDictionary *params = @{@"token": QRCode, @"dtype": @"ios"};
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

- (NSArray *)questionsFromJson:(id)json {
    
    NSMutableArray *questions = [NSMutableArray array];
    for (NSDictionary *question in json) {
        BCQuestion *modelQuestion = [self parseFromDictionary:question class:[BCQuestion class]];
        
        [questions addObject:modelQuestion];
    }
    
    return questions;
}

- (void)registerPushWithDeviceToken:(NSString *)deviceToken block:(YAIdResultBlock)block {
    if (!deviceToken) {
        return;
    }
    
    NSString *urlPath = [NSString stringWithFormat:@"/devices"];
    
    NSDictionary *params = @{@"token": deviceToken, @"dtype": @"ios"};
    
    [self postFormWithPath:urlPath params:params block:^(id object, NSError *error) {
        
        if (error == nil && object != nil ) {
            
        }
        
        if (block) block(object, error);
    }];
}

- (id)cachedNotifications {
    NSString *urlPath = [NSString stringWithFormat:@"/announcements"];
    
    id json = [[TMCache sharedCache] objectForKey:urlPath];
    NSArray *notifications = [self notificationsFromJson:json];
    
    return notifications;
}

- (void)getListQuestionWithBlock:(YAArrayResultBlock)block {
    NSString *urlPath = [NSString stringWithFormat:@"/questions"];
    
    [self getJsonWithPath:urlPath params:nil block:^(id object, NSError *error) {
        
        NSArray *questions = nil;
        if (object && !error) {
            [[TMCache sharedCache] setObject:object forKey:urlPath];
            questions = [self questionsFromJson:object];
        }
        
        block(questions, error);
    }];
}

@end
