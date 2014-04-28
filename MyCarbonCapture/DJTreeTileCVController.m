//
//  DJTreeTileCVController.m
//
//  Created by Dallas Johnson on 1/12/2013.
//  Copyright (c) 2013 Dallas Johnson. All rights reserved.
//

#import "DJTreeTileCVController.h"
#import "DJLeavesCollectionViewLayout.h"
#import "DJWifiUsageModel.h"
#import "Tree+_StorageType.h"
#import "DJFactShareViewController.h"
#import "Tile+Utils.h"

#define TILE_IDENTITY @"Tile"



@interface DJTreeTileCVController () <UIAlertViewDelegate, NSFetchedResultsControllerDelegate, UICollectionViewDataSource,LeavesCollectionViewDelegateFlowLayout>
@property (nonatomic, strong) NSMutableArray *incompletCells;
@property (nonatomic) unsigned numCells;
@property (nonatomic, strong) NSTimer *webCheckTimer;
@property (nonatomic) long currWebUsage;
@property (nonatomic) NSUInteger currentTreeGrowth;
@property (nonatomic, strong) DJLeavesCollectionViewLayout *leavesLayout;
@property (nonatomic,strong) DJFactShareViewController *factViewController;
@property (nonatomic, strong) NSFetchedResultsController *frc;

@end

@implementation DJTreeTileCVController

static NSString *CellIdentifier = @"CellIdentifier";
static NSString * CURRENT_TREE_PROGRESS_KEY = @"CurrentTreeProgress";
#define NUM_CELLs 56

/* Each tree is worth 500MB of data
 To work out the difference for each .1 alpha step on each tile
 500*1024 = 512000 kb / 56 tiles / 100 for each alpha step = 91.47 kilobytes
 */
static int ANIMATION_STEP_THRESHOLD = 91; // should be 91;

-(id)initWithManagedObjectContext:(NSManagedObjectContext *)moc{
  self = [super initWithCollectionViewLayout:[[DJLeavesCollectionViewLayout alloc] init]];
  if (self) {
    self.moc = moc;
    self.leavesLayout = (DJLeavesCollectionViewLayout*)self.collectionViewLayout;
    self.view.backgroundColor = [UIColor whiteColor];
    self.collectionView.backgroundColor = [UIColor whiteColor];
    [self resetCells];
  }
  return self;
}

-(void)resetCells{
  DLog();
  _incompletCells = [NSMutableArray array];

  [self.frc.fetchedObjects enumerateObjectsUsingBlock:^(Tile* tile, NSUInteger idx, BOOL *stop) {
    tile.alpha = 0.1;
    NSLog(@"The index being inserted is %lu",(unsigned long)idx);
    [_incompletCells addObject:@(idx)];

  }];

  //  [self.leavesLayout resetAlphas];
  // [self.collectionView.collectionViewLayout prepareLayout];
  [self.collectionView reloadData];
}

- (void)viewDidLoad
{
  [super viewDidLoad];
  [self.collectionView registerClass:[UICollectionViewCell class]
          forCellWithReuseIdentifier:CellIdentifier];
  [self seedTiles];

}

-(UIStatusBarStyle)preferredStatusBarStyle {
  return UIStatusBarStyleDefault;
}

-(void)viewDidAppear:(BOOL)animated {
  [super viewDidAppear:animated];
  [self.collectionViewLayout invalidateLayout];
  [DJWifiUsageModel sharedInstance];

  //Bring the tree up to it's previous stage of growth after a restart
  // [NSTimer scheduledTimerWithTimeInterval:0 target:self selector:@selector(restoreTree) userInfo:nil repeats:NO]; // Schedule Restore until after the the view has been all loaded
  self.webCheckTimer = [NSTimer scheduledTimerWithTimeInterval:.1 target:self selector:@selector(checkDataUsage) userInfo:nil repeats:YES];
  [self.webCheckTimer fire];
}

-(void)viewWillDisappear:(BOOL)animated {
  [self.webCheckTimer invalidate];
  [[NSUserDefaults standardUserDefaults] setInteger:self.currentTreeGrowth forKey:CURRENT_TREE_PROGRESS_KEY];
  [[DJWifiUsageModel sharedInstance] persistWebUsage];
}

