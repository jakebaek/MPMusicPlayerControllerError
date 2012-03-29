//
//  RootViewController.m
//  MPMusicPlayerControllerError
//
//  Created by hokun baek on 12. 3. 28..
//  Copyright (c) 2012년 __MyCompanyName__. All rights reserved.
//

#import "AppDelegate.h"
#import "RootViewController.h"

#define RESOURCEPATH    [[NSBundle mainBundle] resourcePath]

@implementation RootViewController

@synthesize player = _player;
@synthesize ipodPlayer = _ipodPlayer;
@synthesize ipodMusicPlaying = _ipodMusicPlaying;
@synthesize needResumeIpodMusicPlay = _needResumeIpodMusicPlay;

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [self initSubviews];
    
    self.ipodPlayer = [MPMusicPlayerController iPodMusicPlayer];
    [self setMPMusicPlayerControllerPlaybackStateDidChangeNotification];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    [self layoutSubviews];
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    
    [self removeMPMusicPlayerControllerPlaybackStateDidChangeNotification];
}

- (void)viewDidUnload
{
    [super viewDidUnload];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

#pragma mark - Subviews

- (void)initSubviews
{
    _buttonPlay = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    [_buttonPlay setTitle:@"Play" forState:UIControlStateNormal];
    [_buttonPlay addTarget:self action:@selector(onTouchedPlayButton:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:_buttonPlay];
}

- (void)layoutSubviews
{
    CGRect rectClient = self.view.bounds;
    
    const CGFloat buttonHeight = 100;
    CGRect rectPlayButton = CGRectMake(0, rectClient.size.height-buttonHeight, rectClient.size.width, buttonHeight);
    [_buttonPlay setFrame:rectPlayButton];
}

#pragma mark - UIButton Target-Action

- (void)onTouchedPlayButton:(id)sender
{
    AppDelegate *app = MY_APPDELEGATE;
    if(app.otherAudioIsPlaying && self.ipodMusicPlaying)
    {
        [self.ipodPlayer pause];
        self.needResumeIpodMusicPlay = YES;
    }
    else 
    {
        self.needResumeIpodMusicPlay = NO;
    }
    
    BOOL bRet = [self playSoundAtPath:[RESOURCEPATH stringByAppendingPathComponent:@"test.mp3"]];
    if(bRet == FALSE)
    {
        NSLog(@"playSoundAtPath fail");
    }
}

#pragma mark - Member Function

- (BOOL)playSoundAtPath:(NSString*)soundPath
{
    BOOL bRet = FALSE;
    
    [self stopSound];
    
    if(self.player == nil)
    {
        NSError *error = nil;
        self.player = [[AVAudioPlayer alloc] initWithContentsOfURL:[NSURL fileURLWithPath:soundPath] error:&error];
        if(self.player)
        {
            self.player.delegate = self;
            self.player.numberOfLoops = 0;
            bRet = [_player prepareToPlay];
            if(bRet)
            {
                [_player play];
            }
        }
    }
    
    return bRet;
}

- (void)stopSound
{
    if(self.player)
    {
        self.player.delegate = nil;
        
        [self.player stop];
        self.player = nil;
    }
}

#pragma mark - AVAudioPlayerDelegate

- (void)audioPlayerDidFinishPlaying:(AVAudioPlayer *)player successfully:(BOOL)flag
{
    if(self.needResumeIpodMusicPlay)
    {
        [self.ipodPlayer play];
    }
}

#pragma mark - MPMusicPlayerController notification

- (void)setMPMusicPlayerControllerPlaybackStateDidChangeNotification
{
    NSNotificationCenter *notificationCenter = [NSNotificationCenter defaultCenter];
    [notificationCenter addObserver:self 
                           selector:@selector(handlePlaybackStateChanged:)
                               name:MPMusicPlayerControllerPlaybackStateDidChangeNotification 
                             object:self.ipodPlayer];
    [self.ipodPlayer beginGeneratingPlaybackNotifications];    
}

- (void)removeMPMusicPlayerControllerPlaybackStateDidChangeNotification
{
    NSNotificationCenter *notificationCenter = [NSNotificationCenter defaultCenter];
    [notificationCenter removeObserver:self
                                  name:MPMusicPlayerControllerPlaybackStateDidChangeNotification
                                object:self.ipodPlayer];
    [self.ipodPlayer endGeneratingPlaybackNotifications];
}

- (void)handlePlaybackStateChanged:(id)notification 
{
    static NSString * const stateKey = @"MPMusicPlayerControllerPlaybackStateKey";
    NSNumber *number = [[notification userInfo] objectForKey:stateKey];
    MPMusicPlaybackState playbackState = [number integerValue];    
    
    MPMusicRepeatMode repeatMode = self.ipodPlayer.repeatMode;
    
    if(playbackState == MPMusicPlaybackStatePlaying)
    {
        self.ipodMusicPlaying = YES;
    }
    else 
    {
        self.ipodMusicPlaying = NO;
    }
    
    NSLog(@"playbackState = [%d], repeatMode = [%d], ipodMusicPlaying = [%d]", playbackState, repeatMode, self.ipodMusicPlaying);
}

@end
