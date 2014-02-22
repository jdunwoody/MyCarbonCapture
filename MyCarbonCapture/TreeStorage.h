//
//  TreeStorage.h
//  MyCarbonCapture
//
//  Created by Dallas Johnson on 22/02/2014.
//  Copyright (c) 2014 Dallas Johnson. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class Tree;

@interface TreeStorage : NSManagedObject

@property (nonatomic) float progress;
@property (nonatomic) int16_t useIdentifier;
@property (nonatomic, retain) NSSet *tree;
@end

@interface TreeStorage (CoreDataGeneratedAccessors)

- (void)addTreeObject:(Tree *)value;
- (void)removeTreeObject:(Tree *)value;
- (void)addTree:(NSSet *)values;
- (void)removeTree:(NSSet *)values;

@end
