
//
//  UploadOSSManager.m
//  PhotographDemo
//
//  Created by Roy on 2019/6/20.
//  Copyright © 2019 stewardR. All rights reserved.
//

#import "UploadOSSManager.h"
#import "MyOssCilent.h"
#import "PicMesModel.h"

@interface UploadOSSManager ()
@property (nonatomic,strong) MyOssCilent *ossCilent;
@property (nonatomic,strong) dispatch_group_t uploadPhotoGroup; // 上传图片队列组
@property (nonatomic,strong) NSMutableArray *deletedPicMuarr; // 存储被删照片路径
@property (nonatomic,strong) NSMutableArray *picPathMuarr;

@end

@implementation UploadOSSManager


#pragma mark -- lazyload

- (dispatch_group_t)uploadPhotoGroup{
    if (!_uploadPhotoGroup) {
        _uploadPhotoGroup = dispatch_group_create();
    }
    return _uploadPhotoGroup;
}

- (MyOssCilent *)ossCilent{
    if (!_ossCilent) {
        _ossCilent = [MyOssCilent sharedInstance];
    }
    return _ossCilent;
}

#pragma mark -- ossCilent init
+ (instancetype)sharedInstance{
    static UploadOSSManager *instance;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        instance = [[UploadOSSManager alloc]init];
    });
    return instance;
}


- (void)uploadPicToOssWithPicturePathMuarr:(NSMutableArray *)picPathMuarr
                            picturePathPre:(NSString *)picturePathPre
                           deletedPicMuarr:(NSMutableArray *)deletedPicMuarr
                                    picMes:(PicMesModel *)pictureMes
                              uploadResult:(FinishUploadBlock)finishBlock{
    
    self.picPathMuarr = picPathMuarr;
    self.deletedPicMuarr = deletedPicMuarr;
    
    __weak typeof(self) weakSelf = self;
    dispatch_group_enter(self.uploadPhotoGroup);
    dispatch_group_async(self.uploadPhotoGroup, dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        OSSPutObjectRequest * put = [OSSPutObjectRequest new];
        put.bucketName = BUCKET_NAME;
        put.objectKey = pictureMes.ossPath;
        put.uploadingData = UIImageJPEGRepresentation(pictureMes.currentImage, 0.1); // 直接上传NSData
        put.uploadProgress = ^(int64_t bytesSent, int64_t totalByteSent, int64_t totalBytesExpectedToSend) {
            NSLog(@"当前线程：%@",[NSThread currentThread]);
            NSLog(@"%lld, %lld, %lld", bytesSent, totalByteSent, totalBytesExpectedToSend);
            if (pictureMes.deleted) { // 当前
                NSLog(@"退出");
                if (![weakSelf.deletedPicMuarr containsObject:pictureMes.ossPath]) {
                    [weakSelf.deletedPicMuarr addObject:pictureMes.ossPath];
                }
                
            }
        };
        
        OSSTask * putTask = [self.ossCilent putObject:put];
        [putTask continueWithBlock:^id(OSSTask *task) {
            if (!task.error) {
                if (![weakSelf.deletedPicMuarr containsObject:pictureMes.ossPath]) {
                    [weakSelf.picPathMuarr addObject:put.objectKey];
                }
                NSLog(@"%@,%@,%ld",@"upload object success!",put.objectKey,(long)weakSelf.picPathMuarr.count);
                dispatch_group_leave(weakSelf.uploadPhotoGroup);
            } else {
                NSLog(@"upload object failed, error: %@" , task.error);
                dispatch_group_leave(weakSelf.uploadPhotoGroup);
            }
            dispatch_group_wait(weakSelf.uploadPhotoGroup,DISPATCH_TIME_FOREVER);
            [weakSelf finishUploadAction:finishBlock];
            return nil;
        }];
        
    });
    
}


- (void)finishUploadAction:(FinishUploadBlock)finishBlock{
    __weak typeof(self) weakSelf = self;
    dispatch_group_notify(self.uploadPhotoGroup, dispatch_get_main_queue(), ^{
        
        NSLog(@"主线程：%ld",(long)weakSelf.picPathMuarr.count);
        if (weakSelf.picPathMuarr.count == 4) {
//            if (weakSelf.afterLoadCanGo) {   // 避免在网速不好的时候，上传完毕，此方法执行多次，待优化🚥🚦
//                [weakSelf performSelector:@selector(afterUploadFinish) withObject:nil afterDelay:0.5];
//                weakSelf.afterLoadCanGo = NO;
//            }else{
//                return;
//            }
            
            NSLog(@"success  ✅");
            NSLog(@"I will leave %@",weakSelf.picPathMuarr);
            finishBlock(YES,weakSelf.picPathMuarr);
        }else{
            finishBlock(NO,weakSelf.picPathMuarr);
        }
    });
    
}

#pragma mark -- get RandomNumber
- (int)getRandomNumber{
    int x = arc4random() % 100;
    return x;
}


@end
