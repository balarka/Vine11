//
//  AVCamViewController.h
//  Vine11
//
//  Created by Balarka Velidi on 7/10/13.
//  Copyright (c) 2013 Balarka Velidi. All rights reserved.
//

#import <UIKit/UIKit.h>

@class AVCamCaptureManager, AVCamPreviewView, AVCaptureVideoPreviewLayer;

@interface AVCamViewController : UIViewController <UIImagePickerControllerDelegate,UINavigationControllerDelegate>


@property (nonatomic,retain) AVCamCaptureManager *captureManager;
@property (nonatomic,retain)  UIView *videoPreviewView;
@property (nonatomic,retain) AVCaptureVideoPreviewLayer *captureVideoPreviewLayer;
@property (nonatomic,retain)  UIButton *previewButton;
@property (nonatomic,retain)  UIButton *recordButton;
@property (nonatomic,retain)  UIButton *stillButton;
@property (nonatomic,retain)  UILabel *focusModeLabel;

- toggleRecording:(id)sender;
- captureStillImage:(id)sender;
- toggleCamera:(id)sender;

@end
