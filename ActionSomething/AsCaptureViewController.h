//
//  AsCaptureViewController.h
//  ActionSomething
//
//  Created by Tang Xiaomin on 6/8/13.
//  Copyright (c) 2013 AVOS. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AsWord.h"

@interface AsCaptureViewController : UIViewController<UIGestureRecognizerDelegate, UIActionSheetDelegate>

@property (strong, nonatomic) AsWord* selectedWord;
@property (weak, nonatomic) IBOutlet UIProgressView *progressView;
@property (weak, nonatomic) IBOutlet UIButton *finishButton;
@property (weak, nonatomic) IBOutlet UINavigationItem *navigationBar;

- (IBAction)cancelCapture:(id)sender;
- (IBAction)finishCapture:(id)sender;
@end
