//
//  PFUser+ExtendUser.h
//  Instantgram
//
//  Created by Olivia Jorasch on 7/12/18.
//  Copyright © 2018 FBU. All rights reserved.
//

#import "PFUser.h"
#import <Parse/Parse.h>

@interface PFUser (ExtendUser) <PFSubclassing>
@property PFFile *profilePic;
@end
