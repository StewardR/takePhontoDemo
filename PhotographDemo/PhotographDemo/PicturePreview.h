//
//  PicturePreview.h
//  PhotographDemo
//
//  Created by WangLinbao on 2019/5/27.
//  Copyright © 2019 stewardR. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

typedef void(^TakePhotoBlock)(UIImage * photo);

@interface PicturePreview : UIView

- (instancetype)initWithPhotoMode;
- (void)touchFlash; // 开关闪光灯
- (void)takePhoto; // 拍照
- (void)stop;
- (void)start;
@property (nonatomic,copy) TakePhotoBlock takePhotoBlock;

@end

NS_ASSUME_NONNULL_END
