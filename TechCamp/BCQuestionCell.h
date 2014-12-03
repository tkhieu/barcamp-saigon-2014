//
//  bCQuestionCell.h
//  TechCamp
//
//  Created by Tran Tu Duong on 12/3/14.
//  Copyright (c) 2014 TechCamp. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BCQuestion.h"

@interface BCQuestionCell : UITableViewCell

@property (nonatomic, strong) BCQuestion *question;
@property (nonatomic, strong) IBOutlet UILabel *content;
@property (nonatomic, strong) IBOutlet UILabel *speaker;
@property (nonatomic, strong) IBOutlet UILabel *numberOfAnswer;

- (void)updateViewWithQuestion:(BCQuestion *)question;

@end

