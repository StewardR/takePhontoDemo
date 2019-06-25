//
//  ScanPicView.h
//  PhotographDemo
//
//  Created by Roy on 2019/6/11.
//  Copyright © 2019 stewardR. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void(^ResetPicBlock)(void);

@interface ScanPicView : UIView

@property (nonatomic,copy) ResetPicBlock resetblock;


- (instancetype)initWithPic:(UIImage *)displayImg;

@end

