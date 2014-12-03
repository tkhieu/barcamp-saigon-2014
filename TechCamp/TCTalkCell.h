//
//  TCTalkCell.h
//  TechCamp
//
//  Created by KONG on 13/3/14.
//  Copyright (c) 2014 TechCamp. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BCTopic.h"
@interface TCTalkCell : UITableViewCell

@property (nonatomic, strong) BCTopic *topic;


@property (nonatomic, strong) IBOutlet UILabel *titleLabel, *speakerNameLabel;

@property (nonatomic, strong) IBOutlet UIButton *voteButton;
- (void)updateViewWithTalk:(BCTopic *)talk;

@end
