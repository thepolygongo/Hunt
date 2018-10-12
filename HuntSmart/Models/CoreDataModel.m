//
//  CoreDataModel.m
//  HuntSmart
//
//  Created by Wildlife Management Services on 5/11/18.
//  Copyright © 2018 Wildlife Management Services. All rights reserved.
//

#import "CoreDataModel.h"

static CoreDataModel *modelInstance;

@implementation CoreDataModel

+ (nonnull instancetype)sharedInstance {
    if (modelInstance == nil) {
        modelInstance = [CoreDataModel new];
    }
    return modelInstance;
}

#pragma mark - Core Data Stack

- (NSURL *)applicationDocumentsDirectory {
    // The directory the application uses to store the Core Data store file. This code uses a directory named "com.mindstick.CoreDataSample" in the application's documents directory.
    return [[NSFileManager defaultManager] containerURLForSecurityApplicationGroupIdentifier:@"group.com.bruckmedia.SCOOTER"];
}

- (NSManagedObjectModel *)managedObjectModel {
    // The managed object model for the application. It is a fatal error for the application not to be able to find and load its model.
    if (_managedObjectModel != nil) {
        return _managedObjectModel;
    }
    NSURL *modelURL = [[NSBundle mainBundle] URLForResource:@"HuntSmart" withExtension:@"momd"];
    _managedObjectModel = [[NSManagedObjectModel alloc] initWithContentsOfURL:modelURL];
    return _managedObjectModel;
}

- (NSPersistentStoreCoordinator*)persistentStoreCoordinator {
    // The persistent store coordinator for the application. This implementation creates and returns a coordinator, having added the store for the application to it.
    if (_persistentStoreCoordinator != nil) {
        return _persistentStoreCoordinator;
    }
    
    // Create the coordinator and store
    _persistentStoreCoordinator = [[NSPersistentStoreCoordinator alloc] initWithManagedObjectModel:[self managedObjectModel]];
    NSURL *storeURL = [[self applicationDocumentsDirectory] URLByAppendingPathComponent:@"HuntSmart.sqlite"];
    NSError *error = nil;
    NSString *failureReason = @"There was an error creating or loading the application's saved data.";
    
    NSDictionary *options = @{
                              NSMigratePersistentStoresAutomaticallyOption : @YES,
                              NSInferMappingModelAutomaticallyOption : @YES
                              };
    if (![_persistentStoreCoordinator addPersistentStoreWithType:NSSQLiteStoreType configuration:nil URL:storeURL options:options error:&error]) {
        // Report any error we got.
        NSMutableDictionary *dict = [NSMutableDictionary dictionary];
        dict[NSLocalizedDescriptionKey] = @"Failed to initialize the application's saved data";
        dict[NSLocalizedFailureReasonErrorKey] = failureReason;
        dict[NSUnderlyingErrorKey] = error;
        error = [NSError errorWithDomain:@"YOUR_ERROR_DOMAIN" code:9999 userInfo:dict];
        // Replace this with code to handle the error appropriately.
        // abort() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
        NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
        abort();
    }
    
    return _persistentStoreCoordinator;
}

- (NSManagedObjectContext *)managedObjectContext {
    // Returns the managed object context for the application (which is already bound to the persistent store coordinator for the application.)
    if (_managedObjectContext != nil) {
        return _managedObjectContext;
    }
    
    NSPersistentStoreCoordinator *coordinator = [self persistentStoreCoordinator];
    if (!coordinator) {
        return nil;
    }
    _managedObjectContext = [[NSManagedObjectContext alloc] initWithConcurrencyType:NSMainQueueConcurrencyType];
    [_managedObjectContext setPersistentStoreCoordinator:coordinator];
    return _managedObjectContext;
}

#pragma mark - Core Data Saving support

- (void)saveContext {
    NSManagedObjectContext
    *managedObjectContext = self.managedObjectContext;
    if (managedObjectContext != nil) {
        NSError *error = nil;
        if ([managedObjectContext hasChanges] && ![managedObjectContext save:&error]) {
            // Replace this implementation with code to handle the error appropriately.
            // abort() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
            NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
            abort();
        }
    }
}

#pragma mark - Core Data Saving support

- (id)insertItem:(NSString *)name {
    NSManagedObjectContext *moc = CoreDataModel.sharedInstance.managedObjectContext;
    id item = [NSEntityDescription insertNewObjectForEntityForName:name inManagedObjectContext:moc];
    return item;
}

- (BOOL)saveData {
    NSManagedObjectContext *moc = CoreDataModel.sharedInstance.managedObjectContext;
    NSError *error;
    BOOL isSuccess = [moc save:&error];
    if (!isSuccess) {
        // Something's gone seriously wrong
        NSLog(@"Error saving new object: %@", [error localizedDescription]);
    }
    return isSuccess;
}

