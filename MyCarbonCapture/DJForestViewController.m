//
//  DJForestViewController.m
//  MyCarbonCapture
//
//  Created by Dallas Johnson on 15/02/2014.
//  Copyright (c) 2014 Dallas Johnson. All rights reserved.
//

#import <Masonry/View+MASShorthandAdditions.h>
#import "DJForestViewController.h"
#import "DJForestScene.h"
#import "DJBankViewController.h"

@interface DJForestViewController ()

@property (nonatomic, strong) DJBankViewController *tileViewController;
@property (nonatomic, strong) UIButton *selectorButton;
@property (nonatomic, strong) MASConstraint *selectorWidth;
@end

@implementation DJForestViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
  self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
  if (self) {
    self.view = [[SKView alloc] initWithFrame:self.view.frame];
  }
  return self;
}


-(void)viewWillAppear:(BOOL)animated {
  SKView *spriteView = (SKView *) self.view;

  DJForestScene *forestScene = [[DJForestScene alloc] initWithSize:self.view.bounds.size];
  forestScene.moc = self.moc;
  forestScene.delegate = self;
  [spriteView presentScene:forestScene];

  UIButton *backButton = [UIButton buttonWithType:UIButtonTypeRoundedRect];
  [backButton setTitle:@"Done" forState:UIControlStateNormal];
  [backButton addTarget:self action:@selector(goBack) forControlEvents:UIControlEventTouchUpInside];
  [self.view addSubview:backButton];

  self.selectorButton = [UIButton buttonWithType:UIButtonTypeCustom];
  [self.selectorButton addTarget:self action:@selector(toggleSelectorView) forControlEvents:UIControlEventTouchUpInside];
  [self.selectorButton setImage:[UIImage imageNamed:@"SelectorArrow"] forState:UIControlStateNormal];
  [self.view addSubview:self.selectorButton];

  //Add the bank view to display pending trees
  self.tileViewController = [[DJBankViewController alloc] initWithCollectionViewLayout:nil];
  self.tileViewController.moc = self.moc;
  [self addChildViewController:self.tileViewController];
  [self.view addSubview:self.tileViewController.view];

  [backButton makeConstraints:^(MASConstraintMaker *make) {
    make.right.equalTo(self.view.right).offset(-20);
    make.bottom.equalTo(self.bottomLayoutGuide).offset(-20);
  }];
  [self.tileViewController.view makeConstraints:^(MASConstraintMaker *make) {
    make.bottom.equalTo(self.view.bottom).offset(-40);
    make.left.equalTo(self.view.left);
  }];
  [self.selectorButton makeConstraints:^(MASConstraintMaker *make) {
    make.left.equalTo(self.tileViewController.view.right);
    make.centerY.equalTo(self.tileViewController.view.centerY);
  }];
}


-(void)goBack {
  [self dismissViewControllerAnimated:YES completion:nil];
}

#pragma mark  - Forest delegate

- (void)forestDidUpdateTreeCollection {
  [self.tileViewController refreshBankViewCollection];
}

-(void)toggleSelectorView{
  CGAffineTransform transform;

  if (CGRectGetWidth(self.tileViewController.view.frame) < 100){
    [self.tileViewController.view makeConstraints:^(MASConstraintMaker *make) {
      self.selectorWidth = make.width.equalTo(@250);
    }];
    transform = CGAffineTransformMakeRotation(M_PI);
  } else {
    [self.selectorWidth uninstall];
    transform = CGAffineTransformMakeRotation(2 * M_PI);
  }
  [UIView animateWithDuration:1.0 delay:0 usingSpringWithDamping:0.60f initialSpringVelocity:0.2 options:UIViewAnimationOptionCurveEaseInOut animations:^{
    [self.view layoutIfNeeded];
    self.selectorButton.transform = transform;

  } completion:^(BOOL finished) {
    [UIView animateWithDuration:1 animations:^{
    } completion:nil];
    
  } ];
  
}

@end
