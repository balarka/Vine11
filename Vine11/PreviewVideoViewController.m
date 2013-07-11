//
//  PreviewVideoViewController.m
//  Vine11
//
//  Created by Balarka Velidi on 7/10/13.
//  Copyright (c) 2013 Balarka Velidi. All rights reserved.
//

#import "PreviewVideoViewController.h"
#import "GTLYouTube.h"
#import <MobileCoreServices/MobileCoreServices.h>

NSString *const kKeychainItemName = @"YouTubeSample: YouTube";

@interface PreviewVideoViewController ()<UIImagePickerControllerDelegate, UINavigationControllerDelegate>
@property (nonatomic, strong) UIButton *_cancel;
@property (nonatomic, strong) UIButton *_ok;
@property (nonatomic, strong) AVPlayer *avPlayer;
@property (nonatomic, readonly) GTLServiceYouTube *service;
@end

@implementation PreviewVideoViewController
GTLServiceTicket *_uploadFileTicket;
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

    [self._ok addTarget:self action:@selector(uploadVideo:) forControlEvents:UIControlEventTouchDown];
    
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

-(void) uploadVideo: (id) sender
{
    

    // Status.
    GTLYouTubeVideoStatus *status = [GTLYouTubeVideoStatus object];
    // status.privacyStatus = [_uploadPrivacyPopup titleOfSelectedItem];
    
    // Snippet.
    GTLYouTubeVideoSnippet *snippet = [GTLYouTubeVideoSnippet object];
    snippet.title = @"MY SAMPLE VIDEO";
    //    snippet.title = [_uploadTitleField stringValue];
    NSString *desc = @"test video..";
    if ([desc length] > 0) {
        snippet.descriptionProperty = desc;
    }
    NSString *tagsStr = @"my tags"; //[_uploadTagsField stringValue];
    if ([tagsStr length] > 0) {
        snippet.tags = [tagsStr componentsSeparatedByString:@","];
    }
    //    if ([_uploadCategoryPopup isEnabled]) {
    //        NSMenuItem *selectedCategory = [_uploadCategoryPopup selectedItem];
    //        snippet.categoryId = [selectedCategory representedObject];
    //    }
    
    GTLYouTubeVideo *video = [GTLYouTubeVideo object];
    video.status = status;
    video.snippet = snippet;
    
    [self uploadVideoWithVideoObject:video resumeUploadLocationURL:nil];
}

- (void)uploadVideoWithVideoObject:(GTLYouTubeVideo *)video
           resumeUploadLocationURL:(NSURL *)locationURL {
    
    NSString *path              = [[NSBundle bundleForClass:[self class]] pathForResource:@"sample" ofType:@"mov"];
    NSFileHandle *handle        = [NSFileHandle fileHandleForReadingAtPath:path];
    
    NSLog(@"%@", path);
    
    if (handle) {

        GTLServiceYouTube *service      = [[GTLServiceYouTube alloc] init];
        service.authorizer = 
        
        GTMOAuth2Authentication *auth = [GTMOAuth2WindowController authForGoogleFromKeychainForName:kKeychainItemName
                                                           clientID:clientID
                                                       clientSecret:clientSecret];
        
        service.authorizer              = auth;
        
        GTLUploadParameters *params     = [GTLUploadParameters uploadParametersWithFileHandle:handle MIMEType:@"application/octet-stream"];
        
        GTLYouTubeVideoSnippet *snippet = [GTLYouTubeVideoSnippet object];
        snippet.title                   = @"Test title";
        snippet.descriptionProperty     = @"Test description";
        snippet.tags                    = @[ @"TestOne", @"TestTwo" ];
        snippet.categoryId              = @"17";
        
        GTLYouTubeVideoStatus *status   = [GTLYouTubeVideoStatus object];
        status.privacyStatus            = @"private";
        
        GTLYouTubeVideo *video          = [GTLYouTubeVideo object];
        video.snippet                   = snippet;
        video.status                    = status;
        
        
        
        
        
        
        
        
        
        
        
        
        
        
        
        NSString *mimeType = [self MIMETypeForFilename:filename
                                       defaultMIMEType:@"video/mp4"];
        GTLUploadParameters *uploadParameters =
        [GTLUploadParameters uploadParametersWithFileHandle:fileHandle
                                                   MIMEType:mimeType];
        uploadParameters.uploadLocationURL = locationURL;
        
        GTLQueryYouTube *query = [GTLQueryYouTube queryForVideosInsertWithObject:video
                                                                            part:@"snippet,status"
                                                                uploadParameters:uploadParameters];
        
//        GTLServiceYouTube *service = self.youTubeService;
        _uploadFileTicket = [_service executeQuery:query
                                completionHandler:^(GTLServiceTicket *ticket,
                                                    GTLYouTubeVideo *uploadedVideo,
                                                    NSError *error) {
                                    // Callback
                                    _uploadFileTicket = nil;
                                    if (error == nil) {
                                        NSLog(@"Uploaded file");
                                    } else {
                                        NSLog(@"Upload failed: %@", error);
                                    }
                                }];
        
    } else {
        // Could not read file data.
        NSLog(@"File Not Found %@",path);
    }
}

- (NSString *)MIMETypeForFilename:(NSString *)filename
                  defaultMIMEType:(NSString *)defaultType {
    NSString *result = defaultType;
    NSString *extension = [filename pathExtension];
    CFStringRef uti = UTTypeCreatePreferredIdentifierForTag(kUTTagClassFilenameExtension,
                                                            (__bridge CFStringRef)extension, NULL);
    if (uti) {
        CFStringRef cfMIMEType = UTTypeCopyPreferredTagWithClass(uti, kUTTagClassMIMEType);
        if (cfMIMEType) {
            result = CFBridgingRelease(cfMIMEType);
        }
        CFRelease(uti);
    }
    return result;
}

- (GTLServiceYouTube *)youTubeService {
    static GTLServiceYouTube *service;
    
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _service = [[GTLServiceYouTube alloc] init];
        [_service setRetryEnabled:YES];
        [_service setAPIKey:@"AIzaSyB204xfNGYd4SxOELP3ynH2ZhBFB6EVtxg"];
        
        // Have the service object set tickets to fetch consecutive pages
        // of the feed so we do not need to manually fetch them.
        _service.shouldFetchNextPages = YES;
        
        // Have the service object set tickets to retry temporary error conditions
        // automatically.
    });
    return service;
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
