//
//  FeedViewController.m
//  Instantgram
//
//  Created by Olivia Jorasch on 7/9/18.
//  Copyright © 2018 FBU. All rights reserved.
//

#import "FeedViewController.h"
#import <Parse/Parse.h>
#import "AppDelegate.h"
#import "LoginViewController.h"
#import "UIImageView+AFNetworking.h"
#import "DetailViewController.h"
#import "HeaderCell.h"
#import "ProfileViewController.h"

@interface FeedViewController () <UITableViewDelegate, UITableViewDataSource>
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (strong, nonatomic) NSMutableArray *posts;
@property (nonatomic, strong) UIRefreshControl *refreshControl;
@property (nonatomic, assign) BOOL isMoreDataLoading;
@property (nonatomic, assign) int fetchNumber;
@end

@implementation FeedViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    self.posts = [[NSMutableArray alloc] init];
    self.fetchNumber = 20;
    //[self fetchPosts];
    self.refreshControl = [[UIRefreshControl alloc] init];
    [self.refreshControl addTarget:self action:@selector(fetchPosts) forControlEvents:UIControlEventValueChanged];
    [self.tableView insertSubview:self.refreshControl atIndex:0];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self fetchPosts];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (IBAction)logoutUser:(id)sender {
    [PFUser logOutInBackgroundWithBlock:^(NSError * _Nullable error) {
        AppDelegate *appDelegate = (AppDelegate *)[UIApplication sharedApplication].delegate;
        UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
        LoginViewController *loginViewController = [storyboard instantiateViewControllerWithIdentifier:@"LoginViewController"];
        appDelegate.window.rootViewController = loginViewController;
    }];
}

- (void)fetchPosts {
    PFQuery *query = [PFQuery queryWithClassName:@"Post"];
    [query orderByDescending:@"createdAt"];
    query.limit = self.fetchNumber;
    [query includeKey:@"author"];
    [query includeKey:@"likeCount"];
    [query includeKey:@"likeUsers"];
    // fetch data asynchronously
    [query findObjectsInBackgroundWithBlock:^(NSArray *posts, NSError *error) {
        if (posts != nil) {
            [self.posts setArray:posts];
            [self.tableView reloadData];
        } else {
            NSLog(@"%@", error.localizedDescription);
        }
        [self.refreshControl endRefreshing];
    }];
}


#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if ([segue.identifier isEqual:@"DetailSegue"]) {
        PostCell *cell = sender;
        NSIndexPath *indexPath = [self.tableView indexPathForCell:cell];
        Post *post = cell.post;
        DetailViewController *detailViewController = [segue destinationViewController];
        detailViewController.post = post;
        [self.tableView deselectRowAtIndexPath:indexPath animated:YES];
    } else if ([segue.identifier isEqual:@"UserSelectionSegue"]) {
        ButtonWithUser *button = sender;
        PFUser *user = button.user;
        ProfileViewController *profileViewController = [segue destinationViewController];
        profileViewController.user = user;
    }
}


- (nonnull UITableViewCell *)tableView:(nonnull UITableView *)tableView cellForRowAtIndexPath:(nonnull NSIndexPath *)indexPath {
    PostCell *cell = [tableView dequeueReusableCellWithIdentifier:@"PostCell"];
    NSLog(@"%@", self.posts);
    Post *post = self.posts[indexPath.section];
    [cell configureCell:post];
    return cell;
}

- (NSInteger)tableView:(nonnull UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 1;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return self.posts.count;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    HeaderCell *header = [tableView dequeueReusableCellWithIdentifier:@"HeaderCell"];
    Post *post = self.posts[section];
    [header configureHeader:post];
    return header;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 70;
}

-(void)loadMoreData{
    PFQuery *query = [PFQuery queryWithClassName:@"Post"];
    [query orderByDescending:@"createdAt"];
    Post *lastObject = self.posts.lastObject;
    query.skip = self.posts.count;
    //self.fetchNumber += 10;
    query.limit = self.fetchNumber;
    [query includeKey:@"author"];
    [query includeKey:@"likeCount"];
    [query includeKey:@"likeUsers"];
    // fetch data asynchronously
    [query findObjectsInBackgroundWithBlock:^(NSArray *posts, NSError *error) {
        if (posts != nil) {
            int counter = 0;
            NSMutableIndexSet *indexSet = [[NSMutableIndexSet alloc] init];
            for (Post *post in posts) {
                [indexSet addIndex:self.posts.count+counter];
                counter++;
            }
            [self.posts addObjectsFromArray:posts];
            self.isMoreDataLoading = false;
            [self.tableView insertSections:indexSet withRowAnimation:UITableViewRowAnimationNone];
        } else {
            NSLog(@"%@", error.localizedDescription);
        }
        [self.refreshControl endRefreshing];
    }];
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView{
    if(!self.isMoreDataLoading){
        // Calculate the position of one screen length before the bottom of the results
        int scrollViewContentHeight = self.tableView.contentSize.height;
        int scrollOffsetThreshold = scrollViewContentHeight - self.tableView.bounds.size.height;
        
        // When the user has scrolled past the threshold, start requesting
        if(scrollView.contentOffset.y > scrollOffsetThreshold && self.tableView.isDragging) {
            self.isMoreDataLoading = true;
            [self loadMoreData];
        }
    }
}

@end
