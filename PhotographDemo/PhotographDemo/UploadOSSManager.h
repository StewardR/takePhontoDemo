//
//  UploadOSSManager.h
//  PhotographDemo
//
//  Created by Roy on 2019/6/20.
//  Copyright © 2019 stewardR. All rights reserved.
//

#import <Foundation/Foundation.h>

@class PicMesModel;

typedef void(^FinishUploadBlock)(BOOL uploadAll, NSMutableArray *waitUploadPicMuarr);

@interface UploadOSSManager : NSObject


+ (instancetype)sharedInstance;

/**
 上传照片函数

 @param picPathMuarr 存储上传后照片path
 @param picturePathPre the prename of picture
 @param deletedPicMuarr 被删除的图片路径
 @param pictureMes 图片数据模型
 @param finishBlock result after upload
 */
- (void)uploadPicToOssWithPicturePathMuarr:(NSMutableArray *)picPathMuarr
                            picturePathPre:(NSString *)picturePathPre
                            deletedPicMuarr:(NSMutableArray *)deletedPicMuarr
                            picMes:(PicMesModel *)pictureMes
                        uploadResult:(FinishUploadBlock)finishBlock;


@end

