//
//  ProfileViewController.h
//  Instantgram
//
//  Created by Olivia Jorasch on 7/10/18.
//  Copyright © 2018 FBU. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <Parse/Parse.h>
#import "User.h"
#import "UIImageView+AFNetworking.h"
#import "PostCell.h"
#import "Post.h"

@interface ProfileViewController : UIViewController
@property (strong, nonatomic) User *user;
@end
