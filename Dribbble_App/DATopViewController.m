//
//  DATopViewController.m
//  Dribbble_App
//
//  Created by oda yuma on 2014/08/09.
//  Copyright (c) 2014年 yuma oda. All rights reserved.
//

#import "DATopViewController.h"
#import "DACollectionViewCell.h"
#import "DAShotsModel.h"
#import "DADetailViewController.h"
#import <SDWebImage/UIImageView+WebCache.h>

static NSString * const DACollectionViewCellIdentifier = @"Cell";

@interface DATopViewController ()

@end

@implementation DATopViewController
{
    UICollectionView *collectionView;
    NSMutableArray *shotsArray;
    UIRefreshControl *refreshControl;
    int nowPage;
    BOOL isLoading;
}

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
    
    
    [self settingCollectionView];
    [self settingRefleshController];
    
    shotsArray = [NSMutableArray array];
    nowPage = 1;
    [self getShotsModelArrayWithRequestType:DAAPIRequestTypePopular WithPage:nowPage];
}

-(void)settingCollectionView
{
    CHTCollectionViewWaterfallLayout *layout = [[CHTCollectionViewWaterfallLayout alloc] init];
    layout.sectionInset = UIEdgeInsetsMake(10, 10, 10, 10);
    layout.minimumColumnSpacing = 10;
    layout.minimumInteritemSpacing = 10;
    
    collectionView = [[UICollectionView alloc] initWithFrame:self.view.bounds collectionViewLayout:layout];
    collectionView.backgroundColor = COLOR_BACKGROUND;
    collectionView.dataSource = self;
    collectionView.delegate = self;
    [collectionView registerClass:[DACollectionViewCell class] forCellWithReuseIdentifier:DACollectionViewCellIdentifier];
    [collectionView registerNib:[UINib nibWithNibName:@"DACollectionViewCell" bundle:nil] forCellWithReuseIdentifier:DACollectionViewCellIdentifier];
    [self.view addSubview:collectionView];
}

-(void)settingRefleshController
{
    UIView *refreshView = [[UIView alloc] initWithFrame:CGRectMake(0, 12, 0, 0)];
    [collectionView insertSubview:refreshView atIndex:0];
    refreshControl = [[UIRefreshControl alloc] init];
    refreshControl.tintColor = [UIColor redColor];
    [refreshControl addTarget:self action:@selector(refreshDatas) forControlEvents:UIControlEventValueChanged];
    [refreshView addSubview:refreshControl];
}

-(void)getShotsModelArrayWithRequestType:(DAAPIRequestType)type WithPage:(int)page
{
    [[DAAPIConnecter sharedManager] connectWithType:type pageCount:page completion:^(BOOL successFlg, NSArray *array) {
        if (successFlg == NO) {
            NSLog(@"error");
        }else {
            [shotsArray addObjectsFromArray:array];
            [collectionView reloadData];
            if (page == 1) {
                [refreshControl endRefreshing];
            }else {
                isLoading = NO;
            }
        }
    }];
}

-(void)refreshDatas
{
    [shotsArray removeAllObjects];
    [self getShotsModelArrayWithRequestType:DAAPIRequestTypePopular WithPage:1];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - UICollectionViewDataSource

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return shotsArray.count;
}

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView
{
    return 1;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView_ cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    DACollectionViewCell *cell = (DACollectionViewCell *)[collectionView_ dequeueReusableCellWithReuseIdentifier:DACollectionViewCellIdentifier forIndexPath:indexPath];
    
    DAShotsModel *shotsModel = shotsArray[indexPath.row];
    
//    float resizedWidth = 145.0;
//    float resizedHeight = resizedWidth * [shotsModel.height floatValue] / [shotsModel.width floatValue];
//    NSLog(@"%f", resizedHeight);
    
    cell.mainImageView = (UIImageView *)[cell viewWithTag:1];
//    cell.mainImageView.frame = CGRectMake(0, 0, resizedWidth, resizedHeight);
    cell.mainImageView.backgroundColor = [UIColor blackColor];
    __weak UIImageView *weekMainImageView = cell.mainImageView;
    [cell.mainImageView sd_setImageWithURL:[NSURL URLWithString:shotsModel.imageURLStr]
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
    cell.avatarImageView = (UIImageView *)[cell viewWithTag:2];
    cell.mainImageView.backgroundColor = [UIColor blackColor];
    __weak UIImageView *weekAvatarImageView = cell.mainImageView;
    [cell.avatarImageView sd_setImageWithURL:[NSURL URLWithString:shotsModel.avatarURLStr]
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
    
    cell.nameLabel = (UILabel *)[cell viewWithTag:3];
    cell.nameLabel.text = shotsModel.usernameStr;
    cell.titleLabel = (UILabel *)[cell viewWithTag:4];
    cell.titleLabel.text = shotsModel.titleStr;
    cell.likeCountLabel = (UILabel *)[cell viewWithTag:6];
    cell.likeCountLabel.text = shotsModel.likesCountStr;
    cell.pageViewCountLabel = (UILabel *)[cell viewWithTag:8];
    cell.pageViewCountLabel.text = shotsModel.viewsCountStr;
    
    return cell;
}

#pragma mark - UICollectionViewDelegate

-(void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    DAShotsModel *shotsModel = shotsArray[indexPath.row];
    DADetailViewController *detailVC = [[DADetailViewController alloc] initWithNibName:@"DADetailViewController" bundle:nil];
    detailVC.shotsModel = shotsModel;
    [self.navigationController pushViewController:detailVC animated:YES];
}

#pragma mark - CHTCollectionViewDelegateWaterfallLayout

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
//    return [self.cellSizes[indexPath.item] CGSizeValue];
    return CGSizeMake(145, 220);
}

#pragma mark - Paging

-(void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    if (collectionView.contentSize.height - [UIScreen mainScreen].bounds.size.height - 50.0 < scrollView.contentOffset.y) {
        // このタイミングでページングスタート
        if (!isLoading) {
            isLoading = YES;
            // NSLog(@"nextPage::%d", nowPage + 1);
            [self pagingShotsDataWithNextPage:nowPage + 1];
        }
    }
}

-(void)pagingShotsDataWithNextPage:(int)page
{
    [self getShotsModelArrayWithRequestType:DAAPIRequestTypePopular WithPage:page];
    nowPage++;
}

@end
