//
//  DJTreeTileCVController.h
//
//  Created by Dallas Johnson on 1/12/2013.
//  Copyright (c) 2013 Dallas Johnson. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol DJTreeTileCVControllerDelegate <NSObject>
-(void)didIncreaseUsageStats:(long long)kilobytes;
-(void)didReachMaxStats;
-(void)didResetStats;

@end


@interface DJTreeTileCVController : UICollectionViewController
@property (nonatomic,weak) id<DJTreeTileCVControllerDelegate> delegate;
@property ( nonatomic,strong) NSManagedObjectContext * moc;

@end
