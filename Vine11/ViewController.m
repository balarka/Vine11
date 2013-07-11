//
//  ViewController.m
//  Vine11
//
//  Created by Balarka Velidi on 7/9/13.
//  Copyright (c) 2013 Balarka Velidi. All rights reserved.
//

#import "ViewController.h"
#import "RecordVideoViewController.h"
#import "AVCamViewController.h"

@interface ViewController ()<UIImagePickerControllerDelegate, UINavigationControllerDelegate>
@property (nonatomic) BOOL playvid;
@end

@implementation ViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void) loadView
{
    UIView *v = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 300, 300)];
    v.backgroundColor = [UIColor whiteColor];

    UIButton *button = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    [button addTarget:self action:@selector(startRecording:)
     forControlEvents:UIControlEventTouchDown];
    [button setTitle:@"Start Recording" forState:UIControlStateNormal];
    button.frame = CGRectMake(80.0, 210.0, 160.0, 40.0);
    [v addSubview:button];
    self.view = v;
}

-(void) startRecording: sender
{
    AVCamViewController *ac = [[AVCamViewController alloc] init];
   [self presentViewController:ac animated:NO completion:nil];
    
// [self startCameraControllerFromViewController: self usingDelegate: self];
}


// -------------------------------------------------------------------



-(BOOL)startCameraControllerFromViewController:(UIViewController*)controller
                                 usingDelegate:(id )delegate {
    if (([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera] == NO)) {
        return NO;
    }
    // 2 - Get image picker
    UIImagePickerController *cameraUI = [[UIImagePickerController alloc] init];
    cameraUI.sourceType = UIImagePickerControllerSourceTypeCamera;
    cameraUI.mediaTypes = [[NSArray alloc] initWithObjects:(NSString *)kUTTypeMovie, nil];
    
    cameraUI.hidesBottomBarWhenPushed = YES;
    cameraUI.cameraCaptureMode = UIImagePickerControllerCameraCaptureModeVideo;
    cameraUI.videoMaximumDuration = 6;
    cameraUI.allowsEditing = YES;
    cameraUI.delegate = delegate;
    
    [self presentModalViewController: cameraUI animated: YES];
    return YES;
}

-(void) playvideo
{
    self.playvid = YES;
    [self startMediaBrowserFromViewController:self usingDelegate:self];
}

-(BOOL)startMediaBrowserFromViewController:(UIViewController*)controller usingDelegate:(id )delegate {
    // 1 - Validations
    if (([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeSavedPhotosAlbum] == NO)
        || (delegate == nil)
        || (controller == nil)) {
        return NO;
    }
    // 2 - Get image picker
    UIImagePickerController *mediaUI = [[UIImagePickerController alloc] init];
    mediaUI.sourceType = UIImagePickerControllerSourceTypeSavedPhotosAlbum;
    mediaUI.mediaTypes = [[NSArray alloc] initWithObjects: (NSString *) kUTTypeMovie, nil];
    // Hides the controls for moving & scaling pictures, or for
    // trimming movies. To instead show the controls, use YES.
    mediaUI.allowsEditing = YES;
    mediaUI.delegate = delegate;
    // 3 - Display image picker
    [controller presentModalViewController:mediaUI animated:YES];
    return YES;
}


-(void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info {
    NSString *mediaType = [info objectForKey: UIImagePickerControllerMediaType];
    [self dismissModalViewControllerAnimated:NO];
    
    if (self.playvid == YES) {
        // Handle a movie capture
        if (CFStringCompare ((__bridge_retained CFStringRef)mediaType, kUTTypeMovie, 0) == kCFCompareEqualTo) {
            // 3 - Play the video
            MPMoviePlayerViewController *theMovie = [[MPMoviePlayerViewController alloc]
                                                     initWithContentURL:[info objectForKey:UIImagePickerControllerMediaURL]];
            theMovie.moviePlayer.repeatMode = MPMovieRepeatModeOne;
            [self presentMoviePlayerViewControllerAnimated:theMovie];
            // 4 - Register for the playback finished notification
//            [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(myMovieFinishedCallback:)
//                                                         name:MPMoviePlayerPlaybackDidFinishNotification object:theMovie];
        }
    } else {
        // Handle a movie capture
        if (CFStringCompare ((__bridge_retained CFStringRef) mediaType, kUTTypeMovie, 0) == kCFCompareEqualTo) {
            NSString *moviePath = [[info objectForKey:UIImagePickerControllerMediaURL] path];
            if (UIVideoAtPathIsCompatibleWithSavedPhotosAlbum(moviePath)) {
                UISaveVideoAtPathToSavedPhotosAlbum(moviePath, self,
                                                    @selector(video:didFinishSavingWithError:contextInfo:), nil);
            }
        }
    }
}

-(void)video:(NSString*)videoPath didFinishSavingWithError:(NSError*)error contextInfo:(void*)contextInfo {
    if (error) {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Error" message:@"Video Saving Failed"
                                                       delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
        [alert show];
    } else {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Video Saved" message:@"Saved To Photo Album"
                                                       delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil];
        [alert show];
    }
    [self playvideo];
}

@end
