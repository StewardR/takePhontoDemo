//
//  DamagePicCell.h
//  PhotographDemo
//
//  Created by Roy on 2019/6/26.
//  Copyright © 2019 stewardR. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface DamagePicCell : UICollectionViewCell

- (void)updateCellMesWithPlaceHolderImage:(NSString *)placeholderiamge
                                fillImage:(UIImage *)fillimage
                           selectedStatus:(BOOL)selectedstatus
                              canSelected:(BOOL)canSelected
                              pictureName:(NSString *)name;

@end


