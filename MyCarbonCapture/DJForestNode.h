//
//  DJForestNode.h
//  MyCarbonCapture
//
//  Created by Dallas Johnson on 16/02/2014.
//  Copyright (c) 2014 Dallas Johnson. All rights reserved.
//

#import <SpriteKit/SpriteKit.h>
@class Tree;

@interface DJForestNode : SKSpriteNode
@property (nonatomic) BOOL isMoving;
@property (nonatomic,strong) Tree * tree;
+(instancetype)spriteNodeWithTree:(Tree*)tree;

@end
