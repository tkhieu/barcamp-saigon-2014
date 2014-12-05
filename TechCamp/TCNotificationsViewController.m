//
//  TCActivitiesViewController.m
//  TechCamp
//
//  Created by KONG on 13/3/14.
//  Copyright (c) 2014 TechCamp. All rights reserved.
//

#import "TCNotificationsViewController.h"
#import <UIAlertView+Blocks/UIAlertView+Blocks.h>
#import "TCNotificationCell.h"
#import "BCTopicClient.h"
#import "SVModalWebViewController.h"

@interface TCNotificationsViewController ()

@end

@implementation TCNotificationsViewController

- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];

    self.refreshControl = [[UIRefreshControl alloc] init];
    [self.refreshControl addTarget:self action:@selector(refreshNotifications) forControlEvents:UIControlEventValueChanged];
    self.refreshControl = self.refreshControl;
    
    [self loadCachedNotification];
    [self refreshNotifications];
    
    
    
    if (IS_OS_7_OR_LATER) {
        UIImageView *tempImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"Techcamp_Bot"]];
        [tempImageView setFrame:self.tableView.frame];
        [tempImageView setContentMode:UIViewContentModeCenter];
        self.tableView.backgroundView = tempImageView;
        
    }

}

- (void)refreshNotifications {
    [[BCTopicClient defaultClient] getNotificationsWithBlock:^(NSArray *objects, NSError *error) {
        if (objects && !error) {
            [self loadCachedNotification];
            [self.refreshControl endRefreshing];
        } else {
            [UIAlertView showWithTitle:@"Oops" message:@"Refresh Talks got error! Please try again later." cancelButtonTitle:@"OK" otherButtonTitles:nil tapBlock:NULL];
        }
    }];
}


- (void)loadCachedNotification {
    self.notifications = [[BCTopicClient defaultClient] cachedNotifications];
    [self.tableView reloadData];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    // Return the number of sections.
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    // Return the number of rows in the section.
//    return 0;
    return _notifications.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"TCNotificationCell";
    TCNotificationCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier forIndexPath:indexPath];
    
    // Configure the cell...
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    TCNotification *notificaton = [_notifications objectAtIndex:indexPath.row];
    
    [cell updateViewWithNotification:notificaton];
    
    return cell;

}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    TCNotification *notificaton = [_notifications objectAtIndex:indexPath.row];
    
    if ([notificaton.link rangeOfString:@"http://"].location == NSNotFound ||
        [notificaton.link rangeOfString:@"https://"].location == NSNotFound) {
        notificaton.link = [NSString stringWithFormat:@"http://%@", notificaton.link];
    }
    
    SVModalWebViewController *webViewController = [[SVModalWebViewController alloc] initWithAddress:notificaton.link];
    
    webViewController.barsTintColor = [[UINavigationBar appearance] tintColor];
    [self presentViewController:webViewController animated:YES completion:NULL];
}

/*
// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Return NO if you do not want the specified item to be editable.
    return YES;
}
*/

/*
// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        // Delete the row from the data source
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
    }   
    else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
    }   
}
*/

/*
// Override to support rearranging the table view.
- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath
{
}
*/

/*
// Override to support conditional rearranging of the table view.
- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Return NO if you do not want the item to be re-orderable.
    return YES;
}
*/

/*
#pragma mark - Navigation

// In a story board-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}

 */

@end
