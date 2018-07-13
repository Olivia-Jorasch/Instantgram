//
//  DetailViewController.m
//  Instantgram
//
//  Created by Olivia Jorasch on 7/10/18.
//  Copyright © 2018 FBU. All rights reserved.
//

#import "DetailViewController.h"
#import "UIImageView+AFNetworking.h"
#import <DateTools.h>

@interface DetailViewController ()
@property (weak, nonatomic) IBOutlet UIImageView *pictureView;
@property (weak, nonatomic) IBOutlet UILabel *usernameLabel;
@property (weak, nonatomic) IBOutlet UILabel *dateLabel;
@property (weak, nonatomic) IBOutlet UILabel *captionLabel;
@property (weak, nonatomic) IBOutlet UILabel *likesLabel;
@property (weak, nonatomic) IBOutlet UIButton *likeButton;
@end

@implementation DetailViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self configureDetails];
    // Do any additional setup after loading the view.
}

- (IBAction)didTapLike:(id)sender {
    if (self.likeButton.selected) {
        for (NSInteger index = 0; index < self.post.likeUsers.count; index++) {
            NSLog(@"%@",self.post.likeUsers);
            if ([PFUser.currentUser.username isEqual:self.post.likeUsers[index]]) {
                [self.post removeObject:PFUser.currentUser.username forKey:@"likeUsers"];
                NSNumber *decrement = [NSNumber numberWithInt:-1];
                [self.post incrementKey:@"likeCount" byAmount:decrement];
                self.likeButton.selected = NO;
                self.likesLabel.text = [[NSString stringWithFormat:@"%lu", self.post.likeUsers.count] stringByAppendingString:@" likes"];
                break;
            }
        }
    } else {
        [self.post addObject:PFUser.currentUser.username forKey:@"likeUsers"];
        [self.post incrementKey:@"likeCount"];
        self.likeButton.selected = YES;
        self.likesLabel.text = [[NSString stringWithFormat:@"%lu", self.post.likeUsers.count] stringByAppendingString:@" likes"];
    }
    [self.post saveInBackgroundWithBlock:^(BOOL succeeded, NSError * _Nullable error) {
        if (succeeded) {
            NSLog(@"Successfully updated like count");
        } else {
            NSLog(@"Error: %@", error.localizedDescription);
        }
    }];
}

- (void)configureDetails {
    self.pictureView.image = nil;
    [self.pictureView setImageWithURL:[NSURL URLWithString:self.post.image.url]];
    self.captionLabel.text = self.post.caption;
    self.usernameLabel.text = self.post.author.username;
    self.dateLabel.text = [self.post.createdAt timeAgoSinceNow];
    for (NSString *username in self.post.likeUsers) {
        if ([PFUser.currentUser.username isEqual:username]) {
            self.likeButton.selected = YES;
            break;
        }
    }
    self.likesLabel.text = [[NSString stringWithFormat:@"%lu", self.post.likeUsers.count] stringByAppendingString:@" likes"];
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
