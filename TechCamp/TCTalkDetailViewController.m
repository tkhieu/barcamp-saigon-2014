//
//  TCTalkDetailViewController.m
//  TechCamp
//
//  Created by KONG on 13/3/14.
//  Copyright (c) 2014 TechCamp. All rights reserved.
//

#import "TCTalkDetailViewController.h"
#import "TCQRCodeViewController.h"
#import "UIImage+ColorTransformation.h"
#import "BCTopic.h"
#import "BCTopicClient.h"
#import <TSMessages/TSMessage.h>

@interface TCTalkDetailViewController ()


@property (nonatomic, strong) UIButton *voteButton, *favoriteButton;

@end

@implementation TCTalkDetailViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}


- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    [self.navigationController setToolbarHidden:NO animated:YES];
}


- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    [self.navigationController setToolbarHidden:YES animated:YES];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
    
    NSString *htmlString = [self htmlStringForTalk:_topic];
    
    self.webView.dataDetectorTypes = UIDataDetectorTypeLink;
    [self.webView loadHTMLString:htmlString baseURL:nil];
    
    UIColor *tintColor = self.navigationController.navigationBar.tintColor;
    
    
    UIButton *voteButton = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 80, 40)];

    [voteButton addTarget:self action:@selector(voteButtonPressed:) forControlEvents:UIControlEventTouchUpInside];
    
//    if (_talk.voted) {
//        [voteButton setTitle:@"Voted" forState:UIControlStateNormal];
//        voteButton.enabled = NO;
//    } else {
//        [voteButton setTitle:@"Vote" forState:UIControlStateNormal];
//    }
    
    [voteButton setImage:[[UIImage imageNamed:@"vote_active"] imageWithTint:tintColor] forState:UIControlStateNormal];
    [voteButton setImageEdgeInsets:UIEdgeInsetsMake(0, 0, 0, 10)];
    [voteButton setTitleColor:tintColor forState:UIControlStateNormal];
    
    UIBarButtonItem *voteButtonItem = [[UIBarButtonItem alloc] initWithCustomView:voteButton];
    
    
    UIButton *favButton = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 100, 40)];
    [favButton addTarget:self action:@selector(favButtonPressed:) forControlEvents:UIControlEventTouchUpInside];
    
    [favButton setImage:[[UIImage imageNamed:@"saved_talks_icon_active"] imageWithTint:tintColor] forState:UIControlStateNormal];
    [favButton setImageEdgeInsets:UIEdgeInsetsMake(0, 0, 0, 10)];
    [favButton setTitleColor:tintColor forState:UIControlStateNormal];
    
    UIBarButtonItem *favButtonItem = [[UIBarButtonItem alloc] initWithCustomView:favButton];

    
    
    self.toolbarItems = @[voteButtonItem,
                          [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:nil action:nil],
                          favButtonItem,
                          [[UIBarButtonItem alloc] initWithTitle:@" ? " style:UIBarButtonItemStylePlain target:self action:@selector(infoButtonPressed:)]
                          ];
    
    
    self.voteButton = voteButton;
    self.favoriteButton = favButton;
    
    NSMutableDictionary *favourites = [self getFavourite];
    if (favourites) {
        id topic = [favourites valueForKeyPath:self.topic.topicId];
        if (topic) {
            self.favoriteButton.enabled = NO;
        }
        else {
            self.favoriteButton.enabled = YES;
        }
    }
    
    self.title = _topic.speaker.name;
}


