//
//  TakephotoController.m
//  PhotographDemo
//
//  Created by WangLinbao on 2019/6/4.
//  Copyright © 2019 stewardR. All rights reserved.
//

#import "TakephotoController.h"
#import "AppDelegate.h"
#import "PicturePreview.h"
#import "MaskView.h"
#import "PictureDisplayView.h"
#import "PicMesModel.h"
#import "ScanPicView.h"
#import "UIImage+fixOrientation.h"
#import "MyOssCilent.h"
#import "UploadOSSManager.h"


static NSString * const leftTitleStr = @"1.整体车况上报";
static NSString * const rightTitleStr = @"2.损伤部位特写";
static NSString * const msgStr = @"为了保障您的权益，请拍摄晋AD16666";

static int picNum = 4;

@interface TakephotoController ()
@property (nonatomic,strong) UIButton *backBtn;
@property (nonatomic,strong) UILabel *leftTitleLbl;
@property (nonatomic,strong) UILabel *rightTitleLbl;
@property (nonatomic,strong) PicturePreview *picPreview; //预览窗口
@property (nonatomic,strong) MaskView *maskView; // 蒙层
@property (nonatomic,strong) UILabel *msgLbl;
@property (nonatomic,strong) UIButton *takePhotoBtn;
@property (nonatomic,strong) UIButton *flashBtn;
@property (nonatomic,strong) PictureDisplayView *picDisplayView;
@property (nonatomic,strong) NSMutableArray *picMuarr;
@property (nonatomic,assign) int currentPicPage; // 当前要拍的照片
@property (nonatomic,assign) int selectedPicPage; // 选中的照片
@property (nonatomic,strong) dispatch_group_t uploadPhotoGroup; // 上传图片队列组
@property (nonatomic,strong) NSMutableArray *uploadPicPathMuarr; // 图片路径数组
@property (nonatomic,strong) MyOssCilent *ossCilent;
@property (nonatomic,assign) BOOL afterLoadCanGo;
@property (nonatomic,strong) NSMutableArray *currentPicMuarr; // 存储拍过的照片最多四张，可以删除其中的数据，只存照片
@property (nonatomic,strong) NSMutableArray *picMesMuarr; // 存储照片信息，只增不删，用于涉及到重拍操作相关
@property (nonatomic,strong) NSMutableArray *deletedPicPathMuarr; // 重拍删除掉的图片路径
@property (nonatomic,strong) UploadOSSManager *uploadmanager; // 上传oss封装
@end

@implementation TakephotoController

#pragma mark -- lazyload

- (UploadOSSManager *)uploadmanager{
    if (!_uploadmanager) {
        _uploadmanager = [UploadOSSManager sharedInstance];
    }
    return _uploadmanager;
}

- (NSMutableArray *)deletedPicPathMuarr{
    if (!_deletedPicPathMuarr) {
        _deletedPicPathMuarr = [[NSMutableArray alloc]init];
    }
    return _deletedPicPathMuarr;
}


- (NSMutableArray *)picMesMuarr{
    if (!_picMesMuarr) {
        _picMesMuarr = [[NSMutableArray alloc]init];
    }
    return _picMesMuarr;
}

- (NSMutableArray *)currentPicMuarr{
    if (!_currentPicMuarr) {
        _currentPicMuarr = [[NSMutableArray alloc]init];
    }
    return _currentPicMuarr;
}

- (MyOssCilent *)ossCilent{
    if (!_ossCilent) {
        _ossCilent = [MyOssCilent sharedInstance];
    }
    return _ossCilent;
}

- (NSMutableArray *)uploadPicPathMuarr{
    if (!_uploadPicPathMuarr) {
        _uploadPicPathMuarr = [[NSMutableArray alloc]init];
    }
    return _uploadPicPathMuarr;
}

- (dispatch_group_t)uploadPhotoGroup{
    if (!_uploadPhotoGroup) {
        _uploadPhotoGroup = dispatch_group_create();
    }
    return _uploadPhotoGroup;
}

- (NSMutableArray *)picMuarr{
    if (!_picMuarr) {
        _picMuarr = [[NSMutableArray alloc]init];
    }
    return _picMuarr;
}

- (PictureDisplayView *)picDisplayView{
    if (!_picDisplayView) {
        __weak typeof(self) weakSelf = self;
        _picDisplayView = [[PictureDisplayView alloc]init];
        _picDisplayView.scrollDirection = UICollectionViewScrollDirectionVertical;
        _picDisplayView.selectedBlock = ^(NSIndexPath * _Nonnull indexPath, UIImage * _Nonnull contentImg) {
            
            PicMesModel * picmesmodel = [[PicMesModel alloc]init];
            for (PicMesModel * model in weakSelf.picMesMuarr) {
                NSLog(@"模型中的图片:%@\n填充的图片:%@",model.currentImage,contentImg);
                if ([model.currentImage isEqual:contentImg]) {
                    picmesmodel = model;
                    break;
                }
            }
            [weakSelf scanImg:picmesmodel indexPath:indexPath];
        };
    }
    return _picDisplayView;
}

