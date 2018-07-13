//
//  PostCell.m
//  Instantgram
//
//  Created by Olivia Jorasch on 7/10/18.
//  Copyright © 2018 FBU. All rights reserved.
//

#import "PostCell.h"
#import "UIImageView+AFNetworking.h"
#import <Parse/Parse.h>

@implementation PostCell

- (void)awakeFromNib {
    [super awakeFromNib];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
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

- (void)configureCell:(Post *)post {
    self.post = post;
    self.pictureView.image = nil;
    [self.pictureView setImageWithURL:[NSURL URLWithString:post.image.url]];
    self.captionLabel.text = post.caption;
    self.dateLabel.text = [post.createdAt timeAgoSinceNow];
    BOOL liked = NO;
    for (NSString *username in self.post.likeUsers) {
        if ([PFUser.currentUser.username isEqual:username]) {
            liked = YES;
            break;
        }
    }
    if (liked) {
        self.likeButton.selected = YES;
    } else {
        self.likeButton.selected = NO;
    }
    self.likesLabel.text = [[NSString stringWithFormat:@"%lu", self.post.likeUsers.count] stringByAppendingString:@" likes"];
}

@end
