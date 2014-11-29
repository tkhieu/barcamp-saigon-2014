//
//  BCTopic.h
//  TechCamp
//
//  Created by Tran Tu Duong on 11/28/14.
//  Copyright (c) 2014 TechCamp. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "BCSpeaker.h"
#import "JsonSerializable.h"

@interface BCTopic : JsonSerializable

@property (strong, nonatomic) NSString *topicId, *title, *topicDescription, *slide_url, *duration, *language, *category, *createdAtString, *updatedAtString;

@property (strong, nonatomic) BCSpeaker *speaker;
@property (nonatomic, strong) NSDate *createdAt;
@property (nonatomic, strong) NSDate *updatedAt;

+ (id)objectFromJson:(id)jsonObject;

@end
