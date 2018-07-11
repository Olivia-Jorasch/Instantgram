//
//  DetailViewController.h
//  Instantgram
//
//  Created by Olivia Jorasch on 7/10/18.
//  Copyright © 2018 FBU. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Post.h"

@interface DetailViewController : UIViewController
@property (strong, nonatomic) Post *post;
@end