- (UIButton *)takePhotoBtn{
    if (!_takePhotoBtn) {
        _takePhotoBtn = [[UIButton alloc]initWithFrame:CGRectMake(0, 0, 64, 64)];
        [_takePhotoBtn setBackgroundImage:[UIImage imageNamed:@"icon_takephoto_camera"] forState:UIControlStateNormal];
        [_takePhotoBtn addTarget:self action:@selector(takePhotoAction:) forControlEvents:UIControlEventTouchDown];
    }
    return _takePhotoBtn;
}

- (UIButton *)flashBtn{
    if (!_flashBtn) {
        _flashBtn = [[UIButton alloc]initWithFrame:CGRectMake(0, 0, 64, 64)];
        [_flashBtn setBackgroundImage:[UIImage imageNamed:@"icon_takephoto_light_off"] forState:UIControlStateNormal];
        [_flashBtn setBackgroundImage:[UIImage imageNamed:@"icon_takephoto_light_on"] forState:UIControlStateSelected];
        [_flashBtn addTarget:self action:@selector(swichFlashMode:) forControlEvents:UIControlEventTouchDown];
    }
    return _flashBtn;
}

- (UILabel *)msgLbl{
    if (!_msgLbl) {
        _msgLbl = [[UILabel alloc]init];
        _msgLbl.text = msgStr;
        _msgLbl.backgroundColor = [UIColor clearColor];
        _msgLbl.font = [UIFont systemFontOfSize:13];
        _msgLbl.textColor = [UIColor blackColor];
        _msgLbl.textAlignment = NSTextAlignmentCenter;
    }
    return _msgLbl;
}

- (MaskView *)maskView{
    if (!_maskView) {
        _maskView = [[MaskView alloc]init];
        _maskView.fillColor = [UIColor whiteColor];
        _maskView.bezierPathY = 20.f;
        _maskView.opacityCount = 0.4;
    }
    return _maskView;
}


- (PicturePreview *)picPreview{
    if (!_picPreview) {
         __weak typeof(self) weakSelf = self;
        _picPreview = [[PicturePreview alloc]initWithPhotoMode];
        _picPreview.takePhotoBlock = ^(UIImage * _Nonnull photo) {
            CFAbsoluteTime startTime =CFAbsoluteTimeGetCurrent();
            UIImage * webpImage = [UIImage imageWithData:UIImageJPEGRepresentation(photo, 0.1)];
            UIImage * displayImg = [UIImage image:webpImage rotation:UIImageOrientationUp];
            UIImageWriteToSavedPhotosAlbum(displayImg, nil, nil, nil);
            CFAbsoluteTime linkTime = (CFAbsoluteTimeGetCurrent() - startTime);
            NSLog(@"Linked in %f ms", linkTime *1000.0);  // 代码块运行time
            
            // 存储照片信息
            PicMesModel * picmesmodel = [[PicMesModel alloc]init];
            picmesmodel.currentImage = displayImg;
            picmesmodel.deleted = NO;
            picmesmodel.ossPath = [NSString stringWithFormat:@"%@%ld---%d.png",UPLOAD_OBJECT_KEY,(long)[weakSelf getNowTimestamp],[weakSelf getRandomNumber]];
            [weakSelf.picMesMuarr addObject:picmesmodel];
            
            if (photo) {
                    if (weakSelf.currentPicMuarr.count == picNum) { // 1.拍摄完成 上传同时完成  2. 拍摄完成，上传未完成
                        NSLog(@"拍摄完成");
                        return ;
                    }else{
                        PicMesModel * mesmodel = [weakSelf.picMuarr objectAtIndex:weakSelf.currentPicPage];
                        mesmodel.currentImage = displayImg;
                        mesmodel.canSelected = YES;
                        [weakSelf.currentPicMuarr addObject:displayImg];
                        if (weakSelf.currentPicMuarr.count == picNum) {
                             [weakSelf.picPreview stop];
                        }
                        for (int a = 0; a <weakSelf.picMuarr.count ; a++) {
                            PicMesModel * picmodel = [weakSelf.picMuarr objectAtIndex:a];
                            if (!picmodel.currentImage) {
                                weakSelf.currentPicPage = a;
                                break;
                            }
                        }
                        
                    }
            }
            
            [weakSelf.picMuarr enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
                PicMesModel * mesmodel = obj;
                if (idx == weakSelf.currentPicPage && weakSelf.currentPicMuarr.count != picNum) { // 当拍够四张的时候，选中框取消
                    mesmodel.selectedStatus = YES;
                }else{
                    mesmodel.selectedStatus = NO;
                }
            }];
            
            [weakSelf.picDisplayView reloadPic];
            [weakSelf.uploadmanager uploadPicToOssWithPicturePathMuarr:weakSelf.uploadPicPathMuarr
                                                        picturePathPre:UPLOAD_OBJECT_KEY
                                                       deletedPicMuarr:weakSelf.deletedPicPathMuarr
                                                                picMes:picmesmodel uploadResult:^(BOOL uploadAll, NSMutableArray *waitUploadPicMuarr) {
                                                                    NSLog(@"block 🚦 %d,%@",uploadAll,waitUploadPicMuarr);
                                                                }];
        };
    }
    return _picPreview;
}

