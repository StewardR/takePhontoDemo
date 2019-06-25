//
//  ScanPicView.m
//  PhotographDemo
//
//  Created by Roy on 2019/6/11.
//  Copyright © 2019 stewardR. All rights reserved.
//

#import "ScanPicView.h"
#import "MaskView.h"

@interface ScanPicView ()
@property (nonatomic,strong) UIImageView *picImgView;
@property (nonatomic,strong) UIButton *confirmBtn;
@property (nonatomic,strong) UIButton *resetBtn;
@property (nonatomic,strong) MaskView *maskView;
@end

@implementation ScanPicView

- (MaskView *)maskView{
    if (!_maskView) {
        _maskView = [[MaskView alloc]init];
        _maskView.fillColor =[UIColor blackColor];
        _maskView.bezierPathY = 44;
        _maskView.opacityCount = 0.9;
    }
    return _maskView;
}


- (UIButton *)confirmBtn{
    if (!_confirmBtn) {
        _confirmBtn = [[UIButton alloc]initWithFrame:CGRectMake(0, 0, 44, 44)];
        [_confirmBtn setImage:[UIImage imageNamed:@"icon_photo_done"] forState:UIControlStateNormal];
        [_confirmBtn addTarget:self action:@selector(confirmBtnAction:) forControlEvents:UIControlEventTouchDown];
    }
    return _confirmBtn;
}

- (UIButton *)resetBtn{
    if (!_resetBtn) {
        _resetBtn = [[UIButton alloc]initWithFrame:CGRectMake(0, 0, 44, 44)];
        [_resetBtn setImage:[UIImage imageNamed:@"icon_picture_done copy"] forState:UIControlStateNormal];
        [_resetBtn addTarget:self action:@selector(resetBtnAction:) forControlEvents:UIControlEventTouchDown];
    }
    return _resetBtn;
}


- (UIImageView *)picImgView{
    if (!_picImgView) {
        _picImgView = [[UIImageView alloc]init];
        _picImgView.layer.cornerRadius = 20.f;
        _picImgView.layer.masksToBounds = YES;
    }
    return _picImgView;
}

- (instancetype)initWithPic:(UIImage *)displayImg{
    self = [super init];
    if (self) {
        self.picImgView.image = displayImg;
        [self addSubview:self.maskView];
        [self addSubview:self.resetBtn];
        [self addSubview:self.confirmBtn];
        [self addSubview:self.picImgView];
    }
    return self;
}

- (void)layoutSubviews{
    [super layoutSubviews];
    [self.picImgView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.mas_top).offset(44);
        make.bottom.equalTo(self.mas_bottom).offset(-41);
        make.left.equalTo(self.mas_left).offset(126);
        make.right.equalTo(self.mas_right).offset(-126);
    }];
    [self.maskView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.right.bottom.left.equalTo(self);
    }];
    
    [self.resetBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.height.equalTo(44);
        make.right.equalTo(self.mas_right).offset(-52);
        make.centerY.equalTo(self.mas_centerY).multipliedBy(0.6);
    }];
    
    [self.confirmBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.height.equalTo(44);
        make.right.equalTo(self.mas_right).offset(-52);
        make.centerY.equalTo(self.mas_centerY).multipliedBy(1.4);
    }];
}

#pragma mark -- btn action
- (void)cancelBtnAction:(UIButton *)sender{
    [self removeFromSuperview];
}

- (void)confirmBtnAction:(UIButton *)sender{
     [self removeFromSuperview];
}

- (void)resetBtnAction:(UIButton *)sender{
     [self removeFromSuperview];
    if (self.resetblock) {
        self.resetblock();
    }
}


@end
