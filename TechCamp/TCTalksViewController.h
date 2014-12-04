//
//  TCTalkViewController.h
//  TechCamp
//
//  Created by KONG on 13/3/14.
//  Copyright (c) 2014 TechCamp. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface TCTalksViewController : UITableViewController

@property (nonatomic, strong) NSArray *talks;
@property (nonatomic, strong) NSMutableArray *favourites;
@property (weak, nonatomic) IBOutlet UISearchBar *searchBar;

@end
