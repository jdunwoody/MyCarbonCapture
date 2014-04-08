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

#import "Masonry.h"

@interface DJTreeContainer ()
@property (nonatomic,strong) UIButton *donateButton;
@property (nonatomic, strong) UILabel *gasValueLabel;
@property (nonatomic,strong) NSMutableArray *treesInBank;
@property(nonatomic, strong) DJBankViewController *bankViewController;
@property(nonatomic, strong) DJThermometerView *thermometer;
@end

@implementation DJTreeContainer

static NSString *WITH_ONE_SEED_URL = @"http://withoneseed.org.au/donate";

-(void)viewDidLoad {

  DJTreeTileCVController *tileViewController = [[DJTreeTileCVController alloc] initWithCollectionViewLayout:nil];
  tileViewController.moc = self.moc;
  tileViewController.delegate = self;

  [self.view addSubview:tileViewController.view];
  tileViewController.view.translatesAutoresizingMaskIntoConstraints = NO;
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

  [self addChildViewController:tileViewController];
  [self.view addSubview:tileViewController.view];
  [self.view addSubview:_donateButton];


  UILabel *gasLabel = [[UILabel alloc] initWithFrame:CGRectZero];
  gasLabel.text = @"My CO2 emissions are:";
  self.gasValueLabel = [[UILabel alloc] initWithFrame:CGRectZero];

  [self.view addSubview:gasLabel];
  [self.view addSubview:self.gasValueLabel];
  self.view.backgroundColor = [UIColor whiteColor];


  self.bankViewController = [[DJBankViewController alloc] initWithCollectionViewLayout:nil];
  self.bankViewController.moc = self.moc;
  [self addChildViewController:self.bankViewController];
  [self.view addSubview:self.bankViewController.view];

  self.thermometer = [[DJThermometerView alloc] initWithFrame:CGRectZero];
  [self.view addSubview:self.thermometer];

  UIButton *flipButton = [UIButton buttonWithType:UIButtonTypeInfoDark];

  [flipButton addTarget:self
                 action:@selector(showForest)
       forControlEvents:UIControlEventTouchUpInside];

  [self.view addSubview:flipButton];

  NSDictionary *viewsDict = @{@"collectionView": tileViewController.view,
                              @"menuBar":self.topLayoutGuide,
                              // @"donateButton":_donateButton,
                              @"bankView": self.bankViewController.view,
                              @"gasLabel":gasLabel,
                              @"gasValueLabel":_gasValueLabel,
                              @"thermometer": self.thermometer,
                              @"flipButton":flipButton
                              };

  [viewsDict eachValue:^(UIView* value) {
    value.translatesAutoresizingMaskIntoConstraints = NO;
  }];


  [self.view addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|-[collectionView]-[gasValueLabel][thermometer]-[bankView]-|" options:0 metrics:nil views:viewsDict]];
  [self.view addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"|-[gasLabel][gasValueLabel]" options:NSLayoutFormatAlignAllCenterY metrics:0 views:viewsDict]];
  [self.view addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|[thermometer]|" options:0 metrics:nil views:viewsDict]];

  [self.view addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|-10-[bankView]-10-|" options:0 metrics:nil views:viewsDict]];

  //[self.view addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|-20-[donateButton]-20-|" options:0 metrics:nil views:viewsDict]];
  [self.view addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|[collectionView]|" options:0 metrics:nil views:viewsDict]];
  [self.view addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:[flipButton]-|"options:0 metrics:nil views:viewsDict]];
  [self.view addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:[flipButton]-|"options:0 metrics:nil views:viewsDict]];
}

#pragma mark - CollectionViewDelegates
-(void)didIncreaseUsageStats:(long long)kilobytes {
  self.donateButton.alpha +=.01;
  self.gasValueLabel.text = [NSString stringWithFormat:@"%lld kB",kilobytes];
  self.thermometer.level += .01;
}

-(void)viewWillAppear:(BOOL)animated{
  [self.bankViewController refreshBankViewCollection];
}


-(void)didReachMaxStats {

}

-(void)didResetStats{

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

@end
