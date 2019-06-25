//
//  MaskView.h
//  PhotographDemo
//
//  Created by WangLinbao on 2019/6/5.
//  Copyright © 2019 stewardR. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface MaskView : UIView   // 蒙层

@property (nonatomic,strong) UIColor *fillColor;
@property (nonatomic,assign) CGFloat bezierPathY;
@property (nonatomic,assign) float opacityCount;

@end

NS_ASSUME_NONNULL_END
