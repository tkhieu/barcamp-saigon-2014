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

+ (NSMutableDictionary *)customMapping
{
    return [@{@"description": @"speakerDescription", @"id": @"speakerId"} mutableCopy];
}

@end
