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
#import "DACoreDataManager.h"
#import "Shot.h"
#import "Player.h"

static NSString * const DACollectionViewCellIdentifier = @"Cell";

@interface DATopViewController ()
<NSFetchedResultsControllerDelegate>

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
    
    self.navigationController.navigationBar.translucent = NO;
    
    [self settingCollectionView];
    [self settingRefleshController];
    
    shotsArray = [NSMutableArray array];
    nowPage = 1;

    switch (self.type) {
        case DAAPIRequestTypeEveryone:
            self.title = @"Everyone";
            break;
        case DAAPIRequestTypeDebuts:
            self.title = @"Debuts";
            break;
        case DAAPIRequestTypePopular:
            self.title = @"Popular";
            break;
        case DAAPIRequestTypeFavorite:
            self.title = @"Favorite";
        default:
            break;
    }
    
    
    if (self.type != DAAPIRequestTypeFavorite) {
        [self getShotsModelArrayWithRequestType:self.type WithPage:nowPage];
    }else {
        // Favoriteの場合はAPI通信ではなく、CoreDataで取得
        [self getFavoriteShotsAndReload];
    }
}

-(void)settingCollectionView
{
    CHTCollectionViewWaterfallLayout *layout = [[CHTCollectionViewWaterfallLayout alloc] init];
    layout.sectionInset = UIEdgeInsetsMake(10, 10, 74, 10);
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
    refreshControl.tintColor = COLOR_PINK;
    [refreshControl addTarget:self action:@selector(refreshDatas) forControlEvents:UIControlEventValueChanged];
    [refreshView addSubview:refreshControl];
}

-(void)getShotsModelArrayWithRequestType:(DAAPIRequestType)type WithPage:(int)page
{
    [[DAAPIConnecter sharedManager] connectWithType:type pageCount:page completion:^(BOOL successFlg, NSArray *array) {
        if (successFlg == NO) {
            NSLog(@"error");
            UIAlertView *alertView = [UIAlertView bk_alertViewWithTitle:@"" message:@"リトライしてください。"];
            [alertView bk_addButtonWithTitle:@"OK" handler:nil];
            [alertView show];
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

-(void)getFavoriteShotsAndReload
{
    NSFetchRequest *request = [[DACoreDataManager sharedManager] fetchRequest:@"Shot" sortKey:@"title" limit:0];
    NSFetchedResultsController *fetchedResultsController = [[NSFetchedResultsController alloc] initWithFetchRequest:request
                                                                                               managedObjectContext:[[DACoreDataManager sharedManager] managedObjectContext]
                                                                                                 sectionNameKeyPath:nil
                                                                                                          cacheName:nil];
    fetchedResultsController.delegate = self;
    // データ検索を行います。
    // 失敗した場合には、メソッドはfalseを返し、引数errorに値を詰めてくれます。
    NSError *error = nil;
    if (![fetchedResultsController performFetch:&error]) {
        NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
    }
    
    NSArray *favShotsArray = [fetchedResultsController fetchedObjects];
    [favShotsArray enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
        Shot *shot = (Shot *)obj;
        NSDictionary *resultDic = @{@"title": shot.title,
                                    @"likes_count": shot.likesCount,
                                    @"views_count": shot.viewsCount,
                                    @"image_url": shot.imageURL,
                                    @"description": shot.desc,
                                    @"width": shot.width,
                                    @"height": shot.height,
                                    @"player" : @{@"username": shot.player.username,
                                                  @"name": shot.player.name,
                                                  @"avatar_url": shot.player.avatarURL
                                                  }
                                    };
        
        DAShotsModel *model = [DAShotsModel makesShotsModelWith:resultDic];
        [shotsArray addObject:model];
    }];
    [collectionView reloadData];
}

-(void)refreshDatas
{
    if (self.type == DAAPIRequestTypeFavorite) {
        [refreshControl endRefreshing];
        return;
    }
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
    [cell configureCellWithShotsModel:shotsModel];
    
    return cell;
}

#pragma mark - UICollectionViewDelegate

-(void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    DAShotsModel *shotsModel = shotsArray[indexPath.row];
    DADetailViewController *detailVC = [[DADetailViewController alloc] initWithNibName:@"DADetailViewController" bundle:nil];
    detailVC.shotsModel = shotsModel;
    detailVC.type = self.type;
    [self.navigationController pushViewController:detailVC animated:YES];
}

#pragma mark - CHTCollectionViewDelegateWaterfallLayout

- (CGSize)collectionView:(UICollectionView *)collectionView_ layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    // タイトルの行数によってセルの幅を変える　ができなかった。
    //return CGSizeMake(145, [DACollectionViewCell heightForShots:shotsArray[indexPath.item]]);
    return CGSizeMake(145, 198);
}

#pragma mark - Paging

-(void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    if (collectionView.contentSize.height - [UIScreen mainScreen].bounds.size.height - 50.0 < scrollView.contentOffset.y) {
        // このタイミングでページングスタート
        if (!isLoading && self.type != DAAPIRequestTypeFavorite) {
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
