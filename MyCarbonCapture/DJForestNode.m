//
//  DJForestNode.m
//  MyCarbonCapture
//
//  Created by Dallas Johnson on 16/02/2014.
//  Copyright (c) 2014 Dallas Johnson. All rights reserved.
//

#import "DJForestNode.h"


@implementation DJForestNode
#define LIFTING_OFFSET 5

+(instancetype)spriteNodeWithImageNamed:(NSString *)name {
  return [super spriteNodeWithImageNamed:name];
}


-(void)setPosition:(CGPoint)position {

  if (self.isMoving) {

    [self setZRotation:.1];
    position = CGPointMake(position.x, position.y + LIFTING_OFFSET);
  } else {
    [self setZRotation:0];
    position = CGPointMake(position.x, position.y - LIFTING_OFFSET);
  }
  CGFloat perpectiveFactor = (1- position.y / self.parent.frame.size.height) + 1;
  self.size = CGSizeApplyAffineTransform(CGSizeMake(25, 33),
                                         CGAffineTransformMakeScale(perpectiveFactor,
                                                                    perpectiveFactor));

  [super setPosition:position];
}

@end
