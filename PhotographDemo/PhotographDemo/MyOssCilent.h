//
//  MyOssCilent.h
//  PhotographDemo
//
//  Created by Roy on 2019/6/19.
//  Copyright © 2019 stewardR. All rights reserved.
//

#import "OSSClient.h"

NS_ASSUME_NONNULL_BEGIN

@interface MyOssCilent : OSSClient
+ (instancetype)sharedInstance;
@end

NS_ASSUME_NONNULL_END
