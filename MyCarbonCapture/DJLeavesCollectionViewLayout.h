//
//  DJLeavesCollectionViewLayout.h
//
//  Created by Dallas Johnson on 1/12/2013.
//  Copyright (c) 2013 Dallas Johnson. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface DJLeavesCollectionViewLayout : UICollectionViewFlowLayout
@property (nonatomic,strong) NSIndexPath *highlightledIndexPath;
@property (nonatomic, strong) NSIndexPath *prevHighlight;
@property (nonatomic, strong) UIDynamicAnimator * animator;


-(void) highlightAttributes:(UICollectionViewLayoutAttributes*) attr;
-(void)unhighlightAttributes:(UICollectionViewLayoutAttributes*)attr;

@end
