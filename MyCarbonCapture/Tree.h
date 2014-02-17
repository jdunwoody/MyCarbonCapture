//
//  Tree.h
//  MyCarbonCapture
//
//  Created by Dallas Johnson on 15/02/2014.
//  Copyright (c) 2014 Dallas Johnson. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class Bank, Growth, PlantedObject;

@interface Tree : NSManagedObject

@property (nonatomic, retain) NSString * name;
@property (nonatomic, retain) NSString * info;
@property (nonatomic, retain) id image;
@property (nonatomic, retain) NSSet *location;
@property (nonatomic, retain) Bank *bank;
@property (nonatomic, retain) Growth *growth;
@end

@interface Tree (CoreDataGeneratedAccessors)

- (void)addLocationObject:(PlantedObject *)value;
- (void)removeLocationObject:(PlantedObject *)value;
- (void)addLocation:(NSSet *)values;
- (void)removeLocation:(NSSet *)values;

@end
