//
//  TCMultiChoiceViewController.m
//  TechCamp
//
//  Created by Tran Tu Duong on 12/3/14.
//  Copyright (c) 2014 TechCamp. All rights reserved.
//

#import "BCAnswerViewController.h"
#import "TCQRCodeViewController.h"

@interface BCAnswerViewController ()

@property (strong, nonatomic) NSString *answerId;

@end

@implementation BCAnswerViewController


- (id)initWithNibName:(NSString *)nibNameOrNil question:(BCQuestion *)question
{
    self = [super initWithNibName:nibNameOrNil bundle:nil];
    if (self) {
        // Custom initialization
        self.question = question;
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"Answer";
    
    // Do any additional setup after loading the view from its nib.
    self.labelContentQuestion.numberOfLines = 0;
    self.labelContentQuestion.lineBreakMode = NSLineBreakByWordWrapping;
    self.labelContentQuestion.textAlignment = NSTextAlignmentJustified;
    self.labelContentQuestion.text = self.question.content;
    
    
    [self.labelContentQuestion sizeToFit];
    self.labelSpeaker.text = self.question.speaker.name;
    
    CGRect frame = self.labelSpeaker.frame;
    frame.origin.y = self.labelContentQuestion.frame.origin.y + self.labelContentQuestion.frame.size.height + 10;
    self.labelSpeaker.frame = frame;
    
    frame = self.imageView.frame;
    frame.origin.y = self.labelContentQuestion.frame.origin.y + self.labelContentQuestion.frame.size.height + 11;
    self.imageView.frame = frame;
    
    frame = self.labelAnswer.frame;
    frame.origin.y = self.imageView.frame.origin.y + self.imageView.frame.size.height + 20;
    self.labelAnswer.frame = frame;
    
    for (NSInteger i = 0; i < self.question.answers.count; i++) {
        BCAnswer *answer = self.question.answers[i];
        RadioButton *radio = [self createRadioButtonWithIndex:i];
        UILabel *label = [self labelAtIndex:i text:answer.content];
        [self.viewAnswer addSubview:label];
        [self.viewAnswer addSubview:radio];
    }
    
    UIView *lastView = [self.viewAnswer.subviews lastObject];
    frame = self.viewAnswer.frame;
    frame.origin.y = self.labelAnswer.frame.origin.y + self.labelAnswer.frame.size.height + 20;
    frame.size.height = lastView.frame.origin.y + lastView.frame.size.height + 20;
    self.viewAnswer.frame = frame;
    
    UIButton *button = [[UIButton alloc] initWithFrame:CGRectMake(self.view.frame.size.width / 2 - 50, frame.origin.y + frame.size.height + 10, 100, 44)];
    button.backgroundColor = self.labelContentQuestion.textColor;
    [button setTitle:@"Submit" forState:UIControlStateNormal];
    button.layer.cornerRadius = 5;
    [button addTarget:self action:@selector(vote) forControlEvents:UIControlEventTouchUpInside];
    
    [self.scrollView addSubview:button];

    self.scrollView.contentSize = CGSizeMake(self.scrollView.frame.size.width, button.frame.origin.y + button.frame.size.height + 20);
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (UILabel *)labelAtIndex:(NSInteger)index text:(NSString *)text
{
    NSInteger size = 52;
    if (UIUserInterfaceIdiomPad == UI_USER_INTERFACE_IDIOM()){
        size = 64;
    }
    
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(size, size * index - 10, self.viewAnswer.frame.size.width - size - 20, size)];
    label.font = [UIFont fontWithName:label.font.familyName size:13.0f];
    label.numberOfLines = 0;
    label.text = text;
    
    return label;
}

- (RadioButton *)createRadioButtonWithIndex:(NSInteger )index
{
    RadioButton *radio = [[RadioButton alloc] initWithGroupId:@"Answer" index:index];
    
    [RadioButton addObserverForGroupId:@"Answer" observer:self];
    radio.userInteractionEnabled = YES;
    
    NSInteger size = 52;
    if (UIUserInterfaceIdiomPad == UI_USER_INTERFACE_IDIOM()){
        size = 64;
    }
    
    radio.frame = CGRectMake(0, size * index, size - 20, size - 20);
    radio.layer.borderColor = [UIColor blueColor].CGColor;
    radio.layer.borderWidth = 1;
    radio.layer.cornerRadius = radio.frame.size.height / 2;
    radio.layer.masksToBounds = YES;
    
    return radio;
}

- (void)radioButtonSelectedAtIndex:(NSUInteger)index inGroup:(NSString*)groupId
{
    BCAnswer *answer = self.question.answers[index];
    self.answerId = answer.answerId;
}

- (void)radiobuttonSetSelected:(RadioButton *)radio
{
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Warc-performSelector-leaks"
    SEL selHandleButtonTap = NSSelectorFromString(@"handleButtonTap:");
    [radio performSelector:selHandleButtonTap withObject:radio];
#pragma clang diagnostic pop
}

- (void)vote
{
    if (self.answerId) {
        [SVProgressHUD show];
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
            dispatch_async(dispatch_get_main_queue(), ^{
                TCQRCodeViewController* vc = [self.storyboard instantiateViewControllerWithIdentifier:@"TCQRCodeViewController"];
                vc.status = StatusQRCodeAnswer;
                vc.topicId = self.question.questionId;
                vc.answerId = self.answerId;
                [self.navigationController pushViewController:vc animated:YES];
            });
        });
    }
    else {
        [SVProgressHUD showErrorWithStatus:@"Please, select the answer"];
    }
}

@end
