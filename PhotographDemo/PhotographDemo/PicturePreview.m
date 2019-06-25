//
//  PicturePreview.m
//  PhotographDemo
//
//  Created by WangLinbao on 2019/5/27.
//  Copyright © 2019 stewardR. All rights reserved.
//

#import "PicturePreview.h"
#import <AVFoundation/AVFoundation.h>
#import <Masonry.h>

@interface PicturePreview ()<AVCapturePhotoCaptureDelegate>
//捕获设备，通常是前置摄像头，后置摄像头，麦克风（音频输入）
@property (nonatomic, strong) AVCaptureDevice *device;

//AVCaptureDeviceInput 代表输入设备，他使用AVCaptureDevice 来初始化
@property (nonatomic, strong) AVCaptureDeviceInput *backCameraInput;

//输出图片
@property (nonatomic ,strong) AVCapturePhotoOutput *imageOutput;

//session：由他把输入输出结合在一起，并开始启动捕获设备（摄像头）
@property (nonatomic, strong) AVCaptureSession *recordSession;

//图像预览层，实时显示捕获的图像
@property (nonatomic ,strong) AVCaptureVideoPreviewLayer *previewLayer;

@property (nonatomic,strong) AVCaptureConnection *captureConnection;
@end

@implementation PicturePreview

#pragma mark -- lazyload


- (AVCaptureConnection *)captureConnection{
    if (!_captureConnection) {
        _captureConnection = [self.imageOutput connectionWithMediaType:AVMediaTypeVideo];
        if ([_captureConnection isVideoOrientationSupported]) {
            _captureConnection.videoOrientation = [self getCaptureVideoOrientation];
        }
    }
    return _captureConnection;
}

- (AVCaptureDevice *)device{
    if (!_device) {
        _device = [AVCaptureDevice defaultDeviceWithMediaType:AVMediaTypeVideo];
    }
    return _device;
}

- (AVCaptureSession *)recordSession{
    if (!_recordSession) {
        _recordSession = [[AVCaptureSession alloc]init];
        if ([_recordSession canAddInput:self.backCameraInput]) {
            [_recordSession addInput:self.backCameraInput];
        }
        
        if ([_recordSession canAddOutput:self.imageOutput]) {
            [_recordSession addOutput:self.imageOutput];
        }
    }
    return _recordSession;
}

- (AVCaptureDeviceInput *)backCameraInput{
    if (!_backCameraInput) {
        NSError * error;
        _backCameraInput = [[AVCaptureDeviceInput alloc]initWithDevice:self.device error:&error];
    }
    return _backCameraInput;
}

- (AVCapturePhotoOutput *)imageOutput{
    if (!_imageOutput) {
        _imageOutput = [[AVCapturePhotoOutput alloc]init];
        NSDictionary *setDic = @{AVVideoCodecKey:AVVideoCodecTypeJPEG};
        AVCapturePhotoSettings *outputSettings = [AVCapturePhotoSettings photoSettingsWithFormat:setDic];
        [_imageOutput setPhotoSettingsForSceneMonitoring:outputSettings];
    }
    return _imageOutput;
}

- (AVCaptureVideoPreviewLayer *)previewLayer{
    if (!_previewLayer) {
        _previewLayer = [[AVCaptureVideoPreviewLayer alloc]initWithSession:self.recordSession];
        self.previewLayer.videoGravity = AVLayerVideoGravityResizeAspectFill;
    }
    return _previewLayer;
}

- (instancetype)initWithPhotoMode{
    if (self = [super init]) {
        [self.recordSession setSessionPreset:AVCaptureSessionPresetPhoto];
        [self setupCapture];
    }
    return self;
}

- (void)setupCapture{
    
    [self.layer addSublayer:self.previewLayer];
     AVCaptureConnection *previewLayerConnection = self.previewLayer.connection;
    if ([previewLayerConnection isVideoOrientationSupported]){
        previewLayerConnection.videoOrientation = [self getCaptureVideoOrientation];
    }
    [self.recordSession startRunning];
}


- (void)touchFlash{
    if (self.device.torchMode == AVCaptureTorchModeOff) {
        [self.device lockForConfiguration:nil];
        self.device.torchMode = AVCaptureTorchModeOn;
        [self.device unlockForConfiguration];
    }else{
        [self.device lockForConfiguration:nil];
        self.device.torchMode = AVCaptureTorchModeOff;
        [self.device unlockForConfiguration];
    }
}

- (void)takePhoto{
    // 拍照
    if (@available(iOS 11.0, *)) {
        NSDictionary *setDic = @{AVVideoCodecKey:AVVideoCodecTypeJPEG};
        AVCapturePhotoSettings *outputSettings = [AVCapturePhotoSettings photoSettingsWithFormat:setDic];
         [self.imageOutput capturePhotoWithSettings:outputSettings delegate:self];
    } else {
        // Fallback on earlier versions
    }
}

- (void)captureOutput:(AVCapturePhotoOutput *)captureOutput didFinishProcessingPhotoSampleBuffer:(nullable CMSampleBufferRef)photoSampleBuffer previewPhotoSampleBuffer:(nullable CMSampleBufferRef)previewPhotoSampleBuffer resolvedSettings:(nonnull AVCaptureResolvedPhotoSettings *)resolvedSettings bracketSettings:(nullable AVCaptureBracketedStillImageSettings *)bracketSettings error:(nullable NSError *)error{
    NSData *data = [AVCapturePhotoOutput JPEGPhotoDataRepresentationForJPEGSampleBuffer:photoSampleBuffer previewPhotoSampleBuffer:previewPhotoSampleBuffer];
    UIImage *image = [UIImage imageWithData:data];

    if (self.takePhotoBlock) {
        self.takePhotoBlock(image);
    }

}

- (void)captureOutput:(AVCapturePhotoOutput *)output
didFinishProcessingPhoto:(AVCapturePhoto *)photo
                error:(NSError *)error API_AVAILABLE(ios(11.0)){
    NSData * imgedata = photo.fileDataRepresentation;
    UIImage *image = [UIImage imageWithData:imgedata];
    
    if (self.takePhotoBlock) {
        self.takePhotoBlock(image);
    }
}


- (AVCaptureVideoOrientation)getCaptureVideoOrientation {
    AVCaptureVideoOrientation result;
    
    UIDeviceOrientation deviceOrientation = [UIDevice currentDevice].orientation;
    switch (deviceOrientation) {
        case UIDeviceOrientationPortrait:
        case UIDeviceOrientationFaceUp:
        case UIDeviceOrientationFaceDown:
            result = AVCaptureVideoOrientationPortrait;
            break;
        case UIDeviceOrientationPortraitUpsideDown:
            //如果这里设置成AVCaptureVideoOrientationPortraitUpsideDown，则视频方向和拍摄时的方向是相反的。
            result = AVCaptureVideoOrientationPortrait;
            break;
        case UIDeviceOrientationLandscapeLeft:
            result = AVCaptureVideoOrientationLandscapeRight;
            break;
        case UIDeviceOrientationLandscapeRight:
            result = AVCaptureVideoOrientationLandscapeLeft;
            break;
        default:
            result = AVCaptureVideoOrientationPortrait;
            break;
    }
    
    return result;
}


#pragma mark -- layout
- (void)layoutSubviews{
    [super layoutSubviews];
    self.previewLayer.frame = CGRectMake(0, 0, CGRectGetWidth(self.bounds), CGRectGetHeight(self.bounds));
}


- (void)stop{
    [self.recordSession stopRunning];
}

- (void)start{
    [self.recordSession startRunning];
}

@end
