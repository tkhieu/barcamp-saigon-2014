//
//  TCQRCodeViewController.m
//  TechCamp
//
//  Created by Tran Tu Duong on 11/12/14.
//  Copyright (c) 2014 TechCamp. All rights reserved.
//

#import "TCQRCodeViewController.h"
#import "GPUImage.h"
#import "SMKDetectionCamera.h"
#import "GPUImageGammaFilter.h"
#import "BCTopicClient.h"

@interface TCQRCodeViewController ()

@property (weak) IBOutlet GPUImageView *cameraView;

@property SMKDetectionCamera * detector;

@property (assign, nonatomic) BOOL showFeatureTrackingView;
@property (assign, nonatomic) BOOL showMetadataTrackingView;

@property (strong, nonatomic) UIView * faceFeatureTrackingView;
@property (strong, nonatomic) UIView * faceMetadataTrackingView;

@property (assign, nonatomic) CGAffineTransform cameraOutputToPreviewFrameTransform;
@property (assign, nonatomic) CGAffineTransform portraitRotationTransform;
@property (assign, nonatomic) CGAffineTransform texelToPixelTransform;

@property (nonatomic) BOOL isScanned;

@end

@implementation TCQRCodeViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    switch (self.status) {
        case StatusQRCodeLogin:
            self.title = @"Login";
            break;
            
        case StatusQRCodeVote:
            self.title = @"Vote";
            break;
        
        case StatusQRCodeAnswer:
            self.title = @"Answer";
            break;
            
        default:
            break;
    }
    
    self.detector = [[SMKDetectionCamera alloc] initWithSessionPreset:AVCaptureSessionPreset640x480 cameraPosition:AVCaptureDevicePositionBack];
    [self.detector setOutputImageOrientation:UIInterfaceOrientationPortrait];
    [self.detector addTarget:self.cameraView];
    self.cameraView.fillMode = kGPUImageFillModePreserveAspectRatio;
    
    [self setupFaceTrackingViews];
    [self calculateTransformations];
    
    self.showFeatureTrackingView = YES;
    self.showMetadataTrackingView = YES;
    
    [self.detector beginDetecting:kFaceFeatures | kMachineAndFaceMetaData
                        codeTypes:@[AVMetadataObjectTypeQRCode]
               withDetectionBlock:^(SMKDetectionOptions detectionType, NSArray *detectedObjects, CGRect clapOrRectZero) {
                   if (detectedObjects.count) {
                       NSObject *codeObj = detectedObjects[0];
                       if ([codeObj isKindOfClass:[AVMetadataMachineReadableCodeObject class]]) {
                           
                           NSString *QRCode = [((AVMetadataMachineReadableCodeObject *)codeObj) stringValue];
                           
                           if (QRCode.length > 0 && !self.isScanned) {
                               self.isScanned = YES;
                               [self sendQRCode:QRCode];
                               return;
                           }
                       }
                   }
                   
                   if (detectionType & kFaceFeatures) {
                       [self updateFaceFeatureTrackingViewWithObjects:detectedObjects];
                   }
                   else if (detectionType | kFaceMetaData) {
                       [self updateFaceMetadataTrackingViewWithObjects:detectedObjects];
                   }
               }];
    
    [self.detector startCameraCapture];
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    [SVProgressHUD dismiss];
}

