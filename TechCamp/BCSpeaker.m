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

- (void)encodeWithCoder:(NSCoder *)coder
{
    [coder encodeObject:_speakerId forKey:@"speakerId"];
    [coder encodeObject:_name forKey:@"name"];
    [coder encodeObject:_speakerDescription forKey:@"speakerDescription"];
    [coder encodeObject:_profile_url forKey:@"profile_url"];
}
- (id)initWithCoder:(NSCoder *)coder {
    if((self = [super init])) {
        self.speakerId = [coder decodeObjectForKey:@"speakerId"];
        self.name = [coder decodeObjectForKey:@"name"];
        self.speakerDescription = [coder decodeObjectForKey:@"speakerDescription"];
        self.profile_url = [coder decodeObjectForKey:@"profile_url"];
    }
    
    return self;
}

@end
