//
//  BCSpeaker.h
//  TechCamp
//
//  Created by Tran Tu Duong on 11/28/14.
//  Copyright (c) 2014 TechCamp. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "JsonSerializable.h"

@interface BCSpeaker : JsonSerializable

@property (strong, nonatomic) NSString *speakerId, *name, *speakerDescription, *profile_url, *email, *phone, *createdAtString, *updatedAtString;

@property (nonatomic, strong) NSDate *createdAt;
@property (nonatomic, strong) NSDate *updatedAt;

+ (id)objectFromJson:(id)json;

@end
