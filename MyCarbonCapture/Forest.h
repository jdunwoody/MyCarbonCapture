//
//  Forest.h
//  MyCarbonCapture
//
//  Created by Dallas Johnson on 15/02/2014.
//  Copyright (c) 2014 Dallas Johnson. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class PlantedObject;

@interface Forest : NSManagedObject

@property (nonatomic, retain) NSSet *plantedObjects;
@end

@interface Forest (CoreDataGeneratedAccessors)

- (void)addPlantedObjectsObject:(PlantedObject *)value;
- (void)removePlantedObjectsObject:(PlantedObject *)value;
- (void)addPlantedObjects:(NSSet *)values;
- (void)removePlantedObjects:(NSSet *)values;

@end
