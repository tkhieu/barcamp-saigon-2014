//
//  BCAnswer.h
//  TechCamp
//
//  Created by Tran Tu Duong on 12/3/14.
//  Copyright (c) 2014 TechCamp. All rights reserved.
//

#import "JsonSerializable.h"

@interface BCAnswer : JsonSerializable

@property (strong, nonatomic) NSString *answerId, *content;

@end
