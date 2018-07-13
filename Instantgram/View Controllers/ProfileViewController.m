//
//  ProfileViewController.m
//  Instantgram
//
//  Created by Olivia Jorasch on 7/10/18.
//  Copyright © 2018 FBU. All rights reserved.
//

#import "ProfileViewController.h"
#import "CollectionFeedCell.h"
#import "DetailViewController.h"

@interface ProfileViewController () <UINavigationControllerDelegate,UIImagePickerControllerDelegate, UICollectionViewDelegate, UICollectionViewDataSource>
@property (weak, nonatomic) IBOutlet UICollectionView *collectionView;
@property (weak, nonatomic) IBOutlet UIImageView *profileImage;
@property (weak, nonatomic) IBOutlet UILabel *usernameLabel;
@property (strong, nonatomic) NSArray *posts;
@property (weak, nonatomic) IBOutlet UILabel *postsLabel;
@end

@implementation ProfileViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.collectionView.dataSource = self;
    self.collectionView.delegate = self;
    if (!self.user) {
        self.user = PFUser.currentUser;
    }
    self.usernameLabel.text = self.user.username;
    if (self.user.profilePic) {
        [self.profileImage setImageWithURL:[NSURL URLWithString:self.user.profilePic.url]];
    }
    self.profileImage.layer.cornerRadius = 35;
    self.profileImage.clipsToBounds = YES;
    [self fetchPosts];
    
    UICollectionViewFlowLayout *layout = self.collectionView.collectionViewLayout;
    
    layout.minimumInteritemSpacing = 3;
    layout.minimumLineSpacing = 3;
    
    CGFloat postsPerLine = 3;
    CGFloat postWidth = (self.collectionView.frame.size.width - layout.minimumInteritemSpacing * (postsPerLine - 1)) / postsPerLine;
    CGFloat postHeight = postWidth;
    layout.itemSize = CGSizeMake(postWidth, postHeight);
}

- (void)fetchPosts {
    PFQuery *query = [PFQuery queryWithClassName:@"Post"];
    [query orderByDescending:@"createdAt"];
    [query whereKey:@"author" equalTo:self.user];
    [query includeKey:@"author"];
    query.limit = 20;
    
    // fetch data asynchronously
    [query findObjectsInBackgroundWithBlock:^(NSArray *posts, NSError *error) {
        if (posts != nil) {
            NSLog(@"nice loading!");
            self.posts = posts;
            self.postsLabel.text = [NSString stringWithFormat:@"%lu", self.posts.count];
            [self.collectionView reloadData];
        } else {
            NSLog(@"Error: %@", error.localizedDescription);
        }
        //[self.refreshControl endRefreshing];
    }];
}

- (IBAction)didTapProfileImage:(id)sender {
    UIImagePickerController *imagePickerVC = [UIImagePickerController new];
    imagePickerVC.delegate = self;
    imagePickerVC.allowsEditing = YES;
    if ([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera]) {
        imagePickerVC.sourceType = UIImagePickerControllerSourceTypeCamera;
    }
    else {
        NSLog(@"Camera 🚫 available so we will use photo library instead");
        imagePickerVC.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
    }
    [self presentViewController:imagePickerVC animated:YES completion:nil];
}

- (UIImage *)resizeImage:(UIImage *)image withSize:(CGSize)size {
    UIImageView *resizeImageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, size.width, size.height)];
    
    resizeImageView.contentMode = UIViewContentModeScaleAspectFill;
    resizeImageView.image = image;
    
    UIGraphicsBeginImageContext(size);
    [resizeImageView.layer renderInContext:UIGraphicsGetCurrentContext()];
    UIImage *newImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    return newImage;
}

- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary<NSString *,id> *)info {
    UIImage *editedImage = info[UIImagePickerControllerEditedImage];
    CGSize size = CGSizeMake(500, 500);
    UIImage *image = [self resizeImage:editedImage withSize:size];
    
    self.profileImage.image=image;
    
    self.user.profilePic = [PFFile fileWithName:@"profilePic" data:UIImagePNGRepresentation(image)];
    [self.user saveInBackgroundWithBlock:^(BOOL succeeded, NSError * _Nullable error) {
        NSLog(@"saved user with new profile pic");
    }];
    
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    CollectionFeedCell *cell = sender;
    //NSIndexPath *indexPath = [self.collectionView indexPathForCell:cell];
    Post *post = cell.post;
    DetailViewController *detailViewController = [segue destinationViewController];
    detailViewController.post = post;
}


- (nonnull __kindof UICollectionViewCell *)collectionView:(nonnull UICollectionView *)collectionView cellForItemAtIndexPath:(nonnull NSIndexPath *)indexPath {
    CollectionFeedCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"CollectionFeedCell" forIndexPath:indexPath];
    Post *post = self.posts[indexPath.row];
    cell.post = post;
    [cell.pictureView setImageWithURL:[NSURL URLWithString:post.image.url]];
    return cell;
}

- (NSInteger)collectionView:(nonnull UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return self.posts.count;
}

@end
