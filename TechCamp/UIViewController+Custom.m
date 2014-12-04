//
//  UIViewController+Custom.m
//  TechCamp
//
//  Created by Tran Tu Duong on 12/4/14.
//  Copyright (c) 2014 TechCamp. All rights reserved.
//

#import "UIViewController+Custom.h"

@implementation UIViewController (Custom)

- (void)setFavourite:(BCTopic *)topic
{
    NSMutableDictionary *favourites = [self getFavourite];
    if (favourites) {
        NSString *topicId = topic.topicId;
        id modelTopic = [favourites valueForKeyPath:topicId];
        if (!modelTopic) {
            [favourites setObject:topic forKey:topicId];
        }
    }
    else {
        favourites = [@{} mutableCopy];
        [favourites setObject:topic forKey:topic.topicId];
    }
    
    [NSDEF setObject:[NSKeyedArchiver archivedDataWithRootObject:favourites] forKey:FAVOURITE_KEY];
}

- (NSMutableDictionary *)getFavourite
{
    NSData *data = [NSDEF objectForKey:FAVOURITE_KEY];
    NSMutableDictionary *favourites = [NSKeyedUnarchiver unarchiveObjectWithData:data];
    return favourites;
}

@end
