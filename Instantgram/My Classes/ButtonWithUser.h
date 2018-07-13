//
//  ButtonWithUser.h
//  Instantgram
//
//  Created by Olivia Jorasch on 7/12/18.
//  Copyright © 2018 FBU. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <Parse/Parse.h>

@interface ButtonWithUser : UIButton
@property (strong, nonatomic) PFUser *user;
@end
