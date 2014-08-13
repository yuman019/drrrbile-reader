//
//  DAAPIConnecter.h
//  Dribbble_App
//
//  Created by oda yuma on 2014/08/09.
//  Copyright (c) 2014年 yuma oda. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef NS_ENUM(NSInteger, DAAPIRequestType) {
    DAAPIRequestTypeEveryone,
    DAAPIRequestTypeDebuts,
    DAAPIRequestTypePopular,
    DAAPIRequestTypeFavorite
};

@interface DAAPIConnecter : NSObject

+(DAAPIConnecter *)sharedManager;
-(void)connectWithType:(DAAPIRequestType)type pageCount:(NSInteger)pageCount completion:(void (^)(BOOL successFlg, NSArray *array))completion;

@end
