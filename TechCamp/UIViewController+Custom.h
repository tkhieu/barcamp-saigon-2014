//
//  UIViewController+Custom.h
//  TechCamp
//
//  Created by Tran Tu Duong on 12/4/14.
//  Copyright (c) 2014 TechCamp. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BCTopic.h"

@interface UIViewController (Custom)

- (void)setFavourite:(BCTopic *)topic;
- (NSMutableDictionary *)getFavourite;

@end
