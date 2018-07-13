//
//  PostCell.h
//  Instantgram
//
//  Created by Olivia Jorasch on 7/10/18.
//  Copyright © 2018 FBU. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Post.h"
#import <DateTools.h>

@interface PostCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UIImageView *pictureView;
@property (weak, nonatomic) IBOutlet UILabel *captionLabel;
@property (weak, nonatomic) IBOutlet UILabel *dateLabel;

@property (strong, nonatomic) Post *post;
- (void)configureCell:(Post *)post;
@end
