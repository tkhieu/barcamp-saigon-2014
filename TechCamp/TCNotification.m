//
//  TCNotification.m
//  TechCamp
//
//  Created by KONG on 13/3/14.
//  Copyright (c) 2014 TechCamp. All rights reserved.
//

#import "TCNotification.h"
#import "NSObject+JsonMapping.h"
//#import <FormatterKit/TTT

static NSDateFormatter *dateFormater = nil;

@implementation TCNotification

+ (id)parseFromDictionary:(NSDictionary *)dictionary class:(Class)class
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

+ (NSMutableDictionary *)customMapping
{
    return [@{@"created_at": @"createdAtString", @"updated_at" : @"updatedAtString", @"id": @"notificationId"} mutableCopy];
}

+ (NSDateFormatter *)dateFormatter {
    if (!dateFormater) {
        dateFormater = [[NSDateFormatter alloc] init];
        dateFormater.dateFormat = @"yyyy-MM-dd'T'HH:mm:ss";
    }
    
    return dateFormater;
}

+ (id)objectFromJson:(id)jsonObject {
    TCNotification *notification = [self parseFromDictionary:jsonObject class:[TCNotification class]];
    
    
    
    if (notification.createdAtString.length >= 19) {
        notification.createdAt = [[self dateFormatter] dateFromString:
                                  [notification.createdAtString substringToIndex:19]];
    }

    if (notification.updatedAtString.length >= 19) {
        notification.updatedAt = [[self dateFormatter] dateFromString:
                                  [notification.updatedAtString substringToIndex:19]];
    }
    
    return notification;
}

@end
