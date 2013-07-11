//
//  PreviewVideoViewController.m
//  Vine11
//
//  Created by Balarka Velidi on 7/10/13.
//  Copyright (c) 2013 Balarka Velidi. All rights reserved.
//

#import "PreviewVideoViewController.h"


@interface PreviewVideoViewController ()<UIImagePickerControllerDelegate, UINavigationControllerDelegate>
@property (nonatomic, strong) UIButton *_cancel;
@property (nonatomic, strong) UIButton *_ok;
@property (nonatomic, strong) AVPlayer *avPlayer;
@end

@implementation PreviewVideoViewController

@synthesize videoFileURL;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];   
    UIImage *redButtonImage = [UIImage imageNamed:@"cross.png"];
    UIImage *tickImage = [UIImage imageNamed:@"tick.png"];
    self._cancel = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    [self._cancel setBackgroundImage:redButtonImage forState:UIControlStateNormal];
    self._cancel.frame = CGRectMake(0, 0, 60, 50);

    [self._cancel addTarget:self action:@selector(goBack:) forControlEvents:UIControlEventTouchDown];
    
    self._ok = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    self._ok.frame = CGRectMake(240, 390, 60, 50);
    [self._ok setBackgroundImage:tickImage forState:UIControlStateNormal];
    
//    [self._ok setTitle:@"POST" forState:UIControlStateNormal];
    
    [self.view addSubview: self._cancel];
    [self.view addSubview: self._ok];
    
    self.avPlayer = [[AVPlayer alloc] initWithURL:videoFileURL];
    AVPlayerLayer *l =[AVPlayerLayer playerLayerWithPlayer: self.avPlayer];
        
    [l setFrame: CGRectMake(0, 60, 320, 320)];
    [self.view.layer addSublayer:l];
    [self.avPlayer seekToTime:kCMTimeZero];
     self.avPlayer.actionAtItemEnd = AVPlayerActionAtItemEndNone;
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(playerItemDidReachEnd:)
                                                 name:AVPlayerItemDidPlayToEndTimeNotification
                                               object:[self.avPlayer currentItem]];
    [self.avPlayer play];
}

-(void) goBack: (id) sender
{
    [self dismissViewControllerAnimated:NO completion:nil];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)playerItemDidReachEnd:(NSNotification *)notification {
    AVPlayerItem *p = [notification object];
    [p seekToTime:kCMTimeZero];
}

@end
