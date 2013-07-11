//
//  AVCamCaptureManager.h
//  Vine11
//
//  Created by Balarka Velidi on 7/10/13.
//  Copyright (c) 2013 Balarka Velidi. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <AVFoundation/AVFoundation.h>

@class AVCamRecorder;
@protocol AVCamCaptureManagerDelegate;

@interface AVCamCaptureManager : NSObject{
}

@property (nonatomic,retain) AVCaptureSession *session;
@property (nonatomic,assign) AVCaptureVideoOrientation orientation;
@property (nonatomic,retain) AVCaptureDeviceInput *videoInput;
@property (nonatomic,retain) AVCaptureDeviceInput *audioInput;
@property (nonatomic,retain) AVCaptureStillImageOutput *stillImageOutput;
@property (nonatomic,retain) AVCamRecorder *recorder;
@property (nonatomic,assign) id deviceConnectedObserver;
@property (nonatomic,assign) id deviceDisconnectedObserver;
@property (nonatomic,assign) UIBackgroundTaskIdentifier backgroundRecordingID;
@property (nonatomic,assign) id <AVCamCaptureManagerDelegate> delegate;

- (BOOL) setupSession;
- (void) startRecording;
- (void) stopRecording;
- (void) captureStillImage;
- (BOOL) toggleCamera;
- (NSUInteger) cameraCount;
- (NSUInteger) micCount;

@end

@protocol AVCamCaptureManagerDelegate <NSObject>
@optional
- (void) captureManager:(AVCamCaptureManager *)captureManager didFailWithError:(NSError *)error;
- (void) captureManagerRecordingBegan:(AVCamCaptureManager *)captureManager;
- (void) captureManagerRecordingFinished:(AVCamCaptureManager *)captureManager;
- (void) captureManagerStillImageCaptured:(AVCamCaptureManager *)captureManager;
- (void) captureManagerDeviceConfigurationChanged:(AVCamCaptureManager *)captureManager;
@end