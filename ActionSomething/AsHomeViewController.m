//
//  AsLoginViewController.m
//  ActionSomething
//
//  Created by Tang Xiaomin on 6/3/13.
//  Copyright (c) 2013 AVOS. All rights reserved.
//

#import "AsHomeViewController.h"

@implementation AsHomeViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
    if (![AVUser currentUser]) { // no User logged in
        [super showLogInOrSignInView:NO];
    }
    
}



- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
