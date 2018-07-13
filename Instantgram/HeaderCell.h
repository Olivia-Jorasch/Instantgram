//
//  HeaderCell.h
//  Instantgram
//
//  Created by Olivia Jorasch on 7/12/18.
//  Copyright © 2018 FBU. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Post.h"
#import "ProfileViewController.h"
#import "ButtonWithUser.h"

@interface HeaderCell : UITableViewCell
@property (weak, nonatomic) IBOutlet ButtonWithUser *headerButton;
@property (weak, nonatomic) IBOutlet UIImageView *headerImage;
@property (weak, nonatomic) IBOutlet UILabel *headerLabel;
@property (strong, nonatomic) Post *post;
-(void)configureHeader:(Post *)post;
@end
