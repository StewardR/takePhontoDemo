//
//  MyOssCilent.m
//  PhotographDemo
//
//  Created by Roy on 2019/6/19.
//  Copyright © 2019 stewardR. All rights reserved.
//

#import "MyOssCilent.h"

@implementation MyOssCilent
+ (instancetype)sharedInstance{
    static MyOssCilent *instance;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        instance = [self initClient];
    });
    return instance;
}

+ (MyOssCilent *)initClient{
    
    id<OSSCredentialProvider> credentialProvider = [[OSSAuthCredentialProvider alloc] initWithAuthServerUrl:OSS_STSTOKEN_URL];
    OSSClientConfiguration *cfg = [[OSSClientConfiguration alloc] init];
    
    cfg.maxRetryCount = 3;
    cfg.timeoutIntervalForRequest = 15;
    cfg.isHttpdnsEnable = NO;
    cfg.crc64Verifiable = YES;
    
    MyOssCilent *defaultImgClient = [[MyOssCilent alloc] initWithEndpoint:ENDPOINT credentialProvider:credentialProvider clientConfiguration:cfg];
    
    return defaultImgClient;
}
@end
