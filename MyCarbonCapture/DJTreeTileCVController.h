//
//  DJTreeTileCVController.h
//
//  Created by Dallas Johnson on 1/12/2013.
//  Copyright (c) 2013 Dallas Johnson. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol DJTreeTileCVControllerDelegate <NSObject>
-(void)didIncreaseUsageStats:(long long)kilobytes;
-(void)didCompleteTree;
-(void)didResetStats;
//amount a tree has grown - 0: new tree 1: fully grown
-(void)treeDidGrowToAmount:(float)amount;

@end

#define TILES_ALPHA_KEY @"TileAlphas"


@interface DJTreeTileCVController : UICollectionViewController
@property (nonatomic,weak) id<DJTreeTileCVControllerDelegate> delegate;
@property (nonatomic,strong) NSManagedObjectContext * moc;

-(void)incrementWebUsageWithUsage:(long)usage;

@end