- (UIButton *)backBtn{
    if (!_backBtn) {
        _backBtn = [[UIButton alloc]initWithFrame:CGRectMake(0, 0, 40, 40)];
        [_backBtn setImage:[UIImage imageNamed:@"iOS ／ btn ／ main ／ delete"] forState:UIControlStateNormal];
        [_backBtn addTarget:self action:@selector(backAction:) forControlEvents:UIControlEventTouchDown];
    }
    return _backBtn;
}

- (UILabel *)leftTitleLbl{
    if (!_leftTitleLbl) {
        _leftTitleLbl = [[UILabel alloc]init];
        _leftTitleLbl.text = leftTitleStr;
        _leftTitleLbl.font = [UIFont systemFontOfSize:13];
        _leftTitleLbl.textColor = [UIColor blackColor];
        _leftTitleLbl.textAlignment = NSTextAlignmentCenter;
        _leftTitleLbl.backgroundColor = [UIColor colorWithRed:1.00 green:0.67 blue:0.01 alpha:1.00];
    }
    return _leftTitleLbl;
}

- (UILabel *)rightTitleLbl{
    if (!_rightTitleLbl) {
        _rightTitleLbl = [[UILabel alloc]init];
        _rightTitleLbl.text = rightTitleStr;
        _rightTitleLbl.font = [UIFont systemFontOfSize:13];
        _rightTitleLbl.textColor = [UIColor colorWithRed:0.65 green:0.66 blue:0.68 alpha:1.00];
        _rightTitleLbl.textAlignment = NSTextAlignmentCenter;
        _rightTitleLbl.backgroundColor = [UIColor colorWithRed:0.21 green:0.22 blue:0.25 alpha:1.00];
    }
    return _rightTitleLbl;
}




- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.picDisplayView.picMesArr = self.picMuarr;
    self.afterLoadCanGo = YES;
    self.view.backgroundColor = [UIColor whiteColor];
    self.currentPicPage = 0;
    [self setRotation];
    [self addSubviews];
    [self createData];
    
}

#pragma mark - Setter Getter Methods

#pragma mark - Public Methods

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self.navigationController setNavigationBarHidden:YES animated:YES];
}

#pragma mark - Private Methods

- (void)addSubviews{ // 添加子视图
    [self.view addSubview:self.leftTitleLbl];
    [self.view addSubview:self.rightTitleLbl];
    [self.view addSubview:self.picPreview];
    [self.view addSubview:self.maskView];
    [self.view addSubview:self.backBtn];
    [self.view addSubview:self.msgLbl];
    [self.view addSubview:self.takePhotoBtn];
    [self.view addSubview:self.flashBtn];
    [self.view addSubview:self.picDisplayView];
    
    [self.leftTitleLbl mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.top.equalTo(self.view);
        make.height.equalTo(24);
        make.width.equalTo(self.view.mas_width).multipliedBy(0.5);
    }];
    
    [self.rightTitleLbl mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.leftTitleLbl.mas_right);
        make.right.top.equalTo(self.view);
        make.height.equalTo(self.leftTitleLbl.mas_height);
    }];
    
    [self.backBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.maskView.mas_top).offset(20);
        make.right.equalTo(self.maskView.mas_right).offset(-20);
        make.height.width.equalTo(40);
    }];
    
    [self.picPreview mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.bottom.equalTo(self.view);
        make.top.equalTo(self.leftTitleLbl.mas_bottom);
    }];
    [self.maskView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.bottom.left.right.equalTo(self.picPreview);
    }];
    
    [self.msgLbl mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.left.equalTo(self.maskView);
        make.bottom.equalTo(self.maskView.mas_bottom).offset(-11);
        make.height.equalTo(18);
    }];
    
    [self.takePhotoBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.height.width.equalTo(64);
        make.centerY.equalTo(self.view.mas_centerY);
        make.right.equalTo(self.maskView.mas_right).offset(-47);
    }];
    
    [self.flashBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.takePhotoBtn.mas_centerX);
        make.height.width.equalTo(28);
        make.top.equalTo(self.takePhotoBtn.mas_bottom).offset(20);
    }];
    
    [self.picDisplayView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.view.mas_left).offset(37);
        make.top.equalTo(self.maskView.mas_top).offset(19);
        make.bottom.equalTo(self.maskView.mas_bottom).offset(-19);
        make.width.equalTo(74);
    }];
}


