//
//  AsBaseViewController.m
//  ActionSomething
//
//  Created by Tang Xiaomin on 6/5/13.
//  Copyright (c) 2013 AVOS. All rights reserved.
//

#import "AsBaseViewController.h"

@interface AsBaseViewController ()

@end

@implementation AsBaseViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)showLogInOrSignInView:(BOOL)animated
{
    AVLogInViewController *loginViewController = [[AVLogInViewController alloc] init];
    [loginViewController setDelegate:self];
    AVSignUpViewController *signupViewController = [[AVSignUpViewController alloc] init];
    [signupViewController setDelegate:self];
    [loginViewController setSignUpController:signupViewController];
    // remove dismiss button
    [loginViewController setFields:(AVLogInFieldsDefault & (~AVLogInFieldsDismissButton))];

    
    [self presentViewController:loginViewController animated:animated completion:NULL];
}

#pragma mark - AVLogInViewControllerDelegate

- (BOOL)logInViewController:(AVLogInViewController *)logInController shouldBeginLogInWithUsername:(NSString *)username password:(NSString *)password
{
    if (username && password && username.length && password.length) {
        return YES;
    }
    [[[UIAlertView alloc] initWithTitle:@"用户名或者密码未填"
                                message:@"请输入用户名或者密码"
                               delegate:nil
                      cancelButtonTitle:@"ok"
                      otherButtonTitles:nil] show];
    return NO;
}

- (void)logInViewControllerDidCancelLogIn:(AVLogInViewController *)logInController
{
    NSLog(@"Cance Login");
}

- (void)logInViewController:(AVLogInViewController *)logInController didLogInUser:(AVUser *)user
{
    NSLog(@"User %@ logged in", user.username);
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)logInViewController:(AVLogInViewController *)logInController didFailToLogInWithError:(NSError *)error
{
    NSDictionary *userInfo = [error userInfo];
    NSString * errorInfo = [userInfo objectForKey:@"error"];
    NSLog(@"login failed, %@", errorInfo);
}

#pragma mark - AVSignUpViewControllerDelegate
- (BOOL)signUpViewController:(AVSignUpViewController *)signUpController shouldBeginSignUp:(NSDictionary *)info
{
    BOOL isValidForm = YES;
    NSLog(@"info count %d", info.count);
    if (info.count < 3) {
        // need username password and email.
        isValidForm = NO;
    }
    for (id key in info) {
        NSString *field = [info objectForKey:key];
        NSLog(@"field: %@", field);
        if (!field || !field.length) {
            isValidForm = NO;
            break;
        }
    }
    if (!isValidForm) {
        [[[UIAlertView alloc] initWithTitle:@"注册出错" message:@"请完整填写表单内容" delegate:self cancelButtonTitle:@"ok" otherButtonTitles:nil] show];
    }
    NSLog(@"isValidform: %@", isValidForm?@"YES":@"NO");
    return isValidForm;
}

- (void)signUpViewController:(AVSignUpViewController *)signUpController didFailToSignUpWithError:(NSError *)error
{
    NSDictionary *userInfo = [error userInfo];
    NSLog(@"Signup failed %@", userInfo);
}

- (void)signUpViewController:(AVSignUpViewController *)signUpController didSignUpUser:(AVUser *)user
{
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)signUpViewControllerDidCancelSignUp:(AVSignUpViewController *)signUpController
{
    NSLog(@"cancel signup");
}

@end
