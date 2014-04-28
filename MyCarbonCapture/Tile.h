//
//  Tile.h
//  MyCarbonCapture
//
//  Created by Dallas Johnson on 24/04/2014.
//  Copyright (c) 2014 Dallas Johnson. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>


@interface Tile : NSManagedObject

@property (nonatomic) int16_t index;
@property (nonatomic) float alpha;

@end
