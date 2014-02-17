//
//  Bank.h
//  MyCarbonCapture
//
//  Created by Dallas Johnson on 15/02/2014.
//  Copyright (c) 2014 Dallas Johnson. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class Tree;

@interface Bank : NSManagedObject

@property (nonatomic, retain) NSOrderedSet *trees;
@end

@interface Bank (CoreDataGeneratedAccessors)

- (void)insertObject:(Tree *)value inTreesAtIndex:(NSUInteger)idx;
- (void)removeObjectFromTreesAtIndex:(NSUInteger)idx;
- (void)insertTrees:(NSArray *)value atIndexes:(NSIndexSet *)indexes;
- (void)removeTreesAtIndexes:(NSIndexSet *)indexes;
- (void)replaceObjectInTreesAtIndex:(NSUInteger)idx withObject:(Tree *)value;
- (void)replaceTreesAtIndexes:(NSIndexSet *)indexes withTrees:(NSArray *)values;
- (void)addTreesObject:(Tree *)value;
- (void)removeTreesObject:(Tree *)value;
- (void)addTrees:(NSOrderedSet *)values;
- (void)removeTrees:(NSOrderedSet *)values;
@end
