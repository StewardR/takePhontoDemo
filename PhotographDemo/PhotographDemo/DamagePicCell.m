//
//  DamagePicCell.m
//  PhotographDemo
//
//  Created by Roy on 2019/6/26.
//  Copyright © 2019 stewardR. All rights reserved.
//

#import "DamagePicCell.h"

@interface  DamagePicCell()
@property (weak, nonatomic) IBOutlet UIImageView *picImageView;

@property (weak, nonatomic) IBOutlet UILabel *imageNameLbl;

@end


@implementation DamagePicCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    self.picImageView.layer.cornerRadius = 4;
    self.picImageView.layer.borderWidth = 2.f;
    self.picImageView.layer.masksToBounds = YES;
    self.contentView.backgroundColor = [UIColor clearColor];
    self.picImageView.backgroundColor = [UIColor colorWithRed:0.31 green:0.33 blue:0.39 alpha:1.00];
}


- (void)updateCellMesWithPlaceHolderImage:(NSString *)placeholderiamge fillImage:(UIImage *)fillimage selectedStatus:(BOOL)selectedstatus canSelected:(BOOL)canSelected pictureName:(NSString *)name{
    if (!fillimage) {
        self.picImageView.image = [UIImage imageNamed:placeholderiamge];
        self.imageNameLbl.text = name;
    }else{
        self.picImageView.image = fillimage;
        self.imageNameLbl.text = @"";
    }
    
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
