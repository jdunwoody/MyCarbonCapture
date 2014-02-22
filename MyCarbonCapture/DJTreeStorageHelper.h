//
//  DJTreeStorageHelper.h
//  MyCarbonCapture
//
//  Created by Dallas Johnson on 22/02/2014.
//  Copyright (c) 2014 Dallas Johnson. All rights reserved.
//
@class TreeStorage;
#import <Foundation/Foundation.h>
typedef enum {
  TreeStorageUsageTypeGrowth = 0,
  TreeStorageUsageTypeBank,
  TreeStorageUsageTypeForest
} TreeStorageUsageType;

@interface DJTreeStorageHelper : NSObject

@property (nonatomic,strong) NSManagedObjectContext *moc;


+(TreeStorage*)treestorageforType:(TreeStorageUsageType)usageType inManagedObjectContext:(NSManagedObjectContext*)moc;

@end
