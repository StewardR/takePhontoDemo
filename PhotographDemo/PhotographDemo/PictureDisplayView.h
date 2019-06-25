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

@interface PictureDisplayView : UIView

@property (nonatomic,strong) NSMutableArray<PicMesModel*> *picMesArr; // 图片相关信息
@property (nonatomic,assign) UICollectionViewScrollDirection scrollDirection; // 方向
@property (nonatomic,copy) CellSelectedBlock selectedBlock;

- (void)reloadPic;// 刷新显示图片

@end

NS_ASSUME_NONNULL_END
