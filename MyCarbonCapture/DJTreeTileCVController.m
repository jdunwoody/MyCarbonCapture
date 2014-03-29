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


@interface DJTreeTileCVController () <UIAlertViewDelegate>
@property (nonatomic, strong) NSMutableArray *incompletCells;
@property (nonatomic) unsigned numCells;
@property (nonatomic, strong) NSTimer *webCheckTimer;
@property (nonatomic) long long currWebUsage;
@property (nonatomic) int currentTreeGrowth;
@property (nonatomic, strong) DJLeavesCollectionViewLayout *leavesLayout;

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

-(id)initWithCollectionViewLayout:(UICollectionViewLayout *)layout {
  self = [super initWithCollectionViewLayout:[[DJLeavesCollectionViewLayout alloc] init]];
  if (self) {
    self.leavesLayout = (DJLeavesCollectionViewLayout*)self.collectionViewLayout;
    //[[NSUserDefaults standardUserDefaults] setInteger:0 forKey:CURRENT_TREE_PROGRESS_KEY];
    self.view.backgroundColor = [UIColor whiteColor];
    self.collectionView.backgroundColor = [UIColor whiteColor];
    self.numCells = 60;
    [self resetCells];
     }
  return self;
}

-(void)resetCells{
  _incompletCells = [NSMutableArray array];
  for (unsigned i = 0; i < self.numCells; i++)
    [_incompletCells addObject:@(i)];
  [self.collectionView reloadData];

}

- (void)viewDidLoad
{
  [super viewDidLoad];
  [self.collectionView registerClass:[UICollectionViewCell class]
          forCellWithReuseIdentifier:CellIdentifier];
}

-(UIStatusBarStyle)preferredStatusBarStyle {
  return UIStatusBarStyleDefault;
}

-(void)viewDidAppear:(BOOL)animated {
  [super viewDidAppear:animated];
  [self.collectionViewLayout invalidateLayout];
  // NSLog(@"the data is %lld Bytes",([DJWifiUsageModel getDataCounters]));
  [DJWifiUsageModel sharedInstance];
  NSLog(@"the previous web usage was %lld",self.currWebUsage);

  //Bring the tree up to it's previous stage of growth after a restart
  [NSTimer scheduledTimerWithTimeInterval:0 target:self selector:@selector(restoreTree) userInfo:nil repeats:NO]; // Schedule Restore until after the the view has been all loaded
  self.webCheckTimer = [NSTimer scheduledTimerWithTimeInterval:.1 target:self selector:@selector(checkDataUsage) userInfo:nil repeats:YES];
  [self.webCheckTimer fire];
}

-(void)viewWillDisappear:(BOOL)animated {
  [self.webCheckTimer invalidate];
  [[NSUserDefaults standardUserDefaults] setInteger:self.currentTreeGrowth forKey:CURRENT_TREE_PROGRESS_KEY];
  [[DJWifiUsageModel sharedInstance] persistWebUsage];
}

-(void)checkDataUsage{
  long long newWebUsage = [[DJWifiUsageModel sharedInstance] networkUsageKB];

  if(ABS(newWebUsage - self.currWebUsage) > ANIMATION_STEP_THRESHOLD){
    //if(YES){ //this is a short cut for the demo
    self.currWebUsage = newWebUsage;
    [self incrementWebUsage];
  }
}

-(void)incrementWebUsage {
  [self growTreeWithProgressBlock:^{
    [self.delegate didIncreaseUsageStats:self.currWebUsage];

  } completionBlock:^{
    NSLog(@"this is the end ");
    [self addNewTree];
    //[self.webCheckTimer invalidate];
    [self resetCells];
    [[NSUserDefaults standardUserDefaults] setInteger:0 forKey:CURRENT_TREE_PROGRESS_KEY];

    [[DJWifiUsageModel sharedInstance] persistWebUsage];
  } ];
}


-(void)addNewTree {
  unsigned ranNum = arc4random_uniform(5);
  NSError *error = nil;
  NSString *imgName = nil;
  Tree * tree = [NSEntityDescription insertNewObjectForEntityForName:TREE_IDENTITY inManagedObjectContext:self.moc];
  imgName = [NSString stringWithFormat:@"MCC_BankTree#%d",ranNum];
  tree.image = [UIImage imageNamed:imgName];
  tree.name = [NSString stringWithFormat:@"The tree name is tree%d",ranNum];
  tree.info = [NSString stringWithFormat:@"The tree infomation is tree %d",ranNum];
  tree.useIdentifier = TreeStorageUsageTypeGrowth;
  [self.moc save:&error];
  if (error)
    NSLog(@"The found error is %@",error);
}

-(void)growTreeWithProgressBlock:(void(^)(void))progress completionBlock:(void(^)(void))completion {
  if (self.incompletCells.lastObject) {
    unsigned randNumber = arc4random_uniform([self.incompletCells count]);
    NSIndexPath *pickedPath = [NSIndexPath indexPathForItem:[self.incompletCells[randNumber] intValue] inSection:0];

    if ( self.leavesLayout.highlightledIndexPath && [self.leavesLayout.highlightledIndexPath isEqual:pickedPath]) {
      [self incrementWebUsage];
      return;
    }
    UICollectionViewLayoutAttributes * attr = [self.collectionView.collectionViewLayout layoutAttributesForItemAtIndexPath:pickedPath];

    if (attr.alpha >= 1) {
      [self.incompletCells removeObjectAtIndex:randNumber];
      [self incrementWebUsage];
      return;
    }
    attr.alpha +=.1;
    [self.collectionView.collectionViewLayout invalidateLayout];
    //NSLog(@"the count left is %d",self.incompletCells.count);
    if (progress)progress();

  } else {
    if (completion)completion();
  }
}


-(void)restoreTree {
  self.currentTreeGrowth = [[NSUserDefaults standardUserDefaults] integerForKey:CURRENT_TREE_PROGRESS_KEY];
  for (unsigned i = 1; i < self.currentTreeGrowth; i++) {
    [self growTreeWithProgressBlock:nil completionBlock:nil];
  }
}

#pragma mark - UICollectionview methods

-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
  return self.numCells;
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
  // NSLog(@"the highlighted index path is %@!",indexPath);
  [self.webCheckTimer invalidate];
  self.leavesLayout.highlightledIndexPath = indexPath;
  // __block UICollectionViewLayoutAttributes *attr = [collectionView.collectionViewLayout layoutAttributesForItemAtIndexPath:indexPath];
  [self.collectionView performBatchUpdates:^{
    UICollectionViewLayoutAttributes *attr = [collectionView.collectionViewLayout layoutAttributesForItemAtIndexPath:indexPath];
    [self.leavesLayout highlightAttributes:attr];
  } completion:nil];
  [self displayDidYouKnowMessage];

}


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
  UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Did You Know..." message:msgString delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil];
  [alert show];
}

-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex {
  NSIndexPath *resetPath = self.leavesLayout.highlightledIndexPath;
  self.leavesLayout.highlightledIndexPath = nil;
  self.webCheckTimer = [NSTimer scheduledTimerWithTimeInterval:.6 target:self selector:@selector(checkDataUsage) userInfo:nil repeats:YES];
  [self.webCheckTimer fire];
  [self.collectionView performBatchUpdates:^{
    UICollectionViewLayoutAttributes *attr = [self.collectionView layoutAttributesForItemAtIndexPath:resetPath];
    [self.leavesLayout unhighlightAttributes:attr];
  } completion:nil];
}

@end
