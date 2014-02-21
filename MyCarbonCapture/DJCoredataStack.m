//
//  DJCoredataDocumnet.m
//  MyCarbonCapture
//
//  Created by Dallas Johnson on 15/02/2014.
//  Copyright (c) 2014 Dallas Johnson. All rights reserved.
//

#import "DJCoredataStack.h"

@implementation DJCoredataStack

static NSString * CARBON_CAPTURE_DATA_FILE = @"CarbonCaptureDataFile";
static NSString * CARBON_CAPTURE_MODEL_FILE = @"CarbonCaptureModel";


+(NSManagedObjectContext *)createNewCoreDataStack{
  DJCoredataStack* coreStack = [[self alloc] init];

  NSPersistentStoreCoordinator *coordinator = [coreStack persistentStoreCoordinator];

  if (coordinator != nil) {
    coreStack.moc = [[NSManagedObjectContext alloc] initWithConcurrencyType:NSMainQueueConcurrencyType];
    [coreStack.moc setPersistentStoreCoordinator:coordinator];
  }
  return coreStack.moc;
}

- (NSManagedObjectContext *)moc {
  if (_moc != nil) {
    return _moc;
  }
  NSPersistentStoreCoordinator *coordinator = [self persistentStoreCoordinator];
  if (coordinator != nil) {
    _moc = [[NSManagedObjectContext alloc] initWithConcurrencyType:NSMainQueueConcurrencyType];
    [_moc setPersistentStoreCoordinator:coordinator];
  }
  return _moc;
}

- (NSManagedObjectModel *)managedObjectModel {
  if (_managedObjectModel) return _managedObjectModel;

  NSString *modelPath = [[NSBundle mainBundle] pathForResource:CARBON_CAPTURE_MODEL_FILE ofType:@"momd"];
  NSURL *modelURL = [NSURL fileURLWithPath:modelPath];
  _managedObjectModel = [[NSManagedObjectModel alloc] initWithContentsOfURL:modelURL];
  return _managedObjectModel;
}


- (NSPersistentStoreCoordinator *)persistentStoreCoordinator {
  if (_persistentStoreCoordinator) return _persistentStoreCoordinator;

  NSString *applicationDocumentsDirectory = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) lastObject];
  NSURL *storeURL = [NSURL fileURLWithPath: [[applicationDocumentsDirectory stringByAppendingPathComponent: CARBON_CAPTURE_DATA_FILE] stringByAppendingPathExtension:@"sqlite"]];
  NSError *error = nil;
  NSDictionary *options = @{NSMigratePersistentStoresAutomaticallyOption : @YES,
                            NSInferMappingModelAutomaticallyOption : @YES};

  _persistentStoreCoordinator= [[NSPersistentStoreCoordinator alloc] initWithManagedObjectModel:[self managedObjectModel]];
  // if (![_persistentStoreCoordinator addPersistentStoreWithType:NSInMemoryStoreType configuration:nil URL:nil options:options error:&error]) {

    if (![_persistentStoreCoordinator addPersistentStoreWithType:NSSQLiteStoreType configuration:nil URL:storeURL options:options error:&error]) {
    NSLog(@"the migrated error is %@",error.userInfo);
    abort();
  }

  //Ensure the CoredataDB is encrypted
  [[NSFileManager defaultManager] setAttributes:@{NSFileProtectionKey: NSFileProtectionComplete} ofItemAtPath:[storeURL path] error:&error];

  return _persistentStoreCoordinator;
}


@end
