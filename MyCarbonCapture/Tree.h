//
//  Tree.h
//  MyCarbonCapture
//
//  Created by Dallas Johnson on 22/02/2014.
//  Copyright (c) 2014 Dallas Johnson. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>


@interface Tree : NSManagedObject

@property (nonatomic, retain) UIImage* image;
@property (nonatomic, retain) NSString * info;
@property (nonatomic, retain) NSString * name;
@property (nonatomic) float x;
@property (nonatomic) float y;
@property (nonatomic) int16_t useIdentifier;
@property (nonatomic, retain) UIImage* largeImage;

@end
