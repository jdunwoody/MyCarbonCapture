//
//  DJForestViewController.m
//  MyCarbonCapture
//
//  Created by Dallas Johnson on 15/02/2014.
//  Copyright (c) 2014 Dallas Johnson. All rights reserved.
//

#import "DJForestViewController.h"
#import "DJForestScene.h"

@interface DJForestViewController ()

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
  [spriteView showsFPS];
  [spriteView showsDrawCount];
  [spriteView showsNodeCount];

  DJForestScene *forestScene = [[DJForestScene alloc] initWithSize:self.view.bounds.size];
  [spriteView presentScene:forestScene];

  UIButton *backButton = [UIButton buttonWithType:UIButtonTypeRoundedRect];
  [backButton setTitle:@"Done" forState:UIControlStateNormal];

  [backButton addTarget:self action:@selector(goBack) forControlEvents:UIControlEventTouchUpInside];
  [self.view addSubview:backButton];

  backButton.translatesAutoresizingMaskIntoConstraints = NO;

  NSDictionary * viewsDict = @{@"backButton":backButton};
  [self.view addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:[backButton]-|" options:0 metrics:nil views:viewsDict]];
  [self.view addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:[backButton]-|" options:0 metrics:nil views:viewsDict]];
}

-(void)goBack {
  [self dismissViewControllerAnimated:YES completion:^{
    nil;
  }];
}

@end