#pragma mark -- setData

- (void)createData{
    
    NSArray * picNameArr = @[@"image_takephoto_zhujiace",
                             @"image_takephoto_zhengmian",
                             @"image_takephoto_fujiace",
                             @"image_takephoto_houmian"];
    for (int a = 0; a < 4; a++) {
        PicMesModel * mesmodel = [[PicMesModel alloc]init];
        mesmodel.placeholderImage = [picNameArr objectAtIndex:a];
        if (a == 0) {
            mesmodel.selectedStatus = YES;
        }
        [self.picMuarr addObject:mesmodel];
    }
}



- (void)setRotation{
    AppDelegate *appdelegate = (AppDelegate *)[UIApplication sharedApplication].delegate;
    appdelegate.allowRotation = YES;
    [[UIDevice currentDevice] setValue:[NSNumber numberWithInteger:UIInterfaceOrientationPortrait] forKey:@"orientation"];
    [[UIDevice currentDevice] setValue:[NSNumber numberWithInteger:UIInterfaceOrientationLandscapeRight] forKey:@"orientation"];
}

- (void)backAction:(UIButton *)sender{
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)takePhotoAction:(UIButton *)sender{
    NSLog(@"拍照");
    [self.picPreview takePhoto];
}

- (void)swichFlashMode:(UIButton *)sender{
    NSLog(@"闪光灯");
     [self.picPreview touchFlash];
    if (sender.isSelected) {
        sender.selected = NO;
    }else{
        sender.selected = YES;
    }
}

- (void)scanImg:(PicMesModel *)picmodel indexPath:(NSIndexPath *)indexpath{
    
    ScanPicView *scanImgView =[[ScanPicView alloc]initWithPic:picmodel.currentImage];
    __weak typeof(self) weakSelf = self;
    scanImgView.resetblock = ^{ // 重拍
        [weakSelf.picPreview start];
        if ([weakSelf.currentPicMuarr containsObject:picmodel.currentImage]) {
            [weakSelf.currentPicMuarr removeObject:picmodel.currentImage];
            picmodel.deleted = YES;
        }
        
        if ([weakSelf.uploadPicPathMuarr containsObject:picmodel.ossPath]) {
            [weakSelf.uploadPicPathMuarr removeObject:picmodel.ossPath];
        }
        
        weakSelf.selectedPicPage = (int)indexpath.row;
        weakSelf.currentPicPage = (int)indexpath.row;
        [weakSelf.picMuarr enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            PicMesModel * mesmodel = obj;
            if (idx == weakSelf.selectedPicPage) {
                mesmodel.selectedStatus = YES;
                mesmodel.canSelected = NO;
                mesmodel.currentImage = NULL;
            }else{
                mesmodel.selectedStatus = NO;
            }
        }];
        weakSelf.afterLoadCanGo = YES;
         [weakSelf.picDisplayView reloadPic];
    };
    [self.view addSubview:scanImgView];
    [scanImgView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.top.bottom.equalTo(self.view);
    }];
}




#pragma mark -- 终止上传操作

- (NSInteger)getNowTimestamp{
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateStyle:NSDateFormatterMediumStyle];
    [formatter setTimeStyle:NSDateFormatterShortStyle];
    [formatter setDateFormat:@"YYYY-MM-dd HH:mm:ss"]; // ----------设置你想要的格式,hh与HH的区别:分别表示12小时制,24小时制
    //设置时区,这个对于时间的处理有时很重要
    NSTimeZone* timeZone = [NSTimeZone timeZoneWithName:@"Asia/Beijing"];
    [formatter setTimeZone:timeZone];
    NSDate *datenow = [NSDate date];//现在时间
    //时间转时间戳的方法:
    NSInteger timeSp = [[NSNumber numberWithDouble:[datenow timeIntervalSince1970]] integerValue];
    return timeSp;
}


- (int)getRandomNumber{
    int x = arc4random() % 100;
    return x;
}


@end
