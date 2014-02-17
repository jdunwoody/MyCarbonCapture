//
//  PlantedObject.h
//  MyCarbonCapture
//
//  Created by Dallas Johnson on 15/02/2014.
//  Copyright (c) 2014 Dallas Johnson. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class Forest, Tree;

@interface PlantedObject : NSManagedObject

@property (nonatomic) float x;
@property (nonatomic) float y;
@property (nonatomic, retain) Tree *tree;
@property (nonatomic, retain) Forest *forest;

@end
