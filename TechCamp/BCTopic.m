//
//  BCTopic.m
//  TechCamp
//
//  Created by Tran Tu Duong on 11/28/14.
//  Copyright (c) 2014 TechCamp. All rights reserved.
//

#import "BCTopic.h"
#import "NSObject+JsonMapping.h"

static NSDateFormatter *dateFormater = nil;

@implementation BCTopic

+ (NSDateFormatter *)dateFormatter {
    if (!dateFormater) {
        dateFormater = [[NSDateFormatter alloc] init];
        dateFormater.dateFormat = @"yyyy-MM-dd'T'HH:mm:ss";
    }
    
    return dateFormater;
}

+ (NSMutableDictionary *)customMapping
{
    return [@{@"description": @"topicDescription", @"created_at": @"createdAtString", @"updated_at" : @"updatedAtString", @"id": @"topicId"} mutableCopy];
}

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

+ (id)objectFromJson:(id)jsonObject {
    BCTopic *object = [self parseFromDictionary:jsonObject class:[self class]];
    
    //    object.time = @"10:00 - 11:00";
    //    object.location = @"room 20";
    
    if (object.createdAtString.length >= 19) {
        object.createdAt = [[self dateFormatter] dateFromString:
                            [object.createdAtString substringToIndex:19]];
    }
    
    if (object.updatedAtString.length >= 19) {
        object.updatedAt = [[self dateFormatter] dateFromString:
                            [object.updatedAtString substringToIndex:19]];
    }
    
    
    return object;
}

@end