- (NSString *)htmlStringForTalk:(BCTopic *)talk {
    NSString *htmlString = [NSString stringWithFormat:
                            @"<h2 class='title' style='font-family:HelveticaNeue-CondensedBold;'><font color='#FF3B30'>%@</font></h2>\
                            <p class='name'><font color='gray'><b>%@</b></font></p>\
                            <p class='name'><font color='gray' style='font-size:0.8em;line-height:0.8em;'>%@ votes</font></p>\
                            ",
                            talk.title, talk.speaker.name, talk.vote_count];
    
    
    if (talk) {
        htmlString = [htmlString stringByAppendingFormat:
                      @"<p class='name'><font color='gray' style='font-size:0.8em;line-height:0.8em;'><b>Time: </b>%@</font></p>", talk.duration];
    }
    
    NSString *descriptionString = [NSString stringWithFormat:
                            @"<hr style = 'background-color:#FF3B30; border-width:0; color:#FF3B30; height:1px; lineheight:0;'/>\
                            <p class='desciption'><font color='#181818' style='line-height:2em;'>%@</font></p>\
                            <h3>Speaker</h3>\
                            <p><font color='#181818' style='line-height:2em;'>%@</font></p>",
                            talk.topicDescription, talk.speaker.speakerDescription];
        
    htmlString = [NSString stringWithFormat:@"<html><body style='font-size:16px;font-family:HelveticaNeue;'>%@%@<p>&nbsp;</p></body></html>", htmlString, descriptionString];
    
    return htmlString;

}


- (void)voteButtonPressed:(id)sender {
    
    if ([NSDEF objectForKey:kUserLoggedIn]) {
        [SVProgressHUD dismiss];
        [SVProgressHUD show];
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
            dispatch_async(dispatch_get_main_queue(), ^{
                TCQRCodeViewController* vc = [self.storyboard instantiateViewControllerWithIdentifier:@"TCQRCodeViewController"];
                vc.status = StatusQRCodeVote;
                vc.topicId = self.topic.topicId;
                [self.navigationController pushViewController:vc animated:YES];
            });
        });
    }
    else {
        UIAlertView *loginConfirm = [[UIAlertView alloc] initWithTitle:@"Cofirm" message:@"Login to vote?" delegate:self cancelButtonTitle:@"No" otherButtonTitles:@"Yes", nil];
        [loginConfirm show];
    }
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (buttonIndex == 1) {
        [SVProgressHUD show];
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
            dispatch_async(dispatch_get_main_queue(), ^{
                TCQRCodeViewController* vc = [self.storyboard instantiateViewControllerWithIdentifier:@"TCQRCodeViewController"];
                vc.status = StatusQRCodeLogin;
                vc.topicId = self.topic.topicId;
                [self.navigationController pushViewController:vc animated:YES];
            });
        });
    }
}

- (void)favButtonPressed:(id)sender {
    
    NSDateComponents *components = [[NSCalendar currentCalendar] components:NSCalendarUnitDay | NSCalendarUnitMonth | NSCalendarUnitYear fromDate:[NSDate date]];

    NSInteger day = [components day];
    NSInteger month = [components month];
    NSInteger year = [components year];
    
//    if (day != 14 || month != 12 || year != 2014) {
//        [[[UIAlertView alloc] initWithTitle:@"Favorite" message:@"So excited! This feature will be available on event day." delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil] show];
//        return;
//    }
    
    [self setFavourite:self.topic];
    self.favoriteButton.enabled = NO;
}


- (void)infoButtonPressed:(id)sender {
    [[[UIAlertView alloc] initWithTitle:@"Help" message:
      @"Vote button is used to choose topics presented in BarCamp.\n\nKeep camp\nand\nBarCamp Saigon."
                               delegate:nil cancelButtonTitle:@"OK!" otherButtonTitles:nil] show];
}

- (void)showMessage:(NSString *)message type:(TSMessageNotificationType)type {
    
    // Temporary fix for iOS6
    if (IS_OS_7_OR_LATER) {
        [TSMessage showNotificationInViewController:self
                                              title:message
                                           subtitle:nil
                                              image:nil
                                               type:type
                                           duration:TSMessageNotificationDurationAutomatic
                                           callback:NULL
                                        buttonTitle:nil
                                     buttonCallback:nil
                                         atPosition:TSMessageNotificationPositionTop
                               canBeDismissedByUser:YES];
    } else {
        [TSMessage showNotificationInViewController:self
                                              title:message
                                           subtitle:nil
                                              image:nil
                                               type:type
                                           duration:TSMessageNotificationDurationAutomatic
                                           callback:NULL
                                        buttonTitle:nil
                                     buttonCallback:nil
                                         atPosition:TSMessageNotificationPositionBottom
                               canBeDismissedByUser:YES];
    }
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
