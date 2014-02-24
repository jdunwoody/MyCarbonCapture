//
//  Tree+_StorageType.h
//  MyCarbonCapture
//
//  Created by Dallas Johnson on 22/02/2014.
//  Copyright (c) 2014 Dallas Johnson. All rights reserved.
//

#import "Tree.h"

typedef enum {
  TreeStorageUsageTypeGrowth = 0,
  TreeStorageUsageTypeBank,
  TreeStorageUsageTypeForest
} TreeStorageUsageType;


@interface Tree (_StorageType)

@end
