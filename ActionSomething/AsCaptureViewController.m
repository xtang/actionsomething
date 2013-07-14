//
//  AsCaptureViewController.m
//  ActionSomething
//
//  Created by Tang Xiaomin on 6/8/13.
//  Copyright (c) 2013 AVOS. All rights reserved.
//

#import "AsCaptureViewController.h"
#import "GPUImage.h"

#define MOVIE_SIZE CGSizeMake(480.0, 480.0)
#define TEMP_PATH_OF_MOVIE(x) [NSHomeDirectory() stringByAppendingPathComponent:[NSString stringWithFormat:@"Documents/tmp_%d.mp4",x]]

const float kMaxCaptureTimeInSec = 6.0f;
const float kTimerInterval = 0.05f;

@interface AsCaptureViewController () {
    BOOL _isRecording;
    BOOL _isFinished;
}

@property (nonatomic, strong) GPUImageVideoCamera *videoCamera;
@property (nonatomic, strong) GPUImageOutput<GPUImageInput> *filter;
@property (nonatomic, strong) GPUImageMovieWriter *roughMovieWriter;
@property (nonatomic, strong) NSMutableArray *moviePaths;

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

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    if (!_videoCamera) {
        [self setupCamera];
        [self setupRoughWriterAndStartCapture];
    }
}

- (void)viewDidUnload
{
    [self setFilterView:nil];
    [super viewDidUnload];
}

- (IBAction)cancelCapture:(id)sender {
    self.selectedWord = nil;
    UIActionSheet *sheet = [[UIActionSheet alloc] initWithTitle:nil
                                                      delegate:self
                                             cancelButtonTitle:@"取消"
                                        destructiveButtonTitle:@"放弃拍摄"
                                             otherButtonTitles:nil];
    [sheet showInView:self.view];
}

- (IBAction)finishCapture:(id)sender {
}

#pragma mark - view Setup
- (void)setupCamera
{
    _videoCamera = [[GPUImageVideoCamera alloc] initWithSessionPreset:AVCaptureSessionPreset640x480 cameraPosition:AVCaptureDevicePositionBack];
    _videoCamera.outputImageOrientation = UIInterfaceOrientationPortrait;
    _videoCamera.horizontallyMirrorFrontFacingCamera = NO;
    _videoCamera.horizontallyMirrorRearFacingCamera = NO;
    
    _filter = [[GPUImageCropFilter alloc] initWithCropRegion:CGRectMake(0.0, 80.0 / 640.0, 1.0, 480.0/ 640.0)];
    [_videoCamera addTarget:_filter];
    [_filter addTarget:self.filterView];
    
    self.filterView.fillMode = kGPUImageFillModePreserveAspectRatioAndFill;

}

- (void)setupRoughWriterAndStartCapture
{
    NSString *path = [self nextFragmentPath];
    unlink([path UTF8String]); // If a file already exists, AVAssetWriter won't let you record new frames, so delete the old movie
    NSURL *movieURL = [NSURL fileURLWithPath:path];
    _roughMovieWriter = [[GPUImageMovieWriter alloc] initWithMovieURL:movieURL size:MOVIE_SIZE fileType:AVFileTypeMPEG4 outputSettings:nil];
    [_filter addTarget:_roughMovieWriter];
    double begin = [[NSDate date] timeIntervalSince1970] * 1000;
    [_videoCamera startCameraCapture];
    double end = [[NSDate date] timeIntervalSince1970] * 1000;
    NSLog(@"begin: %f, end: %f", begin, end);
    
    _videoCamera.audioEncodingTarget = _roughMovieWriter;
    [_roughMovieWriter startButPauseRecoding];
    
    NSLog(@"cost %f", end - begin);
}

- (void)setupUI
{
    [self.progressView setProgress:0.0];
    [self.navigationBar setTitle:[NSString stringWithFormat:@"表演%@",self.selectedWord.name]];
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

#pragma mark - Accessors
- (NSMutableArray *)moviePaths {
    if (!_moviePaths) {
        _moviePaths = [NSMutableArray array];
    }
    return _moviePaths;
}

#pragma mark - GPUImage 
- (NSString *)nextFragmentPath
{
    [self.moviePaths addObject:TEMP_PATH_OF_MOVIE(self.moviePaths.count)];
    
    return self.moviePaths.lastObject;
}

- (NSString *)currentFragmentPath {
    return self.moviePaths.lastObject;
}

#pragma mark - gesture responder

- (IBAction)handleLongPress:(UILongPressGestureRecognizer *)gesture
{
    if (gesture.state == UIGestureRecognizerStateBegan) {
        NSLog(@"resume recording");
//        [_roughMovieWriter resumeRecording];
        _isRecording = YES;
        [self updateProgress];
    } else if (gesture.state == UIGestureRecognizerStateEnded) {
        NSLog(@"pause recording");
//        [_roughMovieWriter pauseRecording];
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

- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex {
    if (buttonIndex == 0) {
        [self dismissViewControllerAnimated:YES completion:nil];
    }
}

@end

