//
//  DAShotsModel.m
//  Dribbble_App
//
//  Created by oda yuma on 2014/08/09.
//  Copyright (c) 2014年 yuma oda. All rights reserved.
//

#import "DAShotsModel.h"
#import <SDWebImage/UIImageView+WebCache.h>

@implementation DAShotsModel

-(id)init
{
    self = [super init];
    if (self) {
    }
    return self;
}

+ (DAShotsModel *)makesShotsModelWith:(NSDictionary *)dictionary
{
    DAShotsModel *shotsModel = [[DAShotsModel alloc] init];
    shotsModel.titleStr = dictionary[@"title"];
    shotsModel.likesCountStr = dictionary[@"likes_count"];
    shotsModel.viewsCountStr = dictionary[@"views_count"];
    shotsModel.imageURLStr = dictionary[@"image_url"];
    shotsModel.descriptionStr = dictionary[@"description"];
    shotsModel.usernameStr = dictionary[@"player"][@"username"];
    shotsModel.nameStr = dictionary[@"player"][@"name"];
    shotsModel.avatarURLStr = dictionary[@"player"][@"avatar_url"];
    
    return shotsModel;
}

-(void)getImageDataWithURLString:(NSString *)URLString
{
    
}

@end
