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
        [dateFormater setTimeZone:[NSTimeZone localTimeZone]];
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

- (void)encodeWithCoder:(NSCoder *)coder
{
    [coder encodeObject:_topicId forKey:@"topicId"];
    [coder encodeObject:_title forKey:@"title"];
    [coder encodeObject:_topicDescription forKey:@"topicDescription"];
    [coder encodeObject:_slide_url forKey:@"slide_url"];
    [coder encodeObject:_duration forKey:@"duration"];
    [coder encodeObject:_language forKey:@"language"];
    [coder encodeObject:_category forKey:@"category"];
    [coder encodeObject:_createdAtString forKey:@"createdAtString"];
    [coder encodeObject:_createdAtString forKey:@"updatedAtString"];
    [coder encodeObject:_speaker forKey:@"speaker"];
    [coder encodeObject:_createdAt forKey:@"createdAt"];
    [coder encodeObject:_updatedAt forKey:@"updatedAt"];
    [coder encodeObject:_vote_count forKey:@"vote_count"];
}
- (id)initWithCoder:(NSCoder *)coder {
    if((self = [super init])) {
        self.topicId = [coder decodeObjectForKey:@"topicId"];
        self.title = [coder decodeObjectForKey:@"title"];
        self.topicDescription = [coder decodeObjectForKey:@"topicDescription"];
        self.slide_url = [coder decodeObjectForKey:@"slide_url"];
        self.duration = [coder decodeObjectForKey:@"duration"];
        self.language = [coder decodeObjectForKey:@"language"];
        self.category = [coder decodeObjectForKey:@"category"];
        self.createdAtString = [coder decodeObjectForKey:@"createdAtString"];
        self.updatedAtString = [coder decodeObjectForKey:@"updatedAtString"];
        self.speaker = [coder decodeObjectForKey:@"speaker"];
        self.createdAt = [coder decodeObjectForKey:@"createdAt"];
        self.updatedAt = [coder decodeObjectForKey:@"updatedAt"];
        self.vote_count = [coder decodeObjectForKey:@"vote_count"];
    }
    
    return self;
}

@end
