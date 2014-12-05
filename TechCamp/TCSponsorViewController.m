//
//  TCSponsorViewController.m
//  TechCamp
//
//  Created by Tran Tu Duong on 12/5/14.
//  Copyright (c) 2014 TechCamp. All rights reserved.
//

#import "TCSponsorViewController.h"

@interface TCSponsorViewController ()

@end

@implementation TCSponsorViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.imageView.image = [UIImage imageNamed:@"Sponsor"];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
