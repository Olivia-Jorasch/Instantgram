//
//  CollectionFeedCell.h
//  Instantgram
//
//  Created by Olivia Jorasch on 7/11/18.
//  Copyright © 2018 FBU. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Post.h"

@interface CollectionFeedCell : UICollectionViewCell
@property (weak, nonatomic) IBOutlet UIImageView *pictureView;
@property (strong, nonatomic) Post *post;
@end
