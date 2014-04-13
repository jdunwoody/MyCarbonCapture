//
//  DJForest.m
//  SpritePlay
//
//  Created by Dallas Johnson on 16/02/2014.
//  Copyright (c) 2014 Dallas. All rights reserved.
//

#import "DJForestScene.h"
#import "DJForestNode.h"
#import "Tree+_StorageType.h"

@interface DJForestScene ()
-(void)createContents;
@property (nonatomic,strong) DJForestNode * selectedNode;
@end

@implementation DJForestScene

-(void)didMoveToView:(SKView *)view{
  SKSpriteNode * baseView = [SKSpriteNode spriteNodeWithImageNamed:@"Base3" ];
  [baseView setAnchorPoint:CGPointMake(0, 0)];
  [self addChild:baseView];
  baseView.position = CGPointMake(0, 0);

  SKSpriteNode * hill1 = [SKSpriteNode spriteNodeWithImageNamed:@"Hill1-2" ];
  [hill1 setAnchorPoint:CGPointMake(0, 0)];
  [self addChild:hill1];
  hill1.position = CGPointMake(0, 82);

  SKSpriteNode * hill2 = [SKSpriteNode spriteNodeWithImageNamed:@"Hill2-2" ];
  [hill2 setAnchorPoint:CGPointMake(0, 0)];
  [self addChild:hill2];
  hill2.position = CGPointMake(0, 83+50);

  SKSpriteNode * hill3 = [SKSpriteNode spriteNodeWithImageNamed:@"Hill3-2" ];
  [hill3 setAnchorPoint:CGPointMake(0, 0)];
  [self addChild:hill3];
  hill3.position = CGPointMake(0, 83+50+105);

  SKSpriteNode * hill4 = [SKSpriteNode spriteNodeWithImageNamed:@"Hill4-2" ];
  [hill4 setAnchorPoint:CGPointMake(0, 0)];
  [self addChild:hill4];
  hill4.position = CGPointMake(0, 83+50+106+58);


  SKSpriteNode * sky = [SKSpriteNode spriteNodeWithImageNamed:@"Skytint2"];
  [sky setAnchorPoint:CGPointMake(0, 0)];
  [self addChild:sky];
  sky.position = CGPointMake(0, 83+50+106+58+28);



  self.scaleMode = SKSceneScaleModeAspectFill;
  [self createContents];
}


-(void)createContents {
  NSError * error = nil;
  NSFetchRequest *req = [[NSFetchRequest alloc] initWithEntityName:@"Tree"];
  req.predicate = [NSPredicate predicateWithFormat:@"useIdentifier == %d",TreeStorageUsageTypeForest];
  [[self.moc executeFetchRequest:req error:&error]
   enumerateObjectsUsingBlock:^(Tree* tree, NSUInteger idx, BOOL *stop) {
     DJForestNode * node = [DJForestNode spriteNodeWithTree:tree];
     [self addChild:node];
     [node setPosition:CGPointMake(tree.x, tree.y)];
   }];
}

-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
  //remove from the pending collection

  //Add a tree to the touch point location
  NSError *error = nil;
  NSFetchRequest *treeRequest = [[NSFetchRequest alloc] initWithEntityName:@"Tree"];
  treeRequest.predicate = [NSPredicate predicateWithFormat:@"useIdentifier == %d",TreeStorageUsageTypeBank];
  Tree * treeToPlant = [[self.moc executeFetchRequest:treeRequest error:&error] lastObject];
  if (!treeToPlant) {
    self.selectedNode = nil;
    return;
  }
  for (UITouch * touch in touches) {
    self.selectedNode = [DJForestNode spriteNodeWithTree:treeToPlant];
    [self addChild:self.selectedNode];
    self.selectedNode.isMoving = YES;
    CGPoint touchLoc = [touch locationInNode:self];
    self.selectedNode.position = touchLoc;
  }
}

-(void)touchesMoved:(NSSet *)touches withEvent:(UIEvent *)event{
  for (UITouch * touch in touches) {
    CGPoint touchLoc = [touch locationInNode:self];
    self.selectedNode.position = touchLoc;
  }
}



-(void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event {
  for (UITouch * touch in touches) {
    self.selectedNode.isMoving = NO;
    CGPoint touchLoc = [touch locationInNode:self];
    self.selectedNode.position = touchLoc;
    [self.delegate forestDidUpdateTreeCollection];
  }
}

@end
