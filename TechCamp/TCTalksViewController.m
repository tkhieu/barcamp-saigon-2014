
//
//  TCTalkViewController.m
//  TechCamp
//
//  Created by KONG on 13/3/14.
//  Copyright (c) 2014 TechCamp. All rights reserved.
//

#import "TCTalksViewController.h"
#import "TCTalkCell.h"
#import <UIAlertView+Blocks/UIAlertView+Blocks.h>
#import "BCTopicClient.h"
#import "BCTopic.h"
#import "TCTalkDetailViewController.h"
#import "UIImage+ColorTransformation.h"

#import "NSObject+Random.h"
typedef enum {
  SortByCreatedAt,
  SortByVote,
  SortByRandom
} SortType;

@interface TCTalksViewController () <UIActionSheetDelegate>

@property (nonatomic, strong) NSMutableArray *searchResults;

@property (nonatomic, assign) SortType sortType;
@property (nonatomic) BOOL isFavourite;

@end

@implementation TCTalksViewController

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

    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
 
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
    
    self.refreshControl = [[UIRefreshControl alloc] init];
    [self.refreshControl addTarget:self action:@selector(refreshTalks) forControlEvents:UIControlEventValueChanged];
    self.refreshControl = self.refreshControl;
    
    
//    self.searchDisplayController.searchBar.barTintColor = [[UINavigationBar appearance] barTintColor];
//    self.searchDisplayController.searchBar.tintColor = [[UINavigationBar appearance] tintColor];
//    self.searchDisplayController.searchBar.translucent = NO;
    
    [self loadCachedTalks];
    [self refreshTalks];
    
    if (IS_OS_7_OR_LATER) {
        [self setNeedsStatusBarAppearanceUpdate];
        
        UIImageView *tempImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"techcamp_logo"]];
        [tempImageView setFrame:self.tableView.frame];
        [tempImageView setContentMode:UIViewContentModeScaleAspectFit];
        self.tableView.backgroundView = tempImageView;

    }

    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"Sort" style:UIBarButtonItemStyleBordered target:self action:@selector(showSortOption)];
    
    UIColor *tintColor = self.navigationController.navigationBar.tintColor;
    UIButton *favButton = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 100, 40)];
    [favButton addTarget:self action:@selector(favButtonPressed:) forControlEvents:UIControlEventTouchUpInside];
    
    [favButton setImage:[[UIImage imageNamed:@"saved_talks_icon_active"] imageWithTint:tintColor] forState:UIControlStateNormal];
    [favButton setTitleColor:tintColor forState:UIControlStateNormal];
    
    UIBarButtonItem *favButtonItem = [[UIBarButtonItem alloc] initWithCustomView:favButton];
    
    self.navigationItem.leftBarButtonItem = favButtonItem;
}

- (void)favButtonPressed:(UIButton *)sender
{
    if (sender.alpha == 1) {
        sender.alpha = 0.5;
        self.isFavourite = YES;
        self.favourites = [@[] mutableCopy];
        NSDictionary *favouriteTopics = [self getFavourite];
        NSArray *keys = [favouriteTopics allKeys];
        for (NSString *key in keys) {
            [self.favourites addObject:[favouriteTopics valueForKeyPath:key]];
        }
    }
    else {
        self.isFavourite = NO;
        sender.alpha = 1;
    }

    [self hideSearchBar:self.isFavourite];
    
    [self.tableView reloadData];
}

- (void)hideSearchBar:(BOOL)isHide
{
    NSInteger origin = 44;
    if (isHide) {
        origin = -44;
    }
    
    CGRect __block frameSearchBar = self.searchBar.frame;
    CGRect __block frameTableView = self.tableView.frame;
    
    [UIView animateWithDuration:0.2 animations:^{
        frameSearchBar.origin.y += origin;
        frameTableView.origin.y += origin;
        self.tableView.frame = frameTableView;
        self.searchBar.frame = frameSearchBar;
    }];
}

- (void)refreshTalks {
    [[BCTopicClient defaultClient] getTopicsWithBlock:^(NSArray *objects, NSError *error) {
        if (objects && !error) {
            self.talks = objects;
            [self loadCachedTalks];
            [self.refreshControl endRefreshing];
        } else {
            [UIAlertView showWithTitle:@"Oops" message:@"Refresh Topics got error! Please try again later." cancelButtonTitle:@"OK" otherButtonTitles:nil tapBlock:NULL];
        }
    }];
}


