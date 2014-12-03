//
//  BCQuestion.h
//  TechCamp
//
//  Created by Tran Tu Duong on 12/3/14.
//  Copyright (c) 2014 TechCamp. All rights reserved.
//

#import "JsonSerializable.h"
#import "BCAnswer.h"
#import "BCSpeaker.h"

@protocol BCAnswer;

@interface BCQuestion : JsonSerializable

@property (strong, nonatomic) NSString *questionId, *content;
@property (strong, nonatomic) BCSpeaker *speaker;
@property (strong, nonatomic) NSArray<BCAnswer> *answers;

@end
