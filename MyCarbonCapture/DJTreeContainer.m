//
//  DJTreeContainer.m
//
//  Created by Dallas Johnson on 8/12/2013.
//  Copyright (c) 2013 Dallas Johnson. All rights reserved.
//

#import "DJTreeContainer.h"
#import "DJForestViewController.h"
#import "TreeStorage.h"
#import "DJBankViewController.h"

@interface DJTreeContainer ()
@property (nonatomic,strong) UIButton *donateButton;
@property (nonatomic, strong) UILabel *gasValueLabel;
@property (nonatomic,strong) NSMutableArray *treesInBank;
@end

@implementation DJTreeContainer

static NSString *WITH_ONE_SEED_URL = @"http://withoneseed.org.au/donate";

-(id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
  self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
  return self;
}


-(void)viewDidLoad {

  DJTreeTileCVController *vc = [[DJTreeTileCVController alloc] initWithCollectionViewLayout:nil];
  vc.delegate = self;

  [self.view addSubview:vc.view];
  vc.view.translatesAutoresizingMaskIntoConstraints = NO;
  self.title = @"With One Seed";


  _donateButton = [[UIButton alloc] initWithFrame:CGRectMake(0, 50, 200, 50)];
  [_donateButton setTitle:@"Donate Here" forState:UIControlStateNormal];
  [_donateButton setTitleColor:[UIColor colorWithRed:0 green:.47 blue:.2 alpha:1] forState:UIControlStateNormal];
  _donateButton.alpha = 0.0f;
  _donateButton.titleLabel.font = [_donateButton.titleLabel.font fontWithSize:40];
  [_donateButton addTarget:self action:@selector(donateNow) forControlEvents:UIControlEventTouchUpInside];
  [self addChildViewController:vc];
  [self.view addSubview:vc.view];
  [self.view addSubview:_donateButton];
  _donateButton.translatesAutoresizingMaskIntoConstraints = NO;

  UILabel *gasLabel = [[UILabel alloc] initWithFrame:CGRectZero];
  gasLabel.text = @"CO2:";
  self.gasValueLabel = [[UILabel alloc] initWithFrame:CGRectZero];

  [self.view addSubview:gasLabel];
  [self.view addSubview:self.gasValueLabel];
  self.view.backgroundColor = [UIColor whiteColor];


  DJBankViewController *bankViewController = [[DJBankViewController alloc] initWithCollectionViewLayout:nil];
  bankViewController.moc = self.moc;
  [self addChildViewController:bankViewController];
  [self.view addSubview:bankViewController.view];

  UIButton *flipButton = [UIButton buttonWithType:UIButtonTypeInfoDark];

  [flipButton addTarget:self
                 action:@selector(showForest)
       forControlEvents:UIControlEventTouchUpInside];

  [self.view addSubview:flipButton];

  NSDictionary *viewsDict = @{@"collectionView": vc.view,
                              @"menuBar":self.topLayoutGuide,
                              @"donateButton":_donateButton,
                              @"bankView":bankViewController.view,
                              @"gasLabel":gasLabel,
                              @"gasValueLabel":_gasValueLabel,
                              @"flipButton":flipButton
                              };
  [viewsDict.allValues enumerateObjectsUsingBlock:^(UIView* view, NSUInteger idx, BOOL *stop) {
    view.translatesAutoresizingMaskIntoConstraints = NO;
  }];

  [self.view addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|-[collectionView]-[gasValueLabel]-[bankView][donateButton]-|" options:0 metrics:nil views:viewsDict]];
  [self.view addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"|-[gasLabel][gasValueLabel]" options:NSLayoutFormatAlignAllCenterY metrics:0 views:viewsDict]];
  [self.view addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|-10-[bankView]-10-|" options:0 metrics:nil views:viewsDict]];

  [self.view addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|-20-[donateButton]-20-|" options:0 metrics:nil views:viewsDict]];
  [self.view addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|[collectionView]|" options:0 metrics:nil views:viewsDict]];
  [self.view addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:[flipButton]-|"options:0 metrics:nil views:viewsDict]];
  [self.view addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:[flipButton]-|"options:0 metrics:nil views:viewsDict]];

}

#pragma mark - CollectionViewDelegates
-(void)didIncreaseUsageStats:(long long)kilobytes {
  self.donateButton.alpha +=.01;
  self.gasValueLabel.text = [NSString stringWithFormat:@"%lld kB",kilobytes];
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
