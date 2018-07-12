//
//  PFUser+ExtendUser.m
//  Instantgram
//
//  Created by Olivia Jorasch on 7/12/18.
//  Copyright © 2018 FBU. All rights reserved.
//

#import "PFUser+ExtendUser.h"

@implementation PFUser (ExtendUser)

-(void)setProfilePic:(PFFile *)profilePic {
    self[@"profilePic"] = profilePic;
}

-(PFFile *)profilePic {
    return self[@"profilePic"];
}

@end
