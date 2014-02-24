//
//  DJForestNode.m
//  MyCarbonCapture
//
//  Created by Dallas Johnson on 16/02/2014.
//  Copyright (c) 2014 Dallas Johnson. All rights reserved.
//

#import "DJForestNode.h"
#import "Tree+_StorageType.h"


@implementation DJForestNode
#define LIFTING_OFFSET 5

+(instancetype)spriteNodeWithImageNamed:(NSString *)name {
  return [super spriteNodeWithImageNamed:name];
}

+(instancetype)spriteNodeWithTree:(Tree*)tree{
  DJForestNode* treeNode = [super spriteNodeWithTexture:[SKTexture textureWithImage:tree.image]];
  treeNode.tree = tree;
  return treeNode;
}

-(void)setPosition:(CGPoint)position {
  if (self.isMoving) {

    [self setZRotation:.1];
    position = CGPointMake(position.x, position.y + LIFTING_OFFSET);
  } else {
    [self setZRotation:0];
    position = CGPointMake(position.x, position.y - LIFTING_OFFSET);
    self.tree.x = position.x;
    self.tree.y = position.y;
    self.tree.useIdentifier = TreeStorageUsageTypeForest;
    NSError * error = nil;

    [self.tree.managedObjectContext save:&error];
  }
  CGFloat frameHeight = self.parent.frame.size.height;
  
  CGFloat perspectiveFactor = (1 - ((position.y - frameHeight / 2) / frameHeight)*2);
  self.size = CGSizeApplyAffineTransform(CGSizeMake(25, 33),
                                         CGAffineTransformMakeScale(perspectiveFactor,
                                                                    perspectiveFactor));

  [super setPosition:position];
}

@end
