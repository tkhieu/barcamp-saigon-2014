//
//  BCListQuestionViewController.m
//  TechCamp
//
//  Created by Tran Tu Duong on 12/3/14.
//  Copyright (c) 2014 TechCamp. All rights reserved.
//

#import "BCListQuestionViewController.h"
#import "BCAnswerViewController.h"
#import "BCTopicClient.h"
#import "BCQuestion.h"
#import "BCQuestionCell.h"
#import <UIAlertView+Blocks/UIAlertView+Blocks.h>

@implementation BCListQuestionViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.refreshControl = [[UIRefreshControl alloc] init];
    [self.refreshControl addTarget:self action:@selector(getQuestions) forControlEvents:UIControlEventValueChanged];
    self.refreshControl = self.refreshControl;
    
    if (IS_OS_7_OR_LATER) {
        [self setNeedsStatusBarAppearanceUpdate];
        
        UIImageView *tempImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"Barcamp_Challenge"]];
        [tempImageView setFrame:self.tableView.frame];
        [tempImageView setContentMode:UIViewContentModeScaleAspectFit];
        self.tableView.backgroundView = tempImageView;
        
    }
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    [self getQuestions];
}

- (void)getQuestions
{
    [[BCTopicClient defaultClient] getListQuestionWithBlock:^(NSArray *objects, NSError *error) {
        if (objects && !error) {
            self.questions = objects;
            [self.tableView reloadData];
            
        } else {
            [UIAlertView showWithTitle:@"Oops" message:@"Refresh Questions got error! Please try again later." cancelButtonTitle:@"OK" otherButtonTitles:nil tapBlock:NULL];
        }
        [self.refreshControl endRefreshing];
    }];
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    // Return the number of sections.
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    // Return the number of rows in the section.
    return self.questions.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"BCQuestionCell";
    BCQuestionCell *cell = [self.tableView dequeueReusableCellWithIdentifier:CellIdentifier forIndexPath:indexPath];
    
    // Configure the cell...
    BCQuestion *question = [self.questions objectAtIndex:indexPath.row];
    
    [cell updateViewWithQuestion:question];
    
    return cell;
}


- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 110;
}


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    BCQuestion *selectedQuestion = self.questions[indexPath.row];
    
    BCAnswerViewController *detailVC = [self.storyboard instantiateViewControllerWithIdentifier:@"BCAnswerViewController"];
    
    detailVC.question = selectedQuestion;
    
    [self.navigationController pushViewController:detailVC animated:YES];
}

@end
