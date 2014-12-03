//
//  TCNotification.h
//  TechCamp
//
//  Created by KONG on 13/3/14.
//  Copyright (c) 2014 TechCamp. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "JsonSerializable.h"

@interface TCNotification : JsonSerializable

@property (nonatomic, strong) NSString *notificationId, *content, *link, *createdAtString, *updatedAtString;

@property (nonatomic, strong) NSDate *createdAt;
@property (nonatomic, strong) NSDate *updatedAt;

+ (id)objectFromJson:(id)jsonObject;

@end
