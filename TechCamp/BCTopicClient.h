//
//  BCTopicClient.h
//  TechCamp
//
//  Created by Tran Tu Duong on 11/28/14.
//  Copyright (c) 2014 TechCamp. All rights reserved.
//

#import "YAClient.h"

@interface BCTopicClient : YAClient

- (void)voteWithTopicID:(NSString *)topicID QRCode:(NSString *)QRCode block:(YAIdResultBlock)block;
- (void)loginWithQRCode:(NSString *)QRCode block:(YAArrayResultBlock)block;
- (void)getTopicsWithBlock:(YAArrayResultBlock)block;
- (void)getNotificationsWithBlock:(YAArrayResultBlock)block;
- (NSArray *)notificationsFromJson:(id)json;
- (void)registerPushWithDeviceToken:(NSString *)deviceToken block:(YAIdResultBlock)block;

@end
