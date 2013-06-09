//
//  AsCaptureViewController.m
//  ActionSomething
//
//  Created by Tang Xiaomin on 6/8/13.
//  Copyright (c) 2013 AVOS. All rights reserved.
//

#import "AsCaptureViewController.h"

const float kMaxCaptureTimeInSec = 6.0f;
const float kTimerInterval = 0.05f;

@interface AsCaptureViewController () {
    BOOL _isRecording;
    BOOL _isFinished;
}

@end

@implementation AsCaptureViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    _isFinished = NO;
    _isRecording = NO;
    [self setupUI];
    [self setupGesture];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)cancelCapture:(id)sender {
    self.selectedWord = nil;
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (IBAction)finishCapture:(id)sender {
}

#pragma mark - view Setup
- (void)setupUI
{
    [self.progressView setProgress:0.0];
}

- (void)setupGesture
{
    [self setupLongPressGesture];
}

- (void)setupLongPressGesture
{
    UILongPressGestureRecognizer *gesture = [[UILongPressGestureRecognizer alloc] initWithTarget:self
                                                                                          action:@selector(handleLongPress:)];
    gesture.delegate = self;
    gesture.minimumPressDuration = 0.05f;
    [self.view addGestureRecognizer:gesture];
}

#pragma mark - gesture responder

- (IBAction)handleLongPress:(UILongPressGestureRecognizer *)gesture
{
    if (gesture.state == UIGestureRecognizerStateBegan) {
        NSLog(@"resume recording");
        _isRecording = YES;
        [self updateProgress];
    } else if (gesture.state == UIGestureRecognizerStateEnded) {
        NSLog(@"pause recording");
        _isRecording = NO;
    }
}

- (void)updateProgress
{
    if (_isRecording) {        
        float lastProgress = self.progressView.progress;
        float curProgress = lastProgress + kTimerInterval / kMaxCaptureTimeInSec;
        if (curProgress >= 1.0f) {
            _isFinished = YES;
            return;
        }
        [self.progressView setProgress:curProgress animated:YES];
        [self performSelector:@selector(updateProgress) withObject:nil afterDelay:kTimerInterval];
    }
}

#pragma mark - delegate
- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldReceiveTouch:(UITouch *)touch
{
    if (!_isFinished && touch.view.tag == 1) {
        return YES;
    }
    return NO;
}

@end

