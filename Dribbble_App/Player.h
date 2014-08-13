//
//  Player.h
//  Dribbble_App
//
//  Created by oda yuma on 2014/08/13.
//  Copyright (c) 2014年 yuma oda. All rights reserved.
//

#import <CoreData/CoreData.h>

@interface Player : NSManagedObject

@property (nonatomic, retain) NSString *username;
@property (nonatomic, retain) NSString *name;
@property (nonatomic, retain) NSString *avatarURL;

@end
