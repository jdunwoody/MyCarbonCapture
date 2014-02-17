//
//  Growth.h
//  MyCarbonCapture
//
//  Created by Dallas Johnson on 15/02/2014.
//  Copyright (c) 2014 Dallas Johnson. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class Tree;

@interface Growth : NSManagedObject

@property (nonatomic) float progress;
@property (nonatomic, retain) Tree *tree;

@end
