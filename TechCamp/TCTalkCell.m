//
//  TCTalkCell.m
//  TechCamp
//
//  Created by KONG on 13/3/14.
//  Copyright (c) 2014 TechCamp. All rights reserved.
//

#import "TCTalkCell.h"

#import "UIImage+ColorTransformation.h"

@implementation TCTalkCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
    }
    return self;
}

- (void)awakeFromNib
{
    // Initialization code
    
    
//    UIColor *barTintColor = [[UINavigationBar appearance] barTintColor];
    UIColor *barTintColor = [UIColor grayColor];
    [_voteButton setImage:[[_voteButton imageForState:UIControlStateNormal] imageWithTint:barTintColor] forState:UIControlStateNormal];
    
    [_favoriteButton setImage:[[_favoriteButton imageForState:UIControlStateNormal] imageWithTint:barTintColor] forState:UIControlStateNormal];
    
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)updateViewWithTalk:(BCTopic *)topic {
    self.topic = topic;
    
    self.titleLabel.text = topic.title;
    self.speakerNameLabel.text = topic.speaker.name;
    
//    [_voteButton setTitle:[NSString stringWithFormat:@"%@ votes", _topic.voteCount] forState:UIControlStateNormal];
//    
//    if ([_topic.favCount intValue] > 0) {
//        _favoriteButton.hidden = NO;
//        [_favoriteButton setTitle:[NSString stringWithFormat:@"%@ favorites", _talk.favCount] forState:UIControlStateNormal];
//    } else {
//        _favoriteButton.hidden = YES;
//    }
}

@end
