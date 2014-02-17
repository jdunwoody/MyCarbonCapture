//
//  DJForest.m
//  SpritePlay
//
//  Created by Dallas Johnson on 16/02/2014.
//  Copyright (c) 2014 Dallas. All rights reserved.
//

#import "DJForestScene.h"
#import "DJForestNode.h"

@interface DJForestScene ()
-(void)createContents;
@property (nonatomic,strong) DJForestNode * selectedNode;
@end

@implementation DJForestScene

-(void)didMoveToView:(SKView *)view{
  self.backgroundColor = [SKColor brownColor];
  self.scaleMode = SKSceneScaleModeAspectFill;
  [self createContents];
}


-(void)createContents {

}

-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
  for (UITouch * touch in touches) {

    self.selectedNode = [DJForestNode spriteNodeWithImageNamed:@"MCC_BankTree#1"];
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
  }
}

@end
