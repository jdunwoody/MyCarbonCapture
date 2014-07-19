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
  NSString *whichColour = @"colour"/*@"grey"*/;
  SKSpriteNode * baseView = [SKSpriteNode spriteNodeWithImageNamed:[NSString stringWithFormat:@"MCC-%@-hill-base",whichColour]];
  [baseView setAnchorPoint:CGPointMake(0, 0)];
  [self addChild:baseView];
  baseView.position = CGPointMake(0, 0);

  SKSpriteNode * hill1 = [SKSpriteNode spriteNodeWithImageNamed:[NSString stringWithFormat:@"MCC-%@-hill-1",whichColour] ];
  [hill1 setAnchorPoint:CGPointMake(0, 0)];
  [self addChild:hill1];
  hill1.position = CGPointMake(0, 85);

  SKSpriteNode * hill2 = [SKSpriteNode spriteNodeWithImageNamed:[NSString stringWithFormat:@"MCC-%@-hill-2",whichColour] ];
  [hill2 setAnchorPoint:CGPointMake(0, 0)];
  [self addChild:hill2];
  hill2.position = CGPointMake(0, 85+50);

  SKSpriteNode * hill3 = [SKSpriteNode spriteNodeWithImageNamed:[NSString stringWithFormat:@"MCC-%@-hill-3",whichColour] ];
  [hill3 setAnchorPoint:CGPointMake(0, 0)];
  [self addChild:hill3];
  hill3.position = CGPointMake(0, 85+50+85);

  SKSpriteNode * hill4 = [SKSpriteNode spriteNodeWithImageNamed:[NSString stringWithFormat:@"MCC-%@-hill-4",whichColour] ];
  [hill4 setAnchorPoint:CGPointMake(0, 0)];
  [self addChild:hill4];
  hill4.position = CGPointMake(0, 85+50+85+58);


  SKSpriteNode * sun = [SKSpriteNode spriteNodeWithImageNamed:[NSString stringWithFormat:@"MCC-%@-landscape-sun",whichColour]];
  [sun setAnchorPoint:CGPointMake(0, 0)];
  [self addChild:sun];
  sun.position = CGPointMake(230, 85+50+85+58+170);



  self.scaleMode = SKSceneScaleModeAspectFill;
  [self createContents];
}


-(void)createContents {
  self.backgroundColor = [UIColor whiteColor];
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
