//
//  DADetailViewController.m
//  Dribbble_App
//
//  Created by oda yuma on 2014/08/09.
//  Copyright (c) 2014年 yuma oda. All rights reserved.
//

#import "DADetailViewController.h"
#import <SDWebImage/UIImageView+WebCache.h>
#import "NSString+stripHtml.h"
#import "DACoreDataManager.h"
#import "Player.h"
#import "Shot.h"

@interface DADetailViewController ()

@end

@implementation DADetailViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    self.view.backgroundColor = COLOR_BACKGROUND;
    
    // favボタン
    if (self.type != DAAPIRequestTypeFavorite) {
        UIBarButtonItem *barButton = [[UIBarButtonItem alloc] bk_initWithTitle:@"fav" style:UIBarButtonItemStylePlain handler:^(id sender) {
            [self tapFavButton];
        }];
        self.navigationItem.rightBarButtonItem = barButton;
    }
    
    self.scrollview.contentSize = CGSizeMake([UIScreen mainScreen].bounds.size.width, [UIScreen mainScreen].bounds.size.height - 64);
    
    self.headerView.backgroundColor = COLOR_DARK;
    
    self.avatarImageView.backgroundColor = [UIColor blackColor];
    __weak UIImageView *weekAvatarImageView = self.mainImageView;
    [self.avatarImageView sd_setImageWithURL:[NSURL URLWithString:self.shotsModel.avatarURLStr]
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
    self.avatarImageView.layer.cornerRadius = CGRectGetWidth(self.avatarImageView.frame) / 2.0;
    self.avatarImageView.clipsToBounds = YES;
    
    self.titleLabel.text = self.shotsModel.titleStr;
    self.titleLabel.font = [UIFont boldSystemFontOfSize:18.0];
    self.titleLabel.adjustsFontSizeToFitWidth = YES;
    self.titleLabel.minimumScaleFactor = 10.0;
    self.titleLabel.textColor = [UIColor whiteColor];
    
    
    self.byLabel.textColor = [UIColor lightGrayColor];
    self.nameLabel.textColor = COLOR_PINK;
    self.nameLabel.text = self.shotsModel.nameStr;
    
    self.mainImageView.backgroundColor = [UIColor blackColor];
    __weak UIImageView *weekMainImageView = self.mainImageView;
    [self.mainImageView sd_setImageWithURL:[NSURL URLWithString:self.shotsModel.imageURLStr]
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
    
    self.footerView.backgroundColor = COLOR_DARK;
    
    self.viewCountLabel.font = [UIFont boldSystemFontOfSize:13.0];
    self.viewCountLabel.textColor = [UIColor whiteColor];
    self.viewCountLabel.text = self.shotsModel.viewsCountStr;
    [self.viewCountLabel sizeToFit];
    
    self.viewLabel.frame = CGRectMake(CGRectGetMaxX(self.viewCountLabel.frame) + 5,
                                      CGRectGetMinY(self.viewCountLabel.frame),
                                      0, 0);
    self.viewLabel.text = @"views";
    [self.viewLabel sizeToFit];
    self.viewLabel.textColor = [UIColor lightGrayColor];
    
    self.likeCountLabel.frame = CGRectMake(CGRectGetMaxX(self.viewLabel.frame) + 10,
                                           CGRectGetMinY(self.viewCountLabel.frame),
                                           0, 0);
    self.likeCountLabel.font = [UIFont boldSystemFontOfSize:13.0];
    self.likeCountLabel.textColor = [UIColor whiteColor];
    self.likeCountLabel.text = self.shotsModel.likesCountStr;
    [self.likeCountLabel sizeToFit];
    
    self.likeLabel.frame = CGRectMake(CGRectGetMaxX(self.likeCountLabel.frame) + 5,
                                      CGRectGetMinY(self.viewLabel.frame),
                                      0, 0);
    self.likeLabel.text = @"likes";
    [self.likeLabel sizeToFit];
    self.likeLabel.textColor = [UIColor lightGrayColor];
    
    self.descriptionNameLabel.frame = CGRectMake(10, CGRectGetMinY(self.likeCountLabel.frame), 0, 0);
    self.descriptionNameLabel.text = @"description";
    self.descriptionNameLabel.font = [UIFont boldSystemFontOfSize:14.0];
    self.descriptionNameLabel.textColor = [UIColor whiteColor];
    [self.descriptionNameLabel sizeToFit];
    
    self.descriptionLabel.frame = (CGRect){
        .origin = {
            5, CGRectGetMaxY(self.footerView.frame) + 5
        },
        .size = {310, 0}
    };
    self.descriptionLabel.font = [UIFont boldSystemFontOfSize:14.0];
    self.descriptionLabel.textColor = COLOR_DARK;
    if (![self.shotsModel.descriptionStr isEqual:[NSNull null]]) {
        //self.descriptionLabel.text = [self.shotsModel.descriptionStr kv_encodeHTMLCharacterEntities];
        self.descriptionLabel.text = [self.shotsModel.descriptionStr stringByStrippingHTML];
    }else {
        self.descriptionLabel.text = @"";
    }
    self.descriptionLabel.numberOfLines = 0;
    self.descriptionLabel.lineBreakMode = NSLineBreakByWordWrapping;
    [self.descriptionLabel sizeToFit];
    
    // self.descriptionLabelのMaxYが568を超えるとき
    if (CGRectGetMaxY(self.descriptionLabel.frame) > [UIScreen mainScreen].bounds.size.height - 64) {
        self.scrollview.contentSize = CGSizeMake([UIScreen mainScreen].bounds.size.width, CGRectGetMaxY(self.descriptionLabel.frame) + 5);
    }
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)tapFavButton
{
    DACoreDataManager *manager = [DACoreDataManager sharedManager];
    
    Player *player = (Player *)[manager entityForInsert:@"Player"];
    player.username = self.shotsModel.usernameStr;
    player.name = self.shotsModel.nameStr;
    player.avatarURL = self.shotsModel.avatarURLStr;
    
    Shot *shot = (Shot *)[manager entityForInsert:@"Shot"];
    shot.title = self.shotsModel.titleStr;
    shot.likesCount = [[NSNumber alloc] initWithInt:[self.shotsModel.likesCountStr intValue]];
    shot.viewsCount = [[NSNumber alloc] initWithInt:[self.shotsModel.viewsCountStr intValue]];
    shot.imageURL = self.shotsModel.imageURLStr;
    if (![self.shotsModel.descriptionStr isEqual:[NSNull null]]) {
        shot.desc = self.shotsModel.descriptionStr;
    }else {
        shot.desc = @"";
    }
    shot.width = [[NSNumber alloc] initWithInt:[self.shotsModel.width intValue]];
    shot.height = [[NSNumber alloc] initWithInt:[self.shotsModel.height intValue]];
    shot.player = player;
    
    [manager saveContextCompletion:^(BOOL successFlg) {
        UIAlertView *alertView;
        if (successFlg) {
            alertView = [UIAlertView bk_alertViewWithTitle:nil message:@"保存しました。"];
        }else {
            alertView = [UIAlertView bk_alertViewWithTitle:nil message:@"保存に失敗しました。"];
        }
        [alertView bk_addButtonWithTitle:@"OK" handler:nil];
        [alertView show];
    }];
}

@end
