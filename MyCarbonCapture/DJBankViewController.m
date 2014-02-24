//
//  DJtreeStorageViewController.m
//  MyCarbonCapture
//
//  Created by Dallas Johnson on 19/02/2014.
//  Copyright (c) 2014 Dallas Johnson. All rights reserved.
//

#import "DJBankViewController.h"
#import "Tree+_StorageType.h"

@interface DJBankViewController ()


@end

@implementation DJBankViewController
static NSString *CELL_IDENTIFIER = @"CELL_IDENTIFER";
static NSString *TREE_IDENTITY = @"Tree";



-(id)initWithCollectionViewLayout:(UICollectionViewLayout *)layout {
  UICollectionViewFlowLayout *gridLayout = [[UICollectionViewFlowLayout alloc] init];
  self = [super initWithCollectionViewLayout:gridLayout];
  if (self) {
    gridLayout.itemSize = CGSizeMake(23, 33);
    gridLayout.scrollDirection = UICollectionViewScrollDirectionHorizontal;
    [gridLayout setSectionInset:UIEdgeInsetsMake(5, 5, 10, 5)];
    self.collectionView.dataSource = self;
    self.collectionView.delegate = self;
    self.collectionView.backgroundColor = [UIColor clearColor];
    [self.collectionView registerClass:[UICollectionViewCell class] forCellWithReuseIdentifier:CELL_IDENTIFIER];
  }
  return self;
}

- (void)viewDidLoad
{
  [super viewDidLoad];
  self.view.translatesAutoresizingMaskIntoConstraints = NO;
  [self.view addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:[selfView(48)]" options:0 metrics:nil views:@{@"selfView":self.view}]];


}

-(void)viewDidAppear:(BOOL)animated {

}


-(UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
  UICollectionViewCell * cell = [collectionView dequeueReusableCellWithReuseIdentifier:CELL_IDENTIFIER forIndexPath:indexPath];
  Tree *tree = [self.frc objectAtIndexPath:indexPath];
  [cell.contentView addSubview:[[UIImageView alloc] initWithImage:tree.image]];
  return cell;
}

-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
  id <NSFetchedResultsSectionInfo> sectionInfo = [[self.frc sections] objectAtIndex:section];
  NSLog(@"the count of kck is %d",[sectionInfo numberOfObjects]);
  return [sectionInfo numberOfObjects];
}



-(NSFetchedResultsController *)frc {
  if (_frc) {
    return _frc;
  }

  NSError * error = nil;

  [self seedTrees];

  NSFetchRequest * req = [NSFetchRequest fetchRequestWithEntityName:TREE_IDENTITY];
  req.predicate = [NSPredicate predicateWithFormat:@"useIdentifier ==  %d",TreeStorageUsageTypeBank];

  if (error) {
    NSLog(@"Error creating a new treeStorage and NSFetched Results Controller: %@",error);
  }

  req.sortDescriptors = @[[NSSortDescriptor sortDescriptorWithKey:@"name" ascending:YES]];
  _frc = [[NSFetchedResultsController alloc] initWithFetchRequest:req
                                             managedObjectContext:self.moc
                                               sectionNameKeyPath:nil
                                                        cacheName:nil];
  _frc.delegate = self;

  if (![_frc performFetch:&error]) {
    abort();
  }



  return _frc;
}

-(void)seedTrees {
  NSError *error = nil;
  Tree * tree = nil;
  NSString *imgName = nil;
  for (int i = 1; i <=5; i++) {

    tree = [NSEntityDescription insertNewObjectForEntityForName:TREE_IDENTITY inManagedObjectContext:self.moc];
    imgName = [NSString stringWithFormat:@"MCC_BankTree#%d",i];
    tree.image = [UIImage imageNamed:imgName];
    tree.name = [NSString stringWithFormat:@"The tree name is tree%d",i];
    tree.info = [NSString stringWithFormat:@"The tree infomation is tree %d",i];
    tree.useIdentifier = TreeStorageUsageTypeBank;
  }
  [self.moc save:&error];
  if (error)
    NSLog(@"The found error is %@",error);
}

-(void)refreshBankViewCollection {
  NSError * error = nil;
  [self.frc performFetch:&error];
  [self.collectionView reloadData];

}

@end