-(void)checkDataUsage{
  long newWebUsage = [[DJWifiUsageModel sharedInstance] latestNetworkUsage];

  if(ABS(newWebUsage - self.currWebUsage) > ANIMATION_STEP_THRESHOLD){
    //if(YES){ //this is a short cut for the demo
    self.currWebUsage = newWebUsage;
    [self incrementWebUsageWithUsage:newWebUsage];
  }
}

-(void)incrementWebUsageWithUsage:(long)usage{
  if (self.incompletCells.lastObject != nil) {
    [self growTree];
    [self.delegate didIncreaseUsageStats:usage];
  } else {
    NSLog(@"this is the end of the tree growth");
    [self addNewTree];
    //[self.webCheckTimer invalidate];
    [self resetCells];
    [[NSUserDefaults standardUserDefaults] setInteger:0 forKey:CURRENT_TREE_PROGRESS_KEY];

    [[DJWifiUsageModel sharedInstance] persistWebUsage];
  }
}


-(void)addNewTree {
  DLog();
  unsigned ranNum = arc4random_uniform(4);
  NSError *error = nil;
  Tree * tree = [NSEntityDescription insertNewObjectForEntityForName:TREE_IDENTITY inManagedObjectContext:self.moc];
  NSString * selectName = [NSString stringWithFormat:@"TreeSelect%d",ranNum];
  tree.imageSelect = [UIImage imageNamed:selectName];
  DLog(@"selectName is %@",selectName);
  NSString *hoverName = [NSString stringWithFormat:@"TreeHover%d",ranNum];
  DLog(@"hoverName is %@",hoverName);
  tree.imageHover = [UIImage imageNamed:hoverName];
  tree.largeImage = [UIImage imageNamed:[NSString stringWithFormat:@"Tree%d-w250px",ranNum]];
  tree.name = [NSString stringWithFormat:@"The tree name is tree%d",ranNum];
  tree.info = [NSString stringWithFormat:@"The tree infomation is tree %d",ranNum];
  tree.useIdentifier = TreeStorageUsageTypeBank;
  [self.moc save:&error];
  if (error)
    NSLog(@"The found error is %@",error);
}

-(void)growTree{
  NSUInteger randNumber = arc4random_uniform((UInt32)[self.incompletCells count]);
  NSIndexPath *pickedPath = [NSIndexPath indexPathForItem:[self.incompletCells[randNumber] intValue] inSection:0];

  if ( self.leavesLayout.highlightledIndexPath && [self.leavesLayout.highlightledIndexPath isEqual:pickedPath]) {
    [self incrementWebUsageWithUsage:self.currWebUsage];
    return;
  }

  Tile *tile = (Tile*)[self.frc objectAtIndexPath:pickedPath];

  if (tile.alpha >= 1) {
    [self.incompletCells removeObjectAtIndex:randNumber];
    [self incrementWebUsageWithUsage:self.currWebUsage];
  } else {
    tile.alpha = tile.alpha + .1;
    //NSIndexPath *path = [NSIndexPath indexPathForRow:randNumber inSection:0];
    [self.moc save:nil];
    //[self.collectionView reloadItemsAtIndexPaths:@[path]];
    [self.collectionView.collectionViewLayout invalidateLayout];
    //  NSLog(@"the count left is %lu from tile:%@ at index: %ld alpha is %f",(unsigned long)self.incompletCells.count,tile, (long)path.row,[(UICollectionViewCell*)self.collectionView.visibleCells[path.row] backgroundView].alpha);
  }
}


//-(void)restoreTree {
//  self.currentTreeGrowth = [[NSUserDefaults standardUserDefaults] integerForKey:CURRENT_TREE_PROGRESS_KEY];
//  for (unsigned i = 1; i < self.currentTreeGrowth; i++) {
//    [self growTree];
//  }
//}

#pragma mark - UICollectionview methods

-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
  return [self.frc.fetchedObjects count];
}

-(NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
  return 1;
}

-(UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
  UICollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:CellIdentifier forIndexPath:indexPath];
  NSString *imageName = [NSString stringWithFormat:@"WOS_AppTree_v1b_%02ld",indexPath.row+1];
  cell.backgroundView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:imageName]];
  return cell;
}


-(BOOL)collectionView:(UICollectionView *)collectionView shouldHighlightItemAtIndexPath:(NSIndexPath *)indexPath {
  return YES;
}

