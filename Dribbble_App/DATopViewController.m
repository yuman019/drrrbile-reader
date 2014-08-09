//
//  DATopViewController.m
//  Dribbble_App
//
//  Created by oda yuma on 2014/08/09.
//  Copyright (c) 2014年 yuma oda. All rights reserved.
//

#import "DATopViewController.h"
#import "DACollectionViewCell.h"

static NSString * const DACollectionViewCellIdentifier = @"Cell";

@interface DATopViewController ()

@end

@implementation DATopViewController
{
    UICollectionView *collectionView;
    NSMutableArray *shotsArray;
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
    
    shotsArray = [NSMutableArray array];
    [[DAAPIConnecter sharedManager] connectWithType:DAAPIRequestTypeEveryone pageCount:1 completion:^(BOOL successFlg, NSArray *array) {
        if (successFlg == NO) {
            NSLog(@"error");
        }else {
            [shotsArray addObjectsFromArray:array];
        }
    }];
    
}

-(void)settingCollectionView
{
    CHTCollectionViewWaterfallLayout *layout = [[CHTCollectionViewWaterfallLayout alloc] init];
    layout.sectionInset = UIEdgeInsetsMake(10, 10, 10, 10);
    layout.headerHeight = 15;
    layout.footerHeight = 10;
    layout.minimumColumnSpacing = 20;
    layout.minimumInteritemSpacing = 30;
    
    collectionView = [[UICollectionView alloc] initWithFrame:self.view.bounds collectionViewLayout:layout];
    collectionView.autoresizingMask = UIViewAutoresizingFlexibleHeight | UIViewAutoresizingFlexibleWidth;
    collectionView.dataSource = self;
    collectionView.delegate = self;
    [collectionView registerClass:[DACollectionViewCell class] forCellWithReuseIdentifier:DACollectionViewCellIdentifier];
    [collectionView registerNib:[UINib nibWithNibName:@"DACollectionViewCell" bundle:nil] forCellWithReuseIdentifier:DACollectionViewCellIdentifier];
    collectionView.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:collectionView];
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
    
    cell.backgroundColor = [UIColor greenColor];
    
    cell.mainImageView = (UIImageView *)[cell viewWithTag:1];
    cell.mainImageView.backgroundColor = [UIColor magentaColor];
    
    
    return cell;
}

#pragma mark - CHTCollectionViewDelegateWaterfallLayout

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
//    return [self.cellSizes[indexPath.item] CGSizeValue];
    return CGSizeMake(100, 100);
}

@end