- (void)loadCachedTalks {
//    self.talks = [[BCTopicClient defaultClient] cachedTalks];
    
    [self sortBy:self.sortType];
    [self.tableView reloadData];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    // Return the number of sections.
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    if (self.isFavourite) {
        return self.favourites.count;
    }
    else {
        // Return the number of rows in the section.
        if (tableView == self.searchDisplayController.searchResultsTableView) {
            return [_searchResults count];
        }
    
        return _talks.count;
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"TCTalkCell";
    TCTalkCell *cell = [self.tableView dequeueReusableCellWithIdentifier:CellIdentifier forIndexPath:indexPath];
    
    // Configure the cell...
    BCTopic *topic = nil;
    
    if (self.isFavourite) {
        topic = [self.favourites objectAtIndex:indexPath.row];
    }
    else {
        if (tableView == self.searchDisplayController.searchResultsTableView) {
            topic = [_searchResults objectAtIndex:indexPath.row];
        } else {
            topic = [_talks objectAtIndex:indexPath.row];
        }
    }
    
    [cell updateViewWithTalk:topic];
    
    return cell;
}


- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 110;
}


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    //    [tableView deselectRowAtIndexPath:tableView.indexPathForSelectedRow animated:YES];
    
    
    BCTopic *selectedTalk = nil;
    
    if (self.isFavourite) {
        selectedTalk = [self.favourites objectAtIndex:indexPath.row];
    }
    else {
        if (tableView == self.searchDisplayController.searchResultsTableView) {
            selectedTalk = [_searchResults objectAtIndex:indexPath.row];
            
        } else {
            selectedTalk = [_talks objectAtIndex:indexPath.row];
        }
    }
    
    TCTalkDetailViewController *detailVC = [self.storyboard instantiateViewControllerWithIdentifier:@"TCTalkDetailViewController"];
    detailVC.topic = selectedTalk;

    [self.navigationController pushViewController:detailVC animated:YES];
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


#pragma mark - Navigation

// In a story board-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
    
    
    if ([segue.identifier isEqualToString:@"TalksPushToDetail"]) {
        
        
        
//        NSIndexPath *selectedIndexPath = []
        
//        detailVC.talk =
        
    }
}





#pragma mark Search

- (void)filterContentForSearchText:(NSString*)searchText scope:(NSString*)scope {
    NSPredicate *titlePredicate = [NSPredicate predicateWithFormat:@"title contains[c] %@", searchText];
    
    NSPredicate *namePredicate = [NSPredicate predicateWithFormat:@"speaker.name contains[c] %@", searchText];
    
    NSPredicate *fullPredicate = [NSCompoundPredicate orPredicateWithSubpredicates:@[titlePredicate, namePredicate]];

    
    if (_searchResults == nil) {
        self.searchResults = [NSMutableArray array];
    } else {
        [self.searchResults removeAllObjects];
    }
    
    [_searchResults addObjectsFromArray:
     [_talks filteredArrayUsingPredicate:fullPredicate]];
}

-(BOOL)searchDisplayController:(UISearchDisplayController *)controller shouldReloadTableForSearchString:(NSString *)searchString
{
    [self filterContentForSearchText:searchString
                               scope:[[self.searchDisplayController.searchBar scopeButtonTitles]
                                      objectAtIndex:[self.searchDisplayController.searchBar
                                                     selectedScopeButtonIndex]]];
    
    return YES;
}

-(UIStatusBarStyle)preferredStatusBarStyle{
    return UIStatusBarStyleLightContent;
}


- (void)showSortOption {
    UIActionSheet *actionSheet = [[UIActionSheet alloc] initWithTitle:nil delegate:self cancelButtonTitle:@"Cancel" destructiveButtonTitle:nil otherButtonTitles:@"Sort by Submit Date", @"Sort by Vote", @"Randomize", nil];
    
    [actionSheet showFromTabBar:self.tabBarController.tabBar];
}


- (void)actionSheet:(UIActionSheet *)actionSheet didDismissWithButtonIndex:(NSInteger)buttonIndex {
    if (buttonIndex != actionSheet.cancelButtonIndex) {
        [self sortBy:(int)buttonIndex];
        [self.tableView reloadData];

    }
}


- (void)sortBy:(SortType)sortType {
    
    self.sortType = sortType;
    
    switch (sortType) {
        case SortByCreatedAt: {
            self.talks = [_talks sortedArrayUsingComparator:^NSComparisonResult(BCTopic *obj1, BCTopic *obj2) {
                return [obj2.createdAt compare:obj1.createdAt];
            }];
        } break;
        case SortByVote: {
            self.talks = [_talks sortedArrayUsingComparator:^NSComparisonResult(BCTopic *obj1, BCTopic *obj2) {
                return [obj2.vote_count compare:obj1.vote_count];
            }];
        } break;
        case SortByRandom: {
            self.talks = [NSObject shuffleArray:_talks];
        } break;
        default:
            break;
    }
    
}
@end
