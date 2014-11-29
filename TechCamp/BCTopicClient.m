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

@implementation BCTopicClient

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
    NSString *urlPath = [NSString stringWithFormat:@"/api/v1/topics"];
    
    [self getJsonWithPath:urlPath params:nil block:^(id object, NSError *error) {
        
        NSArray *topics = nil;
        if (object && !error) {
            [[TMCache sharedCache] setObject:object forKey:urlPath];
            topics = [self topicsFromJson:object];
        }
        
        block(topics, error);
    }];
}

@end
