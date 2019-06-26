//
//  PictureDisplayView.h
//  PhotographDemo
//
//  Created by Ray on 2019/5/23.
//  Copyright © 2019 stewardR. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN
@class PicMesModel;

typedef void(^CellSelectedBlock)(NSIndexPath *indexPath,UIImage *contentImg);

typedef enum : NSUInteger {
    TakePhotoType_BeforeUseCar = 0, // 用车前
    TakePhotoType_Damage, // 验伤
    TakePhotoType_Interior, // 内饰
    TakePhotoType_ReturnCar, // 还车
}TakePhotoType;

@interface PictureDisplayView : UIView

@property (nonatomic,strong) NSMutableArray<PicMesModel*> *picMesArr; // 图片相关信息
@property (nonatomic,assign) UICollectionViewScrollDirection scrollDirection; // 方向
@property (nonatomic,copy) CellSelectedBlock selectedBlock;
@property (nonatomic,assign) TakePhotoType takephotoType;


- (void)reloadPic;// 刷新显示图片

@end

NS_ASSUME_NONNULL_END
