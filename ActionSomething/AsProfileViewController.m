//
//  AsProfileViewController.m
//  ActionSomething
//
//  Created by Tang Xiaomin on 6/5/13.
//  Copyright (c) 2013 AVOS. All rights reserved.
//

#import "AsProfileViewController.h"

@interface AsProfileViewController ()

@end

@implementation AsProfileViewController

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

- (IBAction)logout:(id)sender {
    [AVUser logOut];
    [self.tabBarController setSelectedIndex:0];
    [super showLogInOrSignInView:YES];
}
@end
