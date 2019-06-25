//
//  PicMesModel.h
//  PhotographDemo
//
//  Created by Ray on 2019/5/23.
//  Copyright © 2019 stewardR. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface PicMesModel : NSObject

@property (nonatomic,assign) BOOL canSelected; // 是否可点击
@property (nonatomic,strong) UIImage * currentImage; // 填充的图片
@property (nonatomic,copy) NSString * placeholderImage; // 占位图片
@property (nonatomic,assign) BOOL selectedStatus; // 选中状态
@property (nonatomic,copy) NSString *picName; // 图片名字
@property (nonatomic,assign) BOOL deleted; // 是否被删除，重拍的时候删除
@property (nonatomic,copy) NSString *ossPath; // 上传之后oss路径

@end

NS_ASSUME_NONNULL_END
