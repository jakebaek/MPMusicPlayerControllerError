//
//  AppDelegate.h
//  MPMusicPlayerControllerError
//
//  Created by hokun baek on 12. 3. 28..
//  Copyright (c) 2012년 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>

#define MY_APPDELEGATE (AppDelegate*)[[UIApplication sharedApplication] delegate]

@interface AppDelegate : UIResponder <UIApplicationDelegate>
{
    BOOL _otherAudioIsPlaying;
}

@property (strong, nonatomic) UIWindow *window;
@property (nonatomic, assign) BOOL otherAudioIsPlaying;

- (void)initAudioSession;
- (void)checkOtherAudioIsPlaying;

@end
