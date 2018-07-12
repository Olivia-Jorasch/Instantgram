//
//  User.h
//  Instantgram
//
//  Created by Olivia Jorasch on 7/11/18.
//  Copyright © 2018 FBU. All rights reserved.
//

#import "PFUser.h"
#import <Parse/Parse.h>
#import "UIImageView+AFNetworking.h"


@interface User : PFUser <PFSubclassing>

@property PFFile *profilePic;

@end
