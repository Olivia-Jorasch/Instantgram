//
//  HeaderCell.h
//  Instantgram
//
//  Created by Olivia Jorasch on 7/12/18.
//  Copyright © 2018 FBU. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Post.h"

@interface HeaderCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UIImageView *headerImage;
@property (weak, nonatomic) IBOutlet UILabel *headerLabel;
-(void)configureHeader:(Post *)post;
@end
