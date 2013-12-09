//
//  DJLeavesCollectionViewLayout.m
//
//  Created by Dallas Johnson on 1/12/2013.
//  Copyright (c) 2013 Dallas Johnson. All rights reserved.
//

#import "DJLeavesCollectionViewLayout.h"

@interface DJLeavesCollectionViewLayout ()
@property (nonatomic,strong) UIDynamicAnimator * animator;
@property (nonatomic) BOOL runBefore;
@end

@implementation DJLeavesCollectionViewLayout


-(id)init {
  self = [super init];
  if (self) {
    self.minimumInteritemSpacing = 1;
    self.minimumLineSpacing = 1;
    self.itemSize = CGSizeMake(40,40);
    self.sectionInset = UIEdgeInsetsMake(0,14, 0, 14);
    self.animator = [[UIDynamicAnimator alloc] initWithCollectionViewLayout:self];
    self.runBefore = NO;
  }
  return self;
}

-(void)prepareLayout {
  [super prepareLayout];
  CGSize contentSize = self.collectionView.contentSize;
  NSArray *items = [super layoutAttributesForElementsInRect:CGRectMake(0, 0, contentSize.width, contentSize.height)];
  if (self.animator.behaviors.count == 0) {
    [items enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
      if(self.runBefore) {
      [(UICollectionViewLayoutAttributes*)obj setAlpha:.1];
    }
      UIAttachmentBehavior *behaviour = [[UIAttachmentBehavior alloc] initWithItem:obj attachedToAnchor:[obj center]];

      behaviour.length = 1.0f;
      behaviour.damping = 0.25f;
      behaviour.frequency = 2.70f;
      [self.animator addBehavior:behaviour];
    }];
    self.runBefore = YES;
  }
}

-(NSArray *)layoutAttributesForElementsInRect:(CGRect)rect {
  return [self.animator itemsInRect:rect];
}

-(UICollectionViewLayoutAttributes *)layoutAttributesForItemAtIndexPath:(NSIndexPath *)indexPath {
  return [self.animator layoutAttributesForCellAtIndexPath:indexPath];
}


-(BOOL)shouldInvalidateLayoutForBoundsChange:(CGRect)newBounds {

  UIScrollView *scrollView = self.collectionView;
  CGFloat delta = newBounds.origin.y - scrollView.bounds.origin.y;

  CGPoint touchLocation = [self.collectionView.panGestureRecognizer locationInView:self.collectionView];
  //Handleing the progressive affect of dragging for each cell that is further away from the pan touch point.
  [self.animator.behaviors enumerateObjectsUsingBlock:^(UIAttachmentBehavior *springBehaviour, NSUInteger idx, BOOL *stop) {
    CGFloat yDistFromTouch = fabsf(touchLocation.y - springBehaviour.anchorPoint.y);
    CGFloat xDistFromTouch = fabsf(touchLocation.x - springBehaviour.anchorPoint.x);
    CGFloat scrollRestistance = (yDistFromTouch + xDistFromTouch) / 1000.0f;
    UICollectionViewLayoutAttributes *item = springBehaviour.items.firstObject;
    CGPoint center = item.center;
    if (delta < 0) {
      center.y += MAX(delta, delta * scrollRestistance);
    } else {
      center.y += MIN(delta, delta * scrollRestistance);
    }
    item.center = center;
    [self.animator updateItemUsingCurrentState:item];
  }];

  return NO;
  
}


@end
