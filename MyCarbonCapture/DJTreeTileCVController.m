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

@interface DJTreeTileCVController () <UIAlertViewDelegate, UICollectionViewDataSource,LeavesCollectionViewDelegateFlowLayout>
@property (nonatomic, readonly) NSArray *stillGrowingCells;
@property (nonatomic) unsigned numCells;
@property (nonatomic, strong) NSTimer *webCheckTimer;
@property (nonatomic) long currWebUsage;
@property (nonatomic) NSUInteger currentTreeGrowth;
@property (nonatomic, strong) DJLeavesCollectionViewLayout *leavesLayout;
@property (nonatomic,strong) DJFactShareViewController *factViewController;
@property (nonatomic,strong) NSMutableArray *tiles;
@property (nonatomic) float treeGrowth;
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

-(id)init{
  self = [super initWithCollectionViewLayout:[[DJLeavesCollectionViewLayout alloc] init]];
  if (self) {
    self.leavesLayout = (DJLeavesCollectionViewLayout*)self.collectionViewLayout;
    self.view.backgroundColor = [UIColor whiteColor];
    self.collectionView.backgroundColor = [UIColor whiteColor];
  }
  return self;
}

- (void)viewDidLoad
{
  [super viewDidLoad];
  [self.collectionView registerClass:[UICollectionViewCell class]
          forCellWithReuseIdentifier:CellIdentifier];
  [DJWifiUsageModel sharedInstance];
}

-(UIStatusBarStyle)preferredStatusBarStyle {
  return UIStatusBarStyleDefault;
}

-(void)viewWillAppear:(BOOL)animated{
  self.tiles = [[[NSUserDefaults standardUserDefaults] objectForKey:TILES_ALPHA_KEY] mutableCopy];
  _treeGrowth = [[NSUserDefaults standardUserDefaults] integerForKey:CURRENT_TREE_PROGRESS_KEY];
  if (!self.tiles) {
    NSLog(@"Creating the Incimplete Cells is %@",self.tiles);
    [self seedTiles];
  }

}

-(void)viewDidAppear:(BOOL)animated {
  [super viewDidAppear:animated];
  [self.collectionViewLayout invalidateLayout];
}

-(void)viewWillDisappear:(BOOL)animated {
  [self.webCheckTimer invalidate];
  [[NSUserDefaults standardUserDefaults] setObject:self.tiles forKey:TILES_ALPHA_KEY];
  [[NSUserDefaults standardUserDefaults] synchronize];
}

-(void)checkDataUsage{
  long newWebUsage = [[DJWifiUsageModel sharedInstance] latestNetworkUsage];

  if(ABS(newWebUsage - self.currWebUsage) > ANIMATION_STEP_THRESHOLD){
    self.currWebUsage = newWebUsage;
    [self incrementWebUsageWithUsage:newWebUsage];
  }
}


-(NSArray *)stillGrowingCells{
  NSMutableArray *growing = [NSMutableArray array];
  [self.tiles enumerateObjectsUsingBlock:^(NSNumber *obj, NSUInteger idx, BOOL *stop) {
    if (obj.floatValue < 1) {
      [growing addObject:@(idx)];
    }
  }];
  return growing;
}


-(void)incrementWebUsageWithUsage:(long)usage{
  if ([self.stillGrowingCells count] > 0) {
    [self growTree];
    [self.delegate didIncreaseUsageStats:usage];
  } else {
    NSLog(@"this is the end of the tree growth");
    [self.delegate didCompleteTree];
    [self seedTiles];
    self.treeGrowth = 0;
    [[NSUserDefaults standardUserDefaults] setInteger:0 forKey:CURRENT_TREE_PROGRESS_KEY];

    [[DJWifiUsageModel sharedInstance] persistWebUsage];
  }
  self.treeGrowth++;
  float amount = ((float)self.treeGrowth) / (NUM_CELLs * 10);
  NSLog(@"the tree growth is %f amount is %f",_treeGrowth,amount );
  [[NSUserDefaults standardUserDefaults] setInteger:self.treeGrowth forKey:CURRENT_TREE_PROGRESS_KEY];
  [[DJWifiUsageModel sharedInstance] persistWebUsage];


  [self.delegate treeDidGrowToAmount:amount];
  if (amount > 1) {
    self.treeGrowth = 0;
  }

}

-(void)growTree{
  NSUInteger randNumber = arc4random_uniform((UInt32)[self.stillGrowingCells count]);
  NSUInteger pickedIndex = [self.stillGrowingCells[randNumber] unsignedIntegerValue];

  //  if ( self.leavesLayout.highlightledIndexPath && [self.leavesLayout.highlightledIndexPath isEqual:pickedPath]) {
  //    [self incrementWebUsageWithUsage:self.currWebUsage];
  //    return;
  //  }

  float alpha = [self.tiles[pickedIndex] floatValue];
  if (alpha >= 1) {
    [self incrementWebUsageWithUsage:self.currWebUsage];
  } else {
    self.tiles[pickedIndex] =  @([self.tiles[pickedIndex] floatValue] + 0.1);
    //tile.alpha = tile.alpha + .1;
    [self.collectionView.collectionViewLayout invalidateLayout];
  }
}

#pragma mark - UICollectionview methods

-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
  return [self.tiles count];
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

-(void)seedTiles {
  self.tiles = [NSMutableArray array];
  for (int i = 0; i < NUM_CELLs; i++) {
    [self.tiles addObject:@(0.1)];
  }
}

//-(void)refreshTileViewCollection {
//  NSError * error = nil;
//  [self.frc performFetch:&error];
//  [self.collectionView reloadData];
//
//}

#pragma mark - Alpha for cell
-(float)alphaForCellAtIndexPath:(NSIndexPath *)indexPath{
  return [self.tiles[indexPath.row] floatValue];
}


@end
