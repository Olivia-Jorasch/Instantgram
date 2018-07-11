//
//  LoginViewController.m
//  Instantgram
//
//  Created by Olivia Jorasch on 7/9/18.
//  Copyright © 2018 FBU. All rights reserved.
//

#import "LoginViewController.h"
#import <Parse/Parse.h>

@interface LoginViewController ()
@property (weak, nonatomic) IBOutlet UITextField *usernameField;
@property (weak, nonatomic) IBOutlet UITextField *passwordField;
@property (weak, nonatomic) IBOutlet UITextField *emailField;

@end

@implementation LoginViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    /*
    
    PFQuery *query = [PFQuery queryWithClassName:@"gameScore"];
    [query findObjectsInBackgroundWithBlock:^(NSArray * _Nullable objects, NSError * _Nullable error) {
        NSLog(objects);
    }];*/
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (IBAction)loginUser:(id)sender {
    [PFUser logInWithUsernameInBackground:self.usernameField.text password:self.passwordField.text
        block:^(PFUser *user, NSError *error) {
            if (user) {
                [self performSegueWithIdentifier:@"LoginSegue" sender:nil];
            } else {
                NSLog(@"Error: %@", error.localizedDescription);
            }
      }];
}

- (IBAction)registerUser:(id)sender {
    // initialize a user object
    PFUser *newUser = [PFUser user];
    
    // set user properties
    newUser.username = self.usernameField.text;
    newUser.email = self.emailField.text;
    newUser.password = self.passwordField.text;
    
    // call sign up function on the object
    [newUser signUpInBackgroundWithBlock:^(BOOL succeeded, NSError * error) {
        if (error != nil) {
            NSLog(@"Error: %@", error.localizedDescription);
        } else {
            NSLog(@"User registered successfully");
            [self performSegueWithIdentifier:@"LoginSegue" sender:nil];
            
            // manually segue to logged in view
        }
    }];
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
