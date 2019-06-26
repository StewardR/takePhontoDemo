//
//  PictureDisplayView.m
//  PhotographDemo
//
//  Created by Ray on 2019/5/23.
//  Copyright © 2019 stewardR. All rights reserved.
//

#import "PictureDisplayView.h"
#import "PictureCustomCell.h"
#import "PicMesModel.h"
#import "DamagePicCell.h" // 拍车损

static NSString * const customCellID = @"picturecellid";
static NSString * const customcellWithoutPlaceholderID = @"customcellWithoutPlaceholderID";

static CGFloat miniItemSpace = 20.f;


@interface PictureDisplayView ()<UICollectionViewDelegate,UICollectionViewDelegateFlowLayout,UICollectionViewDataSource>

@property (nonatomic,strong) UICollectionView *mainPicCollectionView;

@end

@implementation PictureDisplayView

#pragma mark -- lazyload

- (UICollectionView *)mainPicCollectionView{
    if (!_mainPicCollectionView) {
        UICollectionViewFlowLayout * flowLayout = [[UICollectionViewFlowLayout alloc]init];
        flowLayout.minimumLineSpacing = miniItemSpace;
        flowLayout.minimumInteritemSpacing = CGFLOAT_MIN;
        flowLayout.scrollDirection = self.scrollDirection;
        
        _mainPicCollectionView = [[UICollectionView alloc]initWithFrame:CGRectMake(0, 0, CGRectGetWidth(self.frame), CGRectGetHeight(self.frame)) collectionViewLayout:flowLayout];
        _mainPicCollectionView.delegate = self;
        _mainPicCollectionView.dataSource = self;
        _mainPicCollectionView.backgroundColor = [UIColor clearColor];
        [_mainPicCollectionView registerNib:[UINib nibWithNibName:NSStringFromClass([PictureCustomCell class]) bundle:nil] forCellWithReuseIdentifier:customCellID];
        [_mainPicCollectionView registerNib:[UINib nibWithNibName:NSStringFromClass([DamagePicCell class]) bundle:nil] forCellWithReuseIdentifier:customcellWithoutPlaceholderID];
    }
    return _mainPicCollectionView;
}


- (instancetype)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [UIColor clearColor];
        [self addSubView];
    }
    return self;
}

#pragma mark -- initView
- (void)addSubView{
    [self addSubview:self.mainPicCollectionView];
}

#pragma mark -- collectionviewdelegate and datasource

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView{
    return 1;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    return self.picMesArr.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    
    if (self.takephotoType == TakePhotoType_Damage) {
        DamagePicCell * picCell = [collectionView dequeueReusableCellWithReuseIdentifier:customcellWithoutPlaceholderID forIndexPath:indexPath];
        if (!picCell) {
            picCell = [[[NSBundle mainBundle]loadNibNamed:NSStringFromClass([DamagePicCell class])
                                                    owner:self
                                                  options:nil]lastObject];
        }
        PicMesModel * cellmodel = [self.picMesArr objectAtIndex:indexPath.row];
        NSLog(@"cell渲染中的图片：%@",cellmodel.currentImage);
        [picCell updateCellMesWithPlaceHolderImage:cellmodel.placeholderImage
                                         fillImage:cellmodel.currentImage
                                    selectedStatus:cellmodel.selectedStatus
                                       canSelected:cellmodel.canSelected
                                       pictureName:cellmodel.picName];
        return picCell ;
    }else{
        PictureCustomCell * picCell = [collectionView dequeueReusableCellWithReuseIdentifier:customCellID forIndexPath:indexPath];
        if (!picCell) {
            picCell = [[[NSBundle mainBundle]loadNibNamed:NSStringFromClass([PictureCustomCell class])
                                                    owner:self
                                                  options:nil]lastObject];
        }
        PicMesModel * cellmodel = [self.picMesArr objectAtIndex:indexPath.row];
        NSLog(@"cell渲染中的图片：%@",cellmodel.currentImage);
        [picCell updateCellMesWithPlaceHolderImage:cellmodel.placeholderImage
                                         fillImage:cellmodel.currentImage
                                    selectedStatus:cellmodel.selectedStatus
                                       canSelected:cellmodel.canSelected
                                       pictureName:cellmodel.picName];
        return picCell ;
    }
    
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath{
    CGSize cellSize = CGSizeMake(74, 48);
    return cellSize;
}

- (UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout insetForSectionAtIndex:(NSInteger)section{
    return UIEdgeInsetsMake(19, 0, 0, 0);
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    PicMesModel * cellmodel = [self.picMesArr objectAtIndex:indexPath.row];
    if (cellmodel.canSelected && self.selectedBlock) {
        self.selectedBlock(indexPath, cellmodel.currentImage);
    }
}

#pragma mark -- setter and getter


#pragma mark -- layout
- (void)layoutSubviews{
    [super layoutSubviews];
    [self.mainPicCollectionView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.top.right.bottom.equalTo(self);
    }];
}

- (void)reloadPic{
    [self.mainPicCollectionView reloadData];
}


@end