-(void)collectionView:(UICollectionView *)collectionView didHighlightItemAtIndexPath:(NSIndexPath *)indexPath{
  [self.webCheckTimer invalidate];

  [(Tile*)[self.frc objectAtIndexPath:indexPath] setAlpha:1];

  self.leavesLayout.highlightledIndexPath = indexPath;
  UICollectionViewLayoutAttributes *attr = [collectionView.collectionViewLayout layoutAttributesForItemAtIndexPath:indexPath];
  [self.leavesLayout highlightAttributes:attr];
  [self displayDidYouKnowMessage];
}

-(void)setFactViewController:(DJFactShareViewController *)factViewController{

  if (_factViewController != factViewController) {

    [_factViewController.view removeFromSuperview];
    [_factViewController removeFromParentViewController];
    _factViewController = factViewController;
    self.factViewController.view.center = self.view.center;
    UIInterpolatingMotionEffect *effect = [[UIInterpolatingMotionEffect alloc] initWithKeyPath:@"width" type:UIInterpolatingMotionEffectTypeTiltAlongHorizontalAxis];
    effect.minimumRelativeValue = @5;
    effect.maximumRelativeValue = @600.0;
    [self.view addMotionEffect:effect];
    [self addChildViewController:self.factViewController];
    [self.view addSubview:self.factViewController.view];
  }
  NSIndexPath *resetPath = self.leavesLayout.prevHighlight;
  UICollectionViewLayoutAttributes *attr = [self.collectionView.collectionViewLayout layoutAttributesForItemAtIndexPath:resetPath];
  if ([(DJLeavesCollectionViewLayout*)self.collectionView.collectionViewLayout animator].isRunning ) {
    //if the tiles are currently bouncing dont animate the cell changes to avoid the stutter in the bouncing.
    [self.leavesLayout unhighlightAttributes:attr];
  } else {
    [self.collectionView performBatchUpdates:^{
      [self.leavesLayout unhighlightAttributes:attr];
    } completion:nil];
  }
  self.webCheckTimer = [NSTimer scheduledTimerWithTimeInterval:.6 target:self selector:@selector(checkDataUsage) userInfo:nil repeats:YES];
  [self.webCheckTimer fire];

}


#pragma mark Did you know messages

-(void)displayDidYouKnowMessage {
  int whichMesg = arc4random_uniform(6);
  NSString *msgString = nil;
  switch (whichMesg) {
    case 0:
      msgString = @"Over 2 billion people use the internet on this planet.";
      break;
    case 1:
      msgString = @"Over 6.8 billion use a mobile phone on this planet.";
      break;
    case 2:
      msgString = @"Hard woods sequest more carbon than soft woods";
      break;
    case 3:
      msgString = @"Trees grow by absorbing carbon dioxide from the atmosphere and releasing life sustaining oxygen.";
      break;
    case 4:
      msgString = @"294 billion emails are sent per day generates the equivalent of over 8,800 tons of CO2.";
      break;
    case 5:
      msgString = @"Annual global carbon emissions from technology is as much as a Boeing 747 passenger jet flying to the moon and back 5674 times.";
    default:
      break;
  }
  self.factViewController = [DJFactShareViewController withMessage:msgString];
}

#pragma mark - CoreData elements

-(NSFetchedResultsController *)frc {
  if (_frc) return _frc;

  NSError * error = nil;
  NSFetchRequest * req = [NSFetchRequest fetchRequestWithEntityName:TILE_IDENTITY];
  //req.predicate = [NSPredicate predicateWithFormat:@"useIdentifier ==  %d",TreeStorageUsageTypeBank];
  if (error) {
    NSLog(@"Error creating a new tile Storage and NSFetched Results Controller: %@",error);
  }
  req.sortDescriptors = @[[NSSortDescriptor sortDescriptorWithKey:@"index" ascending:YES]];
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


-(void)seedTiles {
  NSError *error = nil;
  Tile * tile = nil;
  for (int i = 0; i < NUM_CELLs; i++) {
    tile = [NSEntityDescription insertNewObjectForEntityForName:@"Tile" inManagedObjectContext:self.moc];
    tile.index = i;
  }
  [self.moc save:&error];
  if (error)
    NSLog(@"The found error is %@",error);
}

-(void)refreshTileViewCollection {
  NSError * error = nil;
  [self.frc performFetch:&error];
  [self.collectionView reloadData];
  
}


#pragma mark - Alpha for cell 
-(float)alphaForCellAtIndexPath:(NSIndexPath *)indexPath{
  return [(Tile*)[self.frc objectAtIndexPath:indexPath] alpha];

}


@end
