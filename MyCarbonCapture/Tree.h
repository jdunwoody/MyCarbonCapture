//
//  Tree.h
//  MyCarbonCapture
//
//  Created by Dallas Johnson on 11/04/2014.
//  Copyright (c) 2014 Dallas Johnson. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>


@interface Tree : NSManagedObject

@property (nonatomic, retain) UIImage* image;
@property (nonatomic, retain) NSString * info;
@property (nonatomic, retain) UIImage* largeImage;
@property (nonatomic, retain) NSString * name;
@property (nonatomic) int16_t useIdentifier;
@property (nonatomic) float x;
@property (nonatomic) float y;
@property (nonatomic, retain) UIImage* imageHover;

@end
