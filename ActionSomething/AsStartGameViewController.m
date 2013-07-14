//
//  AsStartGameViewController.m
//  ActionSomething
//
//  Created by Tang Xiaomin on 6/5/13.
//  Copyright (c) 2013 AVOS. All rights reserved.
//

#import "AsStartGameViewController.h"
#import "AsCaptureViewController.h"

#define LEVEL_EASY 1
#define LEVEL_NORMAL 2
#define LEVEL_HARD 3

@interface AsStartGameViewController ()

@end

@implementation AsStartGameViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
    [self setupUI];

    NSLog(@"call cloud code");
    double cur = [[NSDate date] timeIntervalSince1970] * 1000;
    NSLog(@"current time: %f", cur);
    [AVCloud callFunctionInBackground:@"randomWord" withParameters:nil target:self selector:@selector(finishLoadWordsWithResult:error:)];
}

- (void)finishLoadWordsWithResult:(id)result error:(NSError *)error
{
    double cur = [[NSDate date] timeIntervalSince1970] * 1000;
    NSLog(@"current time: %f", cur);

    if (!result) {
        NSLog(@"%@", error);
    } else {
        NSLog(@"Success");
        NSArray *levelButtons = @[self.level1Button, self.level2Button, self.level3Button];
        if ([result isKindOfClass:[NSArray class]]) {
            for (NSDictionary *word in result) {
                int level = [[word objectForKey:@"level"] intValue];
                NSString *name = [word objectForKey:@"name"];
                if (level > LEVEL_HARD || level < LEVEL_EASY) {
                    NSLog(@"level is out of bound: %d, with name: %@", level, name);
                } else {
                    level = level - 1;
                    UIButton *button = [levelButtons objectAtIndex:level];
                    [button setTitle:name forState:UIControlStateNormal];
                    button.hidden = NO;
                }
            }
        } else {
            NSLog(@"has error %@", error);
        }

        [self.spinner stopAnimating];
    }
}

- (void)setupUI
{
    self.level1Button.hidden = YES;
    self.level2Button.hidden = YES;
    self.level3Button.hidden = YES;
    self.spinner.hidesWhenStopped = YES;
    [self.spinner startAnimating];
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([segue.identifier hasPrefix:@"CaptureView"]) {
        UIButton *triggerButton = (UIButton *)sender;
        NSString *name = triggerButton.currentTitle;
        NSNumber *level = [NSNumber numberWithInt:triggerButton.tag];
        AsWord *word = [[AsWord alloc] initWithName:name level:level];
        [(AsCaptureViewController *)segue.destinationViewController setSelectedWord:word];
    }
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
