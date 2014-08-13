//
//  DACoreDataManager.h
//  Dribbble_App
//
//  Created by oda yuma on 2014/08/13.
//  Copyright (c) 2014年 yuma oda. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface DACoreDataManager : NSObject

@property (readonly, strong, nonatomic) NSManagedObjectContext *managedObjectContext;
@property (readonly, strong, nonatomic) NSManagedObjectModel *managedObjectModel;
@property (readonly, strong, nonatomic) NSPersistentStoreCoordinator *persistentStoreCoordinator;

+ (id)sharedManager;

- (void)saveContextCompletion:(void (^)(BOOL successFlg))completion;
- (NSURL *)applicationDocumentsDirectory;
- (NSManagedObjectContext *)managedObjectContext;

-(NSFetchRequest *)fetchRequest:(NSString *)entityName sortKey:(NSString *)key limit:(int)limit;
-(NSManagedObject *)entityForInsert:(NSString *)entityName;

//-(NSMutableArray *)all:(NSString *)entityName;
//-(NSMutableArray *)all:(NSString *)entityName sortKey:(NSString *)key;
//-(NSMutableArray *)fetch:(NSString *)entityName limit:(int)limit;
//-(NSMutableArray *)fetch:(NSString *)entityName sortKey:(NSString *)key limit:(int)limit;
//-(NSManagedObject *)entityForInsert:(NSString *)entityName;

@end
