//
//  ViewController.m
//  PhotographDemo
//
//  Created by Ray on 2019/5/23.
//  Copyright © 2019 stewardR. All rights reserved.
//

#import "ViewController.h"
#import "PictureDisplayView.h"
#import "PicMesModel.h"
#import "PicturePreview.h"
#import <AVFoundation/AVFoundation.h>
#import <UIImage+WebP.h>
#import "TakephotoController.h"
#import "AppDelegate.h"


static int picNum = 4;

@interface ViewController ()
@property (nonatomic,strong) NSMutableArray *picMuarr;
@property (nonatomic,strong) UIButton * photoBtn;
@property (nonatomic,strong) UIButton *flashBtn;
@property (nonatomic,strong) PicturePreview *picPreview;
@property (nonatomic,strong) PictureDisplayView *picDisplayView;
@property (nonatomic,assign) int currentPicPage; // 当前选中的照片


@property (nonatomic,strong) UIButton * jumpBtn; // 跳转按钮
@end

@implementation ViewController

#pragma mark -- lazyload

- (UIButton *)jumpBtn{
    if (!_jumpBtn) {
        _jumpBtn = [[UIButton alloc]initWithFrame:CGRectMake(0, 0, 100, 50)];
        _jumpBtn.backgroundColor = [UIColor cyanColor];
        _jumpBtn.layer.cornerRadius = 25;
        [_jumpBtn setTitle:@"Jump" forState:UIControlStateNormal];
        [_jumpBtn setTitleColor:[UIColor redColor] forState:UIControlStateNormal];
        [_jumpBtn addTarget:self action:@selector(jumpAction:) forControlEvents:UIControlEventTouchDown];
    }
    return _jumpBtn;
}

- (PictureDisplayView *)picDisplayView{
    if (!_picDisplayView) {
        _picDisplayView = [[PictureDisplayView alloc]init];
    }
    return _picDisplayView;
}

- (PicturePreview *)picPreview{
    if (!_picPreview) {
        _picPreview = [[PicturePreview alloc]init];
        __weak typeof(self) weakSelf = self;
        _picPreview.takePhotoBlock = ^(UIImage * _Nonnull photo) {
            if (photo) {
                PicMesModel * mesmodel = [weakSelf.picMuarr objectAtIndex:weakSelf.currentPicPage];
                mesmodel.currentImage = photo;
                mesmodel.canSelected = YES;
                if (weakSelf.currentPicPage == weakSelf.picMuarr.count -1) {
                    weakSelf.currentPicPage = 0;
                }else{
                    weakSelf.currentPicPage++;
                }
            }
            
            [weakSelf.picMuarr enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
                PicMesModel * mesmodel = obj;
                if (idx == weakSelf.currentPicPage) {
                    mesmodel.selectedStatus = YES;
                }else{
                    mesmodel.selectedStatus = NO;
                }
            }];
            
            [weakSelf.picDisplayView reloadPic];
            
        };
    }
    return _picPreview;
}

- (UIButton *)photoBtn{
    if (!_photoBtn) {
        _photoBtn = [[UIButton alloc]initWithFrame:CGRectMake(0, 0, 50, 50)];
        _photoBtn.backgroundColor = [UIColor cyanColor];
        _photoBtn.layer.cornerRadius = 25;
        [_photoBtn setTitle:@"拍照" forState:UIControlStateNormal];
        [_photoBtn setTitleColor:[UIColor redColor] forState:UIControlStateNormal];
        [_photoBtn addTarget:self action:@selector(takePhoto:) forControlEvents:UIControlEventTouchDown];
    }
    return _photoBtn;
}

- (UIButton *)flashBtn{
    if (!_flashBtn) {
        _flashBtn = [[UIButton alloc]initWithFrame:CGRectMake(0, 0, 50, 50)];
        _flashBtn.backgroundColor = [UIColor cyanColor];
        _flashBtn.layer.cornerRadius = 25;
        [_flashBtn setTitle:@"闪光灯" forState:UIControlStateNormal];
        _flashBtn.titleLabel.font = [UIFont systemFontOfSize:12];
        [_flashBtn setTitleColor:[UIColor redColor] forState:UIControlStateNormal];
        [_flashBtn addTarget:self action:@selector(turnOnAndOffFlash:) forControlEvents:UIControlEventTouchDown];
    }
    return _flashBtn;
}

- (NSMutableArray *)picMuarr{
    if (!_picMuarr) {
        _picMuarr = [[NSMutableArray alloc]init];
    }
    return _picMuarr;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.currentPicPage = 0;
    self.title = @"拍照demo";
    self.view.backgroundColor = [UIColor whiteColor];
    
    [self.view addSubview:self.jumpBtn];
    [self.jumpBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.equalTo(100);
        make.height.equalTo(50);
        make.centerX.equalTo(self.view.mas_centerX);
        make.centerY.equalTo(self.view.mas_centerY);
    }];
    
    
//    [self createData];
//    [self addSubView];
}

#pragma mark -- setData

- (void)createData{
    
    NSArray * picNameArr = @[@"正面",@"主驾正面",@"后面",@"主驾侧面"];
    for (int a = 0; a < picNum; a++) {
        PicMesModel * mesmodel = [[PicMesModel alloc]init];
        mesmodel.picName = [picNameArr objectAtIndex:a];
        if (a == 0) {
            mesmodel.selectedStatus = YES;
        }
        [self.picMuarr addObject:mesmodel];
    }
}

#pragma mark -- addSubView
- (void)addSubView{
    self.picDisplayView.picMesArr = self.picMuarr;
    [self.view addSubview:self.picDisplayView];
    [self.view addSubview:self.picPreview];
    [self.view addSubview:self.flashBtn];
    [self.view addSubview:self.photoBtn];
    
    [self.picDisplayView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(self.view);
        make.bottom.equalTo(self.flashBtn.mas_top).offset(-15);
        make.height.equalTo(@100);
    }];
    self.picPreview.frame = CGRectMake(0, 0, CGRectGetWidth(self.view.frame), CGRectGetHeight(self.view.frame)- 200);

    self.picPreview.backgroundColor = [UIColor redColor];
    [self.picPreview mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.top.equalTo(self.view);
        make.bottom.equalTo(self.picDisplayView.mas_top).offset(-20);
    }];
    
   
    
    [self.photoBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.view.mas_centerX);
        make.bottom.equalTo(self.view.mas_bottom).offset(-20);
        make.height.width.equalTo(50);
    }];
    
    [self.flashBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.view.mas_centerX).multipliedBy(0.5);
        make.bottom.equalTo(self.view.mas_bottom).offset(-20);
        make.height.width.equalTo(50);
    }];
}

#pragma mark -- buttonMethod

- (void)takePhoto:(UIButton *)sender{
    NSLog(@"拍照");
    [self.picPreview takePhoto];
}

- (void)turnOnAndOffFlash:(UIButton *)sender{
    NSLog(@"闪光灯📸");
    [self.picPreview touchFlash];
}

- (void)jumpAction:(UIButton *)sender{
    NSLog(@"跳转。。。");
    TakephotoController * takephotoCv = [[TakephotoController alloc]init];
    [self.navigationController pushViewController:takephotoCv animated:YES];
}



- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    AppDelegate *appdelegate = (AppDelegate *)[UIApplication sharedApplication].delegate;
    appdelegate.allowRotation = NO;
    [[UIDevice currentDevice] setValue:[NSNumber numberWithInteger:UIInterfaceOrientationPortrait] forKey:@"orientation"];
    [self.navigationController setNavigationBarHidden:NO animated:YES];
}

@end
