//
//  DACollectionViewCell.m
//  Dribbble_App
//
//  Created by oda yuma on 2014/08/09.
//  Copyright (c) 2014年 yuma oda. All rights reserved.
//

#import "DACollectionViewCell.h"

@implementation DACollectionViewCell

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
    }
    return self;
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
    
//    self.pageViewCountLabel.frame = (CGRect){
//        .origin = {
//            CGRectGetMinX(self.titleLabel.frame), CGRectGetMaxY(self.titleLabel.frame) + 5
//        },
//        .size = {0, 0}
//    };
//    [self.pageViewCountLabel sizeToFit];
    
//    self.pageViewLabel.frame = (CGRect){
//        .origin = {
//            CGRectGetMaxY(self.pageViewCountLabel.frame) + 3, CGRectGetMinY(self.pageViewCountLabel.frame)
//        },
//        .size = {0, 0}
//    };
//    self.pageViewLabel.text = @"views";
//    [self.pageViewLabel sizeToFit];
//    self.pageViewLabel.backgroundColor = [UIColor redColor];
    
//    [self.likeCountLabel sizeToFit];
//    self.pageViewLabel.frame = (CGRect){
//        .origin = {
//            CGRectGetMinX(self.likeCountLabel.frame) + CGRectGetWidth(self.pageViewCountLabel.frame),
//            CGRectGetMinY(self.likeCountLabel.frame)
//        }
//    };
//    [self.pageViewLabel sizeToFit];
    
    //self.mainImageView.frame = CGRectMake(0, 0, self.mainImageView.image.size.width, self.mainImageView.image.size.height);
    

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