- (void)removeData:(NSManagedObject *)item {
    NSManagedObjectContext *moc = CoreDataModel.sharedInstance.managedObjectContext;
    [moc deleteObject:item];
    [moc save:nil];
}

- (id)getData:(NSString *)name sortKey:(NSString *)key ascending:(BOOL)ascending {
    NSManagedObjectContext *moc = CoreDataModel.sharedInstance.managedObjectContext;
    NSEntityDescription *entity = [NSEntityDescription entityForName:name inManagedObjectContext:moc];
    NSFetchRequest *request = [[NSFetchRequest alloc] init];
    [request setEntity:entity];
    
    // sort records
    if (key) {
        NSSortDescriptor *sortDescriptor = [[NSSortDescriptor alloc] initWithKey:key ascending:ascending];
        NSArray *sortDescriptors = [NSArray arrayWithObject:sortDescriptor];
        [request setSortDescriptors:sortDescriptors];
    }
    
    // Fetch the records and handle an error
    NSError *error;
    id data = [[moc executeFetchRequest:request error:&error] mutableCopy];
    
    return data;
}

- (id)getData:(NSString *)name predicate:(NSPredicate *)predicate sortKey:(NSString *)key ascending:(BOOL)ascending {
    NSManagedObjectContext *moc = CoreDataModel.sharedInstance.managedObjectContext;
    NSEntityDescription *entity = [NSEntityDescription entityForName:name inManagedObjectContext:moc];
    NSFetchRequest *request = [[NSFetchRequest alloc] init];
    [request setEntity:entity];
    
    // filter records
    [request setPredicate:predicate];
    
    // sort records
    if (key) {
        NSSortDescriptor *sortDescriptor = [[NSSortDescriptor alloc] initWithKey:key ascending:ascending];
        NSArray *sortDescriptors = [NSArray arrayWithObject:sortDescriptor];
        [request setSortDescriptors:sortDescriptors];
    }
    
    // Fetch the records and handle an error
    NSError *error;
    id data = [[moc executeFetchRequest:request error:&error] mutableCopy];
    
    return data;
}

- (NSUInteger)getCount:(NSString *)name predicate:(NSPredicate *)predicate {
    NSManagedObjectContext *moc = CoreDataModel.sharedInstance.managedObjectContext;
    NSEntityDescription *entity = [NSEntityDescription entityForName:name inManagedObjectContext:moc];
    NSFetchRequest *request = [[NSFetchRequest alloc] init];
    [request setEntity:entity];
    
    // filter records
    [request setPredicate:predicate];
    
    // get records count
    NSError *err;
    NSUInteger count = [moc countForFetchRequest:request error:&err];
    if (count == NSNotFound) {
        //Handle error
        return 0;
    }
    return count;
}

- (id)getFirstOrLast:(NSString *)name predicate:(NSPredicate *)predicate isFirst:(BOOL)isFirst {
    NSManagedObjectContext *moc = CoreDataModel.sharedInstance.managedObjectContext;
    NSEntityDescription *entity = [NSEntityDescription entityForName:name inManagedObjectContext:moc];
    NSFetchRequest *request = [[NSFetchRequest alloc] init];
    [request setEntity:entity];
    
    // filter records
    [request setFetchLimit:1];
    [request setPredicate:predicate];
    
    // sort records
    NSSortDescriptor *sortDescriptor = [[NSSortDescriptor alloc] initWithKey:@"createdAt" ascending:isFirst];
    NSArray *sortDescriptors = [NSArray arrayWithObject:sortDescriptor];
    [request setSortDescriptors:sortDescriptors];
    
    // Fetch the records and handle an error
    NSError *error;
    NSArray<id> *data = [[moc executeFetchRequest:request error:&error] mutableCopy];
    
    if (data && data.count > 0) {
        return data[0];
    }
    return nil;
}

- (WeatherModel *)saveWeather:(Weather *)weather {
    WeatherModel *model = [self insertItem:@"WeatherModel"];
    
    model.camera = weather.camera;
    model.image = weather.image;
    
    model.timezone = weather.timezone;
    model.icon = weather.icon;
    model.offset = weather.offset;
    
    model.temperature = weather.temperature;
    model.humidity = weather.humidity;
    model.pressure = weather.pressure;
    model.moonPhase = weather.moonPhase;
    model.windSpeed = weather.windSpeed;
    model.windBearing = weather.windBearing;
    model.sunriseTime = weather.sunriseTime;
    model.sunsetTime = weather.sunsetTime;
    model.moonrise = weather.moonrise;
    model.moonset = weather.moonset;
    model.moonover = weather.moonover;
    
    [self saveData];
    
    return model;
}

@end
