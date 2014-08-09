//
//  DAAPIConnecter.m
//  Dribbble_App
//
//  Created by oda yuma on 2014/08/09.
//  Copyright (c) 2014年 yuma oda. All rights reserved.
//

#import "DAAPIConnecter.h"
#import "DAShotsModel.h"

#import <AFNetworking.h>

@implementation DAAPIConnecter

static DAAPIConnecter *sharedObj = nil;

+(DAAPIConnecter *)sharedManager
{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedObj = [[DAAPIConnecter alloc] initSharedInstance];
    });
    return sharedObj;
}

-(id)initSharedInstance
{
    self = [super init];
    if (self) {
        //初期化処理
    }
    return self;
}

-(id)init
{
    //外部からinitメソッドが呼ばれたらエラーになるようにして、sharedManagerを呼ばずにインスタンスを生成してしまうのを防いでいます。
    //例外が投げられます(NSInvalidArgumentException)
    [self doesNotRecognizeSelector:_cmd];
    return nil;
}

#pragma mark - API

-(void)connectWithType:(DAAPIRequestType)type pageCount:(NSInteger)pageCount completion:(void (^)(BOOL successFlg, NSArray *array))completion
{
    NSString *actionStr = nil;
    switch (type) {
        case DAAPIRequestTypeEveryone:
            actionStr = API_DRIBBBLE_EVERYONE;
            break;
        case DAAPIRequestTypeDebuts:
            actionStr = API_DRIBBBLE_DEBUTS;
            break;
        case DAAPIRequestTypePopular:
            actionStr = API_DRIBBBLE_POPULAR;
            break;
        default:
            break;
    }
    NSString *requestURLStr = [NSString stringWithFormat:@"%@%@", API_DRIBBBLE_DOMAIN, actionStr];
    
    NSNumber *pageCountNum = [[NSNumber alloc] initWithInteger:pageCount];
    NSDictionary *parameters = @{@"page": pageCountNum};
    
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    [manager GET:requestURLStr
      parameters:parameters
         success:^(AFHTTPRequestOperation *operation, id responseObject) {
             // NSLog(@"success::%@", responseObject);
             NSMutableArray *shotsModelArray = [NSMutableArray array];
             [responseObject[@"shots"] enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
                 DAShotsModel *shotsModel = [DAShotsModel makesShotsModelWith:obj];
                 [shotsModelArray addObject:shotsModel];
             }];
             completion(YES, shotsModelArray);
         }
         failure:^(AFHTTPRequestOperation *operation, NSError *error) {
             NSLog(@"APIConnectFailure::%@", error.description);
             completion(NO, [NSArray array]);
         }];
}

@end
