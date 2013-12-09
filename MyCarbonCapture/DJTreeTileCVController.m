//
//  DJTreeTileCVController.m
//
//  Created by Dallas Johnson on 1/12/2013.
//  Copyright (c) 2013 Dallas Johnson. All rights reserved.
//

#import "DJTreeTileCVController.h"
#import "DJLeavesCollectionViewLayout.h"
#import "DJWifiUsageModel.h"


@interface DJTreeTileCVController ()
@property (nonatomic, strong) NSMutableArray *incompletCells;
@property (nonatomic) unsigned numCells;
@property (nonatomic, strong) NSTimer *webCheckTimer;
@property (nonatomic) long currWebUsage;

@end

@implementation DJTreeTileCVController

static NSString *CellIdentifier = @"CellIdentifier";
/* Each tree is worth 5GB of data
 To work out the difference for each .1 alpha step on each tile
 5*1024*1024 = 5242880 kb / 56 tiles / 100 for each alpha step = 936 kilobytes
 */
static int ANIMATION_STEP_THRESHOLD = 936;


-(id)initWithCollectionViewLayout:(UICollectionViewLayout *)layout {
  self = [super initWithCollectionViewLayout:[[DJLeavesCollectionViewLayout alloc] init]];
  if (self) {
    self.view.backgroundColor = [UIColor whiteColor];
    self.collectionView.backgroundColor = [UIColor whiteColor];
    self.numCells = 60;
    _incompletCells = [NSMutableArray array];
    for (unsigned i = 0; i<self.numCells; i++)
      [_incompletCells addObject:@(i)];
  }
  return self;
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
  NSLog(@"the previous web usage was %ld",self.currWebUsage);
  self.webCheckTimer = [NSTimer scheduledTimerWithTimeInterval:5 target:self selector:@selector(checkDataUsage) userInfo:nil repeats:YES];
  [self.webCheckTimer fire];
}

-(void)viewWillDisappear:(BOOL)animated {
  [self.webCheckTimer invalidate];
  [[DJWifiUsageModel sharedInstance] persistWebUsage];
}

-(void)checkDataUsage{
  [self.collectionView reloadData];
  int newWebUsage = [[DJWifiUsageModel sharedInstance] networkUsageKB];

  if(newWebUsage - self.currWebUsage > ANIMATION_STEP_THRESHOLD){
    //if(YES){ //this is a short cut for the demo
    self.currWebUsage = newWebUsage;
    [self incrementTree];
  }
}

-(void)incrementTree {
  if (self.incompletCells.lastObject) {
    unsigned randNumber = arc4random_uniform([self.incompletCells count]);
    // NSLog(@"the cell is %d with count left %d",randNumber, [self.incompletCells count]);
    UICollectionViewLayoutAttributes * attr = [self.collectionView.collectionViewLayout layoutAttributesForItemAtIndexPath:
                                               [NSIndexPath indexPathForItem:
                                                [self.incompletCells[randNumber] intValue]
                                                                   inSection:0]];
    if (attr.alpha >= 1) {
      [self.incompletCells removeObjectAtIndex:randNumber];
      [self incrementTree];
    } else {
      attr.alpha +=.01;
      //NSLog(@"the count left is %d",self.incompletCells.count);
      [self.delegate didIncreaseUsageStats:self.currWebUsage];
    }
  } else {
    NSLog(@"this is the end ");
    [self.webCheckTimer invalidate];
    [[DJWifiUsageModel sharedInstance] persistWebUsage];

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
  NSString *imageName = [NSString stringWithFormat:@"WOS_AppTree_v1b_%02d",indexPath.row+1];
  cell.backgroundView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:imageName]];
  return cell;
}


-(BOOL)collectionView:(UICollectionView *)collectionView shouldHighlightItemAtIndexPath:(NSIndexPath *)indexPath {
  return YES;
}

-(void)collectionView:(UICollectionView *)collectionView didHighlightItemAtIndexPath:(NSIndexPath *)indexPath {
  UICollectionViewLayoutAttributes *attr = [collectionView.collectionViewLayout layoutAttributesForItemAtIndexPath:indexPath];
  CGFloat originalAlpha = attr.alpha;
  int orignalZIndex = attr.zIndex;
  CATransform3D originalT = attr.transform3D;
  [self.collectionView performBatchUpdates:^{
    attr.alpha =1;
    attr.transform3D = CATransform3DScale(attr.transform3D, 2.0, 2.0, 0);
    attr.zIndex = INT32_MAX;
    attr.transform = CGAffineTransformMakeScale(2, 2);
  } completion:^(BOOL finished) {
    attr.transform3D = originalT;
    attr.zIndex = orignalZIndex;
    attr.alpha = originalAlpha;
  }];
}


-(BOOL)collectionView:(UICollectionView *)collectionView shouldDeselectItemAtIndexPath:(NSIndexPath *)indexPath {
  return YES;
}

-(void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {

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

@end
