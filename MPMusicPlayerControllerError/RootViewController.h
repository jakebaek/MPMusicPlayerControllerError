//
//  RootViewController.h
//  MPMusicPlayerControllerError
//
//  Created by hokun baek on 12. 3. 28..
//  Copyright (c) 2012년 __MyCompanyName__. All rights reserved.
//

#import <AVFoundation/AVFoundation.h>
#import <MediaPlayer/MediaPlayer.h>

#import <UIKit/UIKit.h>

@interface RootViewController : UIViewController <AVAudioPlayerDelegate>
{
    UIButton                *_buttonPlay;
    
    AVAudioPlayer           *_player;
    MPMusicPlayerController *_ipodPlayer;
    
    BOOL                    _ipodMusicPlaying;
    BOOL                    _needResumeIpodMusicPlay;
}

@property (nonatomic, strong) AVAudioPlayer *player;
@property (nonatomic, strong) MPMusicPlayerController *ipodPlayer;
@property (nonatomic, assign) BOOL ipodMusicPlaying;
@property (nonatomic, assign) BOOL needResumeIpodMusicPlay;

- (void)initSubviews;
- (void)layoutSubviews;

- (BOOL)playSoundAtPath:(NSString*)soundPath;
- (void)stopSound;

- (void)setMPMusicPlayerControllerPlaybackStateDidChangeNotification;
- (void)removeMPMusicPlayerControllerPlaybackStateDidChangeNotification;
- (void)handlePlaybackStateChanged:(id)notification;

@end
