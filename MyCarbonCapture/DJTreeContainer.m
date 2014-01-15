//
//  DJTreeContainer.m
//
//  Created by Dallas Johnson on 8/12/2013.
//  Copyright (c) 2013 Dallas Johnson. All rights reserved.
//

#import "DJTreeContainer.h"

@interface DJTreeContainer ()
@property (nonatomic,strong) UIButton *donateButton;
@property (nonatomic, strong) UILabel *gasValueLabel;
@end

@implementation DJTreeContainer

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

  UIImageView * scoreImageView1 = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"MCC_BankTree#1"]];
  UIImageView * scoreImageView2 = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"MCC_BankTree#2"]];
  UIImageView * scoreImageView3 = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"MCC_BankTree#3"]];
  UIImageView * scoreImageView4 = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"MCC_BankTree#4"]];
  UIImageView * scoreImageView5 = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"MCC_BankTree#5"]];

  [self.view addSubview:scoreImageView1];
  [self.view addSubview:scoreImageView3];
  [self.view addSubview:scoreImageView4];
  [self.view addSubview:scoreImageView5];

  NSDictionary *viewsDict = @{@"collectionView": vc.view,
                              @"menuBar":self.topLayoutGuide,
                              @"donateButton":_donateButton,
                              @"scoreimage1":scoreImageView1,
                              @"scoreimage2":scoreImageView2,
                              @"scoreimage3":scoreImageView3,
                              @"scoreimage4":scoreImageView4,
                              @"scoreimage5":scoreImageView5,
                              @"gasLabel":gasLabel,
                              @"gasValueLabel":_gasValueLabel
                              };
  [viewsDict.allValues enumerateObjectsUsingBlock:^(UIView* view, NSUInteger idx, BOOL *stop) {
    view.translatesAutoresizingMaskIntoConstraints = NO;
  }];

  [self.view addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|-60-[collectionView]-[scoreimage1][donateButton]-|" options:0 metrics:nil views:viewsDict]];
  [self.view addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"|-[gasLabel][gasValueLabel]->=0-[scoreimage1][scoreimage3][scoreimage4][scoreimage5]-10-|" options:NSLayoutFormatAlignAllCenterY metrics:0 views:viewsDict]];
  [self.view addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|-20-[donateButton]-20-|" options:0 metrics:nil views:viewsDict]];
  [self.view addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|[collectionView]|" options:0 metrics:nil views:viewsDict]];

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
  NSURL *donateURL = [NSURL URLWithString:@"http://withoneseed.org.au/donate"];
  [[UIApplication sharedApplication] openURL:donateURL];
}

@end
