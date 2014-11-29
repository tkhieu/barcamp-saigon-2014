//
//  BCSpeaker.m
//  TechCamp
//
//  Created by Tran Tu Duong on 11/28/14.
//  Copyright (c) 2014 TechCamp. All rights reserved.
//

#import "BCSpeaker.h"
#import "NSObject+JsonMapping.h"

static NSDateFormatter *dateFormater = nil;

@implementation BCSpeaker

+ (NSDateFormatter *)dateFormatter {
    if (!dateFormater) {
        dateFormater = [[NSDateFormatter alloc] init];
        dateFormater.dateFormat = @"yyyy-MM-dd HH:mm:ss";
    }
    
    return dateFormater;
}


+ (id)objectFromJson:(id)jsonObject {
    BCSpeaker *object = [NSObject objectFromJson:jsonObject forClass:[self class] mappingDictionary:@{@"description": @"speakerDescription", @"created_at": @"createdAtString", @"updated_at" : @"updatedAtString", @"id" : @"speakerId"}];
    
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
