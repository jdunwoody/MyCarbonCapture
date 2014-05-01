//
//  DJBankViewController.h
//  MyCarbonCapture
//
//  Created by Dallas Johnson on 19/02/2014.
//  Copyright (c) 2014 Dallas Johnson. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface DJBankViewController : UICollectionViewController <NSFetchedResultsControllerDelegate, UICollectionViewDataSource, UICollectionViewDelegate>
@property (nonatomic,strong) NSManagedObjectContext *moc;
@property(nonatomic,strong) NSFetchedResultsController * frc;

-(void)refreshBankViewCollection;

-(id)initWithManagedObjectContext:(NSManagedObjectContext *)moc;

@end
