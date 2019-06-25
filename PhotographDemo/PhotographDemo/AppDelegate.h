//
//  AppDelegate.h
//  PhotographDemo
//
//  Created by Ray on 2019/5/23.
//  Copyright © 2019 stewardR. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface AppDelegate : UIResponder <UIApplicationDelegate>

@property (strong, nonatomic) UIWindow *window;

/***  是否允许横屏的标记 */
@property (nonatomic,assign)BOOL allowRotation;
@end

