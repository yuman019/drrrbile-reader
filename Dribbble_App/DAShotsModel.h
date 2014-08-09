//
//  DAShotsModel.h
//  Dribbble_App
//
//  Created by oda yuma on 2014/08/09.
//  Copyright (c) 2014年 yuma oda. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface DAShotsModel : NSObject

+ (DAShotsModel *)makesShotsModelWith:(NSDictionary *)dictionary;

@property (nonatomic) NSString *titleStr;
@property (nonatomic) NSString *likesCountStr;
@property (nonatomic) NSString *viewsCountStr;
@property (nonatomic) NSString *imageURLStr;
@property (nonatomic) NSString *descriptionStr;
@property (nonatomic) NSString *usernameStr;
@property (nonatomic) NSString *nameStr;
@property (nonatomic) NSString *avatarURLStr;

@end
