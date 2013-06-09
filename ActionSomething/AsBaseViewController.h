//
//  AsBaseViewController.h
//  ActionSomething
//
//  Created by Tang Xiaomin on 6/5/13.
//  Copyright (c) 2013 AVOS. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface AsBaseViewController : UIViewController <AVLogInViewControllerDelegate, AVSignUpViewControllerDelegate>

- (void)showLogInOrSignInView:(BOOL)animated;

@end
