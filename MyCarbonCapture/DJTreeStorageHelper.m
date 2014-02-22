//
//  DJTreeStorageHelper.m
//  MyCarbonCapture
//
//  Created by Dallas Johnson on 22/02/2014.
//  Copyright (c) 2014 Dallas Johnson. All rights reserved.
//

#import "DJTreeStorageHelper.h"
#import "TreeStorage.h"

@implementation DJTreeStorageHelper
static NSString *TREE_STORAGE = @"TreeStorage";


+(TreeStorage*)treestorageforType:(TreeStorageUsageType)usageType inManagedObjectContext:(NSManagedObjectContext*)moc {
  NSFetchRequest *treeStorageReq = [NSFetchRequest fetchRequestWithEntityName:TREE_STORAGE];
  TreeStorage * treeStorage = [[[moc executeFetchRequest:treeStorageReq error:nil]
                                filteredArrayUsingPredicate:
                                [NSPredicate predicateWithFormat:@"SELF.useIdentifier == %d",usageType]] lastObject];
  if (!treeStorage) {
    treeStorage = [NSEntityDescription insertNewObjectForEntityForName:TREE_STORAGE inManagedObjectContext:moc];
    treeStorage.useIdentifier = usageType;
  }
  return treeStorage;
}


@end
