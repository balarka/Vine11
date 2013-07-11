//
//  RecordVideoViewController.m
//  Vine11
//
//  Created by Balarka Velidi on 7/9/13.
//  Copyright (c) 2013 Balarka Velidi. All rights reserved.
//

#import "RecordVideoViewController.h"
#import <AssetsLibrary/AssetsLibrary.h>
#import <MobileCoreServices/MobileCoreServices.h>

@interface RecordVideoViewController ()<UIImagePickerControllerDelegate, UINavigationControllerDelegate>

@end

@implementation RecordVideoViewController
 

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
	// Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void) loadView
{
    NSLog(@"in here..");
    
    // 2 - Get image picker
    UIImagePickerController *cameraUI = [[UIImagePickerController alloc] init];
    cameraUI.sourceType = UIImagePickerControllerSourceTypeCamera;
    
    cameraUI.allowsEditing = NO;
    cameraUI.delegate = self;
    
    self.view = cameraUI;
    
//    [self presentModalViewController: cameraUI animated: YES];
//    [self startCameraControllerFromViewController: self usingDelegate: self];
}

-(void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info
{
 
    [self dismissModalViewControllerAnimated:YES];
}

-(BOOL)startCameraControllerFromViewController:(UIViewController*)controller
                                 usingDelegate:(id )delegate {
    if (([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera] == NO)) {
        return NO;
    }
    // 2 - Get image picker
    UIImagePickerController *cameraUI = [[UIImagePickerController alloc] init];
    cameraUI.sourceType = UIImagePickerControllerSourceTypeCamera;
    
    cameraUI.allowsEditing = NO;
    cameraUI.delegate = self;
    
    [self presentModalViewController: cameraUI animated: YES];
    return YES;
}

@end
