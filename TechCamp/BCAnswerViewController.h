//
//  BCAnswerViewController.h
//  TechCamp
//
//  Created by Tran Tu Duong on 12/3/14.
//  Copyright (c) 2014 TechCamp. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BCQuestion.h"

@interface BCAnswerViewController : UIViewController<RadioButtonDelegate>

@property (strong, nonatomic) BCQuestion *question;

@property (weak, nonatomic) IBOutlet UIScrollView *labelAnswer;
@property (weak, nonatomic) IBOutlet UILabel *labelContentQuestion;
@property (weak, nonatomic) IBOutlet UILabel *labelSpeaker;
@property (weak, nonatomic) IBOutlet UIScrollView *scrollView;
@property (weak, nonatomic) IBOutlet UIView *viewAnswer;
@property (weak, nonatomic) IBOutlet UIImageView *imageView;


@end
