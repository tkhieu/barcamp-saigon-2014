//
//  BCTopicClient.h
//  TechCamp
//
//  Created by Tran Tu Duong on 11/28/14.
//  Copyright (c) 2014 TechCamp. All rights reserved.
//

#import "YAClient.h"

@interface BCTopicClient : YAClient

- (void)getTopicsWithBlock:(YAArrayResultBlock)block;

@end
