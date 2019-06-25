//
//  PictureCustomCell.m
//  PhotographDemo
//
//  Created by Ray on 2019/5/23.
//  Copyright © 2019 stewardR. All rights reserved.
//

#import "PictureCustomCell.h"

@interface PictureCustomCell ()
@property (weak, nonatomic) IBOutlet UIImageView *picImageView;
@property (weak, nonatomic) IBOutlet UILabel *titleLbl;

@end

@implementation PictureCustomCell

- (void)awakeFromNib {
    [super awakeFromNib];
    self.picImageView.layer.cornerRadius = 4;
    self.picImageView.layer.borderWidth = 2.f;
    self.picImageView.layer.masksToBounds = YES;
    self.contentView.backgroundColor = [UIColor clearColor];
    self.picImageView.backgroundColor = [UIColor clearColor];
}

- (void)updateCellMesWithPlaceHolderImage:(NSString *)placeholderiamge fillImage:(UIImage *)fillimage selectedStatus:(BOOL)selectedstatus canSelected:(BOOL)canSelected pictureName:(NSString *)name{
    if (!fillimage) {
        self.picImageView.image = [UIImage imageNamed:placeholderiamge];
    }else{
        self.picImageView.image = fillimage;
    }
    
    self.titleLbl.text = name;
    
    if (selectedstatus) {
        self.picImageView.layer.borderColor = [UIColor colorWithRed:1.00 green:0.67 blue:0.01 alpha:1.00].CGColor;
        self.picImageView.backgroundColor = [UIColor clearColor];
    }else{
        self.picImageView.layer.borderColor = [UIColor clearColor].CGColor;
        self.picImageView.backgroundColor = [UIColor clearColor];
    }
    
    self.selected = canSelected;
}
@end