- (void)sendQRCode:(NSString *)QRCode
{
    BCTopicClient *client = [[BCTopicClient alloc] init];
    
    switch (self.status) {
        case StatusQRCodeLogin:
        {
            [SVProgressHUD showWithStatus:@"Voting..."];
            [client loginWithQRCode:QRCode block:^(NSArray *objects, NSError *error) {
                if (objects && !error) {
                    [NSDEF setObject:objects forKey:kUserLoggedIn];
                    
                    [client voteWithTopicID:self.topicId QRCode:QRCode block:^(id object, NSError *error) {
                        if (object && !error) {
                            [SVProgressHUD showSuccessWithStatus:@"Vote success"];
                        }
                        else {
                            [SVProgressHUD showErrorWithStatus:@"You have voted this presentation!"];
                        }
                        
                        [self.navigationController popViewControllerAnimated:YES];
                    }];
                }
                else {
                    [SVProgressHUD showErrorWithStatus:@"QRCode does not exist"];
                }
                
            }];
        }
            break;
        
        case StatusQRCodeVote:
        {
            [SVProgressHUD showWithStatus:@"Voting..."];
            [client voteWithTopicID:self.topicId QRCode:QRCode block:^(id object, NSError *error) {
                if (object && !error) {
                    NSString *success = [object valueForKeyPath:@"status"];
                    if ([success isEqualToString:@"success"]) {
                        [SVProgressHUD showSuccessWithStatus:@"Vote success"];
                    }
                }
                else {
                    [SVProgressHUD showErrorWithStatus:@"You have voted this presentation!"];
                }
                
                [self.navigationController popViewControllerAnimated:YES];
            }];
        }
            break;
            
        case StatusQRCodeAnswer:
        {
            [SVProgressHUD showWithStatus:@"Submitting.."];
            [client answer:self.topicId QRCode:QRCode answerId:self.answerId block:^(id object, NSError *error) {
                if (object && !error) {
                    NSString *success = [object valueForKeyPath:@"content"];
                    if (success) {
                        [SVProgressHUD showSuccessWithStatus:[object valueForKeyPath:@"content"]];
                        [self.navigationController popViewControllerAnimated:NO];
                    }
                }
                else {
                    [SVProgressHUD showErrorWithStatus:@"Submit failed!"];
                }
                
                [self.navigationController popViewControllerAnimated:YES];
            }];
        }
            break;

        default:
            break;
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)updateFaceFeatureTrackingViewWithObjects:(NSArray *)objects
{
    if (!objects.count || !self.showFeatureTrackingView) {
        self.faceFeatureTrackingView.hidden = YES;
    }
    else {
        CIFaceFeature * feature = objects[0];
        CGRect face = feature.bounds;
        
        face = CGRectApplyAffineTransform(face, self.portraitRotationTransform);
        face = CGRectApplyAffineTransform(face, self.cameraOutputToPreviewFrameTransform);
        self.faceFeatureTrackingView.frame = face;
        self.faceFeatureTrackingView.hidden = NO;
    }
}

- (void)updateFaceMetadataTrackingViewWithObjects:(NSArray *)objects
{
    if (!objects.count || !self.showMetadataTrackingView) {
        self.faceMetadataTrackingView.hidden = YES;
    }
    else {
        AVMetadataFaceObject * metadataObject = objects[0];
        
        CGRect face = metadataObject.bounds;
        
        // Flip the Y coordinate to compensate for coordinate difference
        face.origin.y = 1.0 - face.origin.y - face.size.height;
        
        // Transform to go from texels, which are relative to the image size to pixel values
        face = CGRectApplyAffineTransform(face, self.portraitRotationTransform);
        face = CGRectApplyAffineTransform(face, self.texelToPixelTransform);
        face = CGRectApplyAffineTransform(face, self.cameraOutputToPreviewFrameTransform);
        self.faceMetadataTrackingView.frame = face;
        self.faceMetadataTrackingView.hidden = NO;
    }
}

- (void)setupFaceTrackingViews
{
    self.faceFeatureTrackingView = [[UIView alloc] initWithFrame:CGRectZero];
    self.faceFeatureTrackingView.layer.borderColor = [[UIColor redColor] CGColor];
    self.faceFeatureTrackingView.layer.borderWidth = 3;
    self.faceFeatureTrackingView.backgroundColor = [UIColor clearColor];
    self.faceFeatureTrackingView.hidden = YES;
    self.faceFeatureTrackingView.userInteractionEnabled = NO;
    
    self.faceMetadataTrackingView = [[UIView alloc] initWithFrame:CGRectZero];
    self.faceMetadataTrackingView.layer.borderColor = [[UIColor greenColor] CGColor];
    self.faceMetadataTrackingView.layer.borderWidth = 3;
    self.faceMetadataTrackingView.backgroundColor = [UIColor clearColor];
    self.faceMetadataTrackingView.hidden = YES;
    self.faceMetadataTrackingView.userInteractionEnabled = NO;
    
    [self.view addSubview:self.faceMetadataTrackingView];
    [self.view addSubview:self.faceFeatureTrackingView];
}

- (void)calculateTransformations
{
    NSInteger outputHeight = [[self.detector.captureSession.outputs[0] videoSettings][@"Height"] integerValue];
    NSInteger outputWidth = [[self.detector.captureSession.outputs[0] videoSettings][@"Width"] integerValue];
    
    if (UIInterfaceOrientationIsPortrait(self.detector.outputImageOrientation)) {
        // Portrait mode, swap width & height
        NSInteger temp = outputWidth;
        outputWidth = outputHeight;
        outputHeight = temp;
    }
    
    // Use self.view because self.cameraView is not resized at this point (if 3.5" device)
    CGFloat viewHeight = self.view.frame.size.height;
    CGFloat viewWidth = self.view.frame.size.width;
    
    // Calculate the scale and offset of the view vs the camera output
    // This depends on the fillmode of the GPUImageView
    CGFloat scale;
    CGAffineTransform frameTransform;
    switch (self.cameraView.fillMode) {
        case kGPUImageFillModePreserveAspectRatio:
            scale = MIN(viewWidth / outputWidth, viewHeight / outputHeight);
            frameTransform = CGAffineTransformMakeScale(scale, scale);
            frameTransform = CGAffineTransformTranslate(frameTransform, -(outputWidth * scale - viewWidth)/2, -(outputHeight * scale - viewHeight)/2 );
            break;
        case kGPUImageFillModePreserveAspectRatioAndFill:
            scale = MAX(viewWidth / outputWidth, viewHeight / outputHeight);
            frameTransform = CGAffineTransformMakeScale(scale, scale);
            frameTransform = CGAffineTransformTranslate(frameTransform, -(outputWidth * scale - viewWidth)/2, -(outputHeight * scale - viewHeight)/2 );
            break;
        case kGPUImageFillModeStretch:
            frameTransform = CGAffineTransformMakeScale(viewWidth / outputWidth, viewHeight / outputHeight);
            break;
    }
    self.cameraOutputToPreviewFrameTransform = frameTransform;
    
    // In portrait mode, need to swap x & y coordinates of the returned boxes
    if (UIInterfaceOrientationIsPortrait(self.detector.outputImageOrientation)) {
        // Interchange x & y
        self.portraitRotationTransform = CGAffineTransformMake(0, 1, 1, 0, 0, 0);
    }
    else {
        self.portraitRotationTransform = CGAffineTransformIdentity;
    }
    
    // AVMetaDataOutput works in texels (relative to the image size)
    // We need to transform this to pixels through simple scaling
    self.texelToPixelTransform = CGAffineTransformMakeScale(outputWidth, outputHeight);
    
}

@end
