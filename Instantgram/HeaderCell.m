//
//  HeaderCell.m
//  Instantgram
//
//  Created by Olivia Jorasch on 7/12/18.
//  Copyright © 2018 FBU. All rights reserved.
//

#import "HeaderCell.h"
#import "PFUser+ExtendUser.h"
#import "UIImageView+AFNetworking.h"


@implementation HeaderCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

-(void)configureHeader:(Post *)post {
    self.post = post;
    self.headerLabel.text = post.author.username;
    if (post.author.profilePic) {
        [self.headerImage setImageWithURL:[NSURL URLWithString:post.author.profilePic.url]];
    }
    self.headerImage.layer.cornerRadius = 26;
    self.headerImage.clipsToBounds = YES;
    self.headerButton.user = post.author;
}



@end
