//
//  MaskView.m
//  PhotographDemo
//
//  Created by WangLinbao on 2019/6/5.
//  Copyright © 2019 stewardR. All rights reserved.
//

#import "MaskView.h"

@interface MaskView ()

@end

@implementation MaskView

- (instancetype)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self) {
        //设置 背景为clear
        self.backgroundColor = [UIColor clearColor];
        self.opaque = NO;
    }
    return self;
}

- (void)drawRect:(CGRect)rect {
    //中间镂空的矩形框
    CGRect myRect =CGRectMake(126,self.bezierPathY,self.bounds.size.width - 252, self.bounds.size.height - (41 + self.bezierPathY));
    //背景
    UIBezierPath *path = [UIBezierPath bezierPathWithRoundedRect:rect cornerRadius:0];
    //镂空
    UIBezierPath *circlePath = [UIBezierPath bezierPathWithRoundedRect:myRect cornerRadius:20];
    [path appendPath:circlePath];
    [path setUsesEvenOddFillRule:YES];
    CAShapeLayer *fillLayer = [CAShapeLayer layer];
    fillLayer.path = path.CGPath;
    fillLayer.fillRule = kCAFillRuleEvenOdd;
    fillLayer.fillColor = self.fillColor.CGColor;
    fillLayer.opacity = self.opacityCount;
    [self.layer addSublayer:fillLayer];
}


@end
