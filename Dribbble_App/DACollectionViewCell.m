//
//  DACollectionViewCell.m
//  Dribbble_App
//
//  Created by oda yuma on 2014/08/09.
//  Copyright (c) 2014年 yuma oda. All rights reserved.
//

#import "DACollectionViewCell.h"
#import <SDWebImage/UIImageView+WebCache.h>

@implementation DACollectionViewCell

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
    }
    return self;
}

+(CGFloat)heightForShots:(DAShotsModel *)shotsModel{
    
    NSMutableParagraphStyle *style = [[NSMutableParagraphStyle alloc] init];
    style.lineBreakMode = NSLineBreakByCharWrapping;
    style.alignment = NSTextAlignmentLeft;
    NSDictionary *attributes = @{
                                 NSFontAttributeName : [UIFont systemFontOfSize:14.0],
                                 NSParagraphStyleAttributeName : style
                                 };
    
    CGRect rect = [shotsModel.titleStr boundingRectWithSize:CGSizeMake(127.0, CGFLOAT_MAX)
                                                    options:NSStringDrawingUsesLineFragmentOrigin
                                                 attributes:attributes
                                                    context:nil];
    CGFloat height = rect.size.height + 180;
    
    return height;
}

-(void)configureCellWithShotsModel:(DAShotsModel *)shotsModel
{
    self.mainImageView.backgroundColor = [UIColor blackColor];
    __weak UIImageView *weekMainImageView = self.mainImageView;
    [self.mainImageView sd_setImageWithURL:[NSURL URLWithString:shotsModel.imageURLStr]
                          placeholderImage:nil
                                 completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
                                     if (cacheType != SDImageCacheTypeMemory) {
                                         [UIView transitionWithView:weekMainImageView
                                                           duration:0.3
                                                            options:UIViewAnimationOptionTransitionCrossDissolve |
                                          UIViewAnimationOptionCurveLinear |
                                          UIViewAnimationOptionAllowUserInteraction
                                                         animations:nil
                                                         completion:nil];
                                     }
                                 }];
    
    self.titleLabel.text = shotsModel.titleStr;
    //[self.titleLabel sizeToFit];
    
    self.pageViewCountLabel.frame = (CGRect){
        .origin = {
            CGRectGetMinX(self.titleLabel.frame), CGRectGetMaxY(self.titleLabel.frame) + 5
        },
        .size = {0  , 0}
    };
    self.pageViewCountLabel.text = shotsModel.viewsCountStr;
    [self.pageViewCountLabel sizeToFit];
    
    self.pageViewLabel.frame = (CGRect){
        .origin = {
            CGRectGetMaxX(self.pageViewCountLabel.frame) + 1, CGRectGetMinY(self.pageViewCountLabel.frame)
        },
        .size = {0, 0}
    };
    self.pageViewLabel.text = @"views";
    [self.pageViewLabel sizeToFit];
    
    self.likeCountLabel.frame = (CGRect){
        .origin = {
            CGRectGetMaxX(self.pageViewLabel.frame) + 3, CGRectGetMinY(self.pageViewLabel.frame)
        },
        .size = {0, 0}
    };
    self.likeCountLabel.text = shotsModel.likesCountStr;
    [self.likeCountLabel sizeToFit];
    
    self.likeLabel.frame = (CGRect){
        .origin = {
            CGRectGetMaxX(self.likeCountLabel.frame) + 1, CGRectGetMinY(self.likeCountLabel.frame)
        },
        .size = {0, 0}
    };
    self.likeLabel.text = @"likes";
    [self.likeLabel sizeToFit];
    
    self.avatarImageView.backgroundColor = [UIColor blackColor];
    self.avatarImageView.frame = (CGRect){
        .origin = {
            CGRectGetMinX(self.pageViewCountLabel.frame) - 3, CGRectGetMaxY(self.pageViewCountLabel.frame) + 5
        },
        .size = {35, 35}
    };
    __weak UIImageView *weekAvatarImageView = self.avatarImageView;
    [self.avatarImageView sd_setImageWithURL:[NSURL URLWithString:shotsModel.avatarURLStr]
                            placeholderImage:nil
                                   completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
                                       if (cacheType != SDImageCacheTypeMemory) {
                                           [UIView transitionWithView:weekAvatarImageView
                                                             duration:0.3
                                                              options:UIViewAnimationOptionTransitionCrossDissolve |
                                            UIViewAnimationOptionCurveLinear |
                                            UIViewAnimationOptionAllowUserInteraction
                                                           animations:nil
                                                           completion:nil];
                                       }
                                   }];
    
    self.nameLabel.frame = (CGRect){
        .origin = {
            CGRectGetMaxX(self.avatarImageView.frame) + 5, CGRectGetMaxY(self.pageViewCountLabel.frame) + 14
        },
        .size = {0, 0}
    };
    self.nameLabel.text = shotsModel.usernameStr;
    [self.nameLabel sizeToFit];
}

-(void)layoutSubviews
{
    self.backgroundColor = [UIColor whiteColor];
    self.layer.cornerRadius = 3.0;
    self.clipsToBounds = YES;
    
    self.avatarImageView.layer.cornerRadius = CGRectGetWidth(self.avatarImageView.frame) / 2.0;
    self.avatarImageView.clipsToBounds = YES;
    
    self.nameLabel.adjustsFontSizeToFitWidth = YES;
    self.nameLabel.minimumScaleFactor = 2.0;
    
    self.nameLabel.textColor = [UIColor grayColor];
    self.titleLabel.textColor = [UIColor darkTextColor];
    self.likeLabel.textColor = [UIColor lightGrayColor];
    self.likeCountLabel.textColor = [UIColor lightGrayColor];
    self.pageViewLabel.textColor = [UIColor lightGrayColor];
    self.pageViewCountLabel.textColor = [UIColor lightGrayColor];
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
}
*/

@end
