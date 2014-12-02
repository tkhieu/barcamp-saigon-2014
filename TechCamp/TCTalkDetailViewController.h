//
//  TCTalkDetailViewController.h
//  TechCamp
//
//  Created by KONG on 13/3/14.
//  Copyright (c) 2014 TechCamp. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "BCTopic.h"

@interface TCTalkDetailViewController : UIViewController<UIAlertViewDelegate>

@property (nonatomic, strong) BCTopic *topic;

@property (nonatomic, strong) IBOutlet UIWebView *webView;

@end
