//
//  Shot.h
//  Dribbble_App
//
//  Created by oda yuma on 2014/08/13.
//  Copyright (c) 2014年 yuma oda. All rights reserved.
//

#import <CoreData/CoreData.h>

@class Player;

@interface Shot : NSManagedObject

@property (nonatomic, retain) NSString *title;
@property (nonatomic, retain) NSNumber *likesCount;
@property (nonatomic, retain) NSNumber *viewsCount;
@property (nonatomic, retain) NSString *imageURL;
@property (nonatomic, retain) NSString *desc;
@property (nonatomic, retain) NSNumber *width;
@property (nonatomic, retain) NSNumber *height;
@property (nonatomic, retain) Player *player;

@end
