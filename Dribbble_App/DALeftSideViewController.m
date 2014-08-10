//
//  DALeftSideViewController.m
//  Dribbble_App
//
//  Created by oda yuma on 2014/08/10.
//  Copyright (c) 2014年 yuma oda. All rights reserved.
//

#import "DALeftSideViewController.h"
#import "JASidePanelController.h"
#import "UIViewController+JASidePanel.h"
#import "DATopViewController.h"

@interface DALeftSideViewController ()
<UITableViewDataSource, UITableViewDelegate>

@end

@implementation DALeftSideViewController
{
    NSArray *selectionArray;
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
    
    self.title = @"Menu";
    //self.navigationItem
    
    UIView *statusView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 320, 20)];
    statusView.backgroundColor = COLOR_PINK;
    [self.view addSubview:statusView];
    
    selectionArray = @[@"Everyone", @"Debuts", @"Popular"];
    
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    self.tableView.contentInset = UIEdgeInsetsMake(20, 0, 0, 0);
    self.tableView.backgroundColor = COLOR_DARK;
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    // self.label.center = CGPointMake(floorf(self.sidePanelController.leftVisibleWidth/2.0f), 25.0f);
}

#pragma mark - UITableViewDataSource

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return selectionArray.count;
}

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (!cell) {
        // 再利用できない場合は新規で作成
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
    }
    cell.backgroundColor = COLOR_PINK;
    
    cell.textLabel.textColor = [UIColor whiteColor];
    cell.textLabel.text = selectionArray[indexPath.row];
    
    return cell;
}

#pragma mark - UITableViewDelegate

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    DATopViewController *topVC = [[DATopViewController alloc] initWithNibName:@"DATopViewController" bundle:nil];
    switch (indexPath.row) {
        case 0:
            topVC.type = DAAPIRequestTypeEveryone;
            break;
        case 1:
            topVC.type = DAAPIRequestTypeDebuts;
            break;
        case 2:
            topVC.type = DAAPIRequestTypePopular;
            break;
        default:
            break;
    }
    self.sidePanelController.centerPanel = [[UINavigationController alloc] initWithRootViewController:topVC];
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 50;
}

@end
