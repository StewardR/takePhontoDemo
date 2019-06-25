//
//  PictureCustomCell.h
//  PhotographDemo
//
//  Created by Ray on 2019/5/23.
//  Copyright © 2019 stewardR. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface PictureCustomCell : UICollectionViewCell

/**
 cell update data

 @param placeholderiamge 占位图
 @param fillimage 填充图
 @param selectedstatus 选中状态
 @param canSelected 是否可点击
 @param name 图片名称
 */
- (void)updateCellMesWithPlaceHolderImage:(NSString *)placeholderiamge
                                fillImage:(UIImage *)fillimage
                           selectedStatus:(BOOL)selectedstatus
                              canSelected:(BOOL)canSelected
                              pictureName:(NSString *)name;

@end

NS_ASSUME_NONNULL_END
