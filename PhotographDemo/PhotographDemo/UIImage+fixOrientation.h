//
//  UIImage+fixOrientation.h
//  PhotographDemo
//
//  Created by Roy on 2019/6/6.
//  Copyright © 2019 stewardR. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface UIImage (fixOrientation)
- (UIImage *)fixOrientation;
- (UIImage *)normalizedImage;
+ (UIImage *)image:(UIImage *)image rotation:(UIImageOrientation)orientation; // 图片旋转
@end

NS_ASSUME_NONNULL_END
