//
//  DJCoredataDocumnet.h
//  MyCarbonCapture
//
//  Created by Dallas Johnson on 15/02/2014.
//  Copyright (c) 2014 Dallas Johnson. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface DJCoredataStack : NSObject

@property (nonatomic,strong) NSManagedObjectContext *moc;
@property (nonatomic,strong) NSManagedObjectModel *managedObjectModel;
@property (nonatomic,strong) NSPersistentStoreCoordinator *persistentStoreCoordinator;

+(NSManagedObjectContext *)createNewCoreDataStack;

@end
