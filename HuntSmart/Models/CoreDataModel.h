//
//  CoreDataModel.h
//  HuntSmart
//
//  Created by Wildlife Management Services on 5/11/18.
//  Copyright © 2018 Wildlife Management Services. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

#import "Weather.h"


@interface CoreDataModel : NSObject

+ (nonnull instancetype)sharedInstance;

@property (strong, nonatomic) NSManagedObjectContext *managedObjectContext;
@property (strong, nonatomic) NSManagedObjectModel *managedObjectModel;
@property (strong, nonatomic) NSPersistentStoreCoordinator *persistentStoreCoordinator;

- (NSURL *)applicationDocumentsDirectory;
- (void)saveContext;

- (id)insertItem:(NSString *)name;
- (BOOL)saveData;
- (void)removeData:(NSManagedObject *)item;

- (id)getData:(NSString *)name sortKey:(NSString *)key ascending:(BOOL)ascending;
- (id)getData:(NSString *)name predicate:(NSPredicate *)predicate sortKey:(NSString *)key ascending:(BOOL)ascending;
- (NSUInteger)getCount:(NSString *)name predicate:(NSPredicate *)predicate;
- (id)getFirstOrLast:(NSString *)name predicate:(NSPredicate *)predicate isFirst:(BOOL)isFirst;

- (WeatherModel *)saveWeather:(Weather *)weather;

@end
