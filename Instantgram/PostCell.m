//
//  PostCell.m
//  Instantgram
//
//  Created by Olivia Jorasch on 7/10/18.
//  Copyright © 2018 FBU. All rights reserved.
//

#import "PostCell.h"
#import "UIImageView+AFNetworking.h"

@implementation PostCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)configureCell:(Post *)post {
    self.post = post;
    self.pictureView.image = nil;
    [self.pictureView setImageWithURL:[NSURL URLWithString:post.image.url]];
    self.captionLabel.text = post.caption;
}

@end
