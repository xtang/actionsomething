//
//  AsStartGameViewController.m
//  ActionSomething
//
//  Created by Tang Xiaomin on 6/5/13.
//  Copyright (c) 2013 AVOS. All rights reserved.
//

#import "AsStartGameViewController.h"

#define LEVEL_EASY 1
#define LEVEL_NORMAL 2
#define LEVEL_HARD 3

@interface AsStartGameViewController ()

@property (weak, nonatomic) NSArray *levelButtons;

@end

@implementation AsStartGameViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    if (!self.levelButtons) {
        self.levelButtons = @[self.level1Button, self.level2Button, self.level3Button];
    }
	// Do any additional setup after loading the view.
    
    NSLog(@"call cloud code");
    NSArray *ret = [AVCloud callFunction:@"randomWord" withParameters:nil];
    if ([ret isKindOfClass:[NSArray class]]) {
        for (NSDictionary *word in ret) {
            int level = [[word objectForKey:@"level"] intValue];
            NSString *name = [word objectForKey:@"name"];
            if (level > LEVEL_HARD || level < LEVEL_EASY) {
                NSLog(@"level is out of bound: %d, with name: %@", level, name);
            } else {
                level = level - 1;
                [[self.levelButtons objectAtIndex:level] setTitle:name forState:UIControlStateNormal];
            }
        }
    } else {
        NSLog(@"has error %@", ret);
    }
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([segue.identifier isEqualToString:@"CaptureView"]) {
        UIButton *triggerButton = (UIButton *)sender;
        NSLog(@"%@", triggerButton.currentTitle);
    }
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end