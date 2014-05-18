//
//  DJTreeContainer.m
//
//  Created by Dallas Johnson on 8/12/2013.
//  Copyright (c) 2013 Dallas Johnson. All rights reserved.
//

#import "DJTreeContainer.h"
#import "DJForestViewController.h"
#import "DJBankViewController.h"
#import "DJThermometerView.h"
#import "DJWifiUsageModel.h"
#import "Tree+_StorageType.h"

#import "Masonry.h"

@interface DJTreeContainer ()
@property (nonatomic, strong) UIButton *donateButton;
@property (nonatomic, strong) UILabel *gasValueLabel;
@property (nonatomic, strong) NSMutableArray *treesInBank;
@property (nonatomic, strong) DJBankViewController *bankViewController;
@property (nonatomic, strong) DJThermometerView *thermometer;
@property (nonatomic, strong) DJTreeTileCVController *tileViewController;
@property (nonatomic, strong) UIButton *flipButton;
@property (nonatomic) float thermometerGrowth;
@property (nonatomic, strong) UILabel *gasLabel;
@end

@implementation DJTreeContainer
static NSByteCountFormatter *byteFormatter;
#define THERMOMETER_SCALE 10
#define THERMOMETER_GROWTH_KEY @"thermometerGrowth"

static NSString *WITH_ONE_SEED_URL = @"http://withoneseed.org.au/donate";

-(void)viewDidLoad {

  _tileViewController = [[DJTreeTileCVController alloc] initWithManagedObjectContext:self.moc];
  _tileViewController.delegate = self;

  [self.view addSubview:self.tileViewController.view];
  _tileViewController.view.translatesAutoresizingMaskIntoConstraints = NO;
  self.title = @"MyCarbonCapture";

  /*
   _donateButton = [[UIButton alloc] initWithFrame:CGRectMake(0, 50, 200, 50)];
   [_donateButton setTitle:@"Donate Here" forState:UIControlStateNormal];
   [_donateButton setTitleColor:[UIColor colorWithRed:0 green:.47 blue:.2 alpha:1] forState:UIControlStateNormal];
   _donateButton.alpha = 0.0f;
   _donateButton.titleLabel.font = [_donateButton.titleLabel.font fontWithSize:40];
   [_donateButton addTarget:self action:@selector(donateNow) forControlEvents:UIControlEventTouchUpInside];
   _donateButton.translatesAutoresizingMaskIntoConstraints = NO;
   */

  [self addChildViewController:self.tileViewController];
  [self.view addSubview:self.tileViewController.view];
  [self.view addSubview:_donateButton];


  _gasLabel = [[UILabel alloc] initWithFrame:CGRectZero];
  _gasLabel.text = @"My CO2 emissions are:";
  _gasValueLabel = [[UILabel alloc] initWithFrame:CGRectZero];

  [self.view addSubview:_gasLabel];
  [self.view addSubview:_gasValueLabel];
  self.view.backgroundColor = [UIColor whiteColor];


  _bankViewController = [[DJBankViewController alloc] initWithManagedObjectContext:self.moc];
  [self addChildViewController:_bankViewController];
  [self.view addSubview:_bankViewController.view];

  _thermometer = [[DJThermometerView alloc] initWithFrame:CGRectZero];
  _thermometer.translatesAutoresizingMaskIntoConstraints = NO;
  [self.view addSubview:_thermometer];

  _flipButton = [UIButton buttonWithType:UIButtonTypeInfoDark];

  [_flipButton addTarget:self
                  action:@selector(showForest)
        forControlEvents:UIControlEventTouchUpInside];

  [self.view addSubview:_flipButton];

#if DEBUG

  UIButton *addUsageButton = ({
    UIButton* b = [[UIButton alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(self.view.frame)-20, 20, 20)];
    b.backgroundColor = [UIColor greenColor];
    [b addTarget:self action:@selector(incrementUsage) forControlEvents:UIControlEventAllEvents];
    b;
  });

  [self.view addSubview:addUsageButton];
#endif
}

-(void)updateViewConstraints{
  NSDictionary *viewsDict = @{@"collectionView": self.tileViewController.view,
                              @"menuBar":self.topLayoutGuide,
                              // @"donateButton":_donateButton,
                              @"bankView": self.bankViewController.view,
                              @"gasLabel":self.gasLabel,
                              @"gasValueLabel":self.gasValueLabel,
                              @"thermometer": self.thermometer,
                              @"flipButton":self.flipButton
                              };

  [viewsDict enumerateKeysAndObjectsUsingBlock:^(id key, UIView* view, BOOL *stop) {
    view.translatesAutoresizingMaskIntoConstraints = NO;
  }];

  [self.view addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|-[collectionView]-[gasValueLabel][thermometer]-[bankView]-|" options:0 metrics:nil views:viewsDict]];
  [self.view addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"|-[gasLabel][gasValueLabel]" options:NSLayoutFormatAlignAllCenterY metrics:0 views:viewsDict]];
  [self.view addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|[thermometer]|" options:0 metrics:nil views:viewsDict]];

  [self.view addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|-10-[bankView][flipButton]-|" options:0 metrics:nil views:viewsDict]];

  //[self.view addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|-20-[donateButton]-20-|" options:0 metrics:nil views:viewsDict]];
  [self.view addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|[collectionView]|" options:0 metrics:nil views:viewsDict]];
  [self.view addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:[flipButton]-|"options:0 metrics:nil views:viewsDict]];
  [super updateViewConstraints];

}

#pragma mark - TileViewCollectionViewDelegates
-(void)didIncreaseUsageStats:(long long)kilobytes {
  self.donateButton.alpha +=.01;

  if (!byteFormatter) {
    byteFormatter = [[NSByteCountFormatter alloc] init];
  }
  self.gasValueLabel.text = [byteFormatter stringFromByteCount:kilobytes];
}


-(void)viewWillAppear:(BOOL)animated{
  [self.bankViewController refreshBankViewCollection];

}
-(void)viewDidAppear:(BOOL)animated{
  _thermometer.level = [[NSUserDefaults standardUserDefaults] floatForKey:THERMOMETER_GROWTH_KEY];
}

-(void)didCompleteTree {
  [self addNewTree];
  [self.bankViewController refreshBankViewCollection];
  //self.thermometerGrowth += 1;
//  [[NSUserDefaults standardUserDefaults] setValue:[NSNumber numberWithFloat:self.thermometerGrowth] forKey:THERMOMETER_GROWTH_KEY];
}

-(void)didResetStats{

}

-(void)treeDidGrowToAmount:(float)amount{
  //The thermometer equates to 10 trees amount is from 0 - 1 for a tree
  float calcGrowth = floorf([[NSUserDefaults standardUserDefaults] floatForKey:THERMOMETER_GROWTH_KEY] * 10);
  float resultGrowth = (calcGrowth + amount) * 0.1;

  NSLog(@"The amount of growth is %f with calcGrowth of %f with result: %f",amount, calcGrowth,resultGrowth);
  //the Thermometer goes from 0 to 10
  self.thermometer.level =  resultGrowth;
  [[NSUserDefaults standardUserDefaults] setFloat:resultGrowth forKey:THERMOMETER_GROWTH_KEY];

}

#pragma - Tree Management
-(void)addNewTree {
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
    NSLog(@"Error While adding a new tree: %@",error);
}


#pragma mark - Donate Now

-(void)donateNow {
  NSURL *donateURL = [NSURL URLWithString:WITH_ONE_SEED_URL];
  [[UIApplication sharedApplication] openURL:donateURL];
}

#pragma mark - navigate to Forest

-(void)showForest{
  DJForestViewController * fViewController = [[DJForestViewController alloc] init];
  fViewController.moc = self.moc;
  fViewController.modalTransitionStyle = UIModalTransitionStyleFlipHorizontal;
  [self presentViewController:fViewController animated:YES completion:^{
    nil;
  }];
}
#pragma mark - Debug methods
#if DEBUG
-(void)incrementUsage{
  DLog(@"incrementing usage");
  long usage = [[DJWifiUsageModel sharedInstance] savedNetworkUsage];
  [self.tileViewController incrementWebUsageWithUsage:usage+1];
  [[DJWifiUsageModel sharedInstance] persistWebUsage];
}
#endif

@end
