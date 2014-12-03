//
//  bCQuestionCell.m
//  TechCamp
//
//  Created by Tran Tu Duong on 12/3/14.
//  Copyright (c) 2014 TechCamp. All rights reserved.
//

#import "BCQuestionCell.h"

@implementation BCQuestionCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
    }
    return self;
}

- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)updateViewWithQuestion:(BCQuestion *)question{
    
    self.question = question;
    self.content.text = question.content;
    self.speaker.text = question.speaker.name;
    self.numberOfAnswer.text = [NSString stringWithFormat:@"%lu answers", (unsigned long)question.answers.count];
}

@end
