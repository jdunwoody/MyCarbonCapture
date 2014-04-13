//
//  DJFactShareViewController.m
//  MyCarbonCapture
//
//  Created by Dallas Johnson on 31/03/2014.
//  Copyright (c) 2014 Dallas Johnson. All rights reserved.
//


#import "DJFactShareViewController.h"
#import "Masonry.h"
#import <Social/Social.h>


@interface DJFactShareViewController ()

@property (nonatomic,strong) NSString* message;
@property (nonatomic,strong) UILabel *messageLabel;
@property (nonatomic,strong) UIButton *shareButton;
@property (nonatomic,strong) UIButton* dismissButton;

@end

@implementation DJFactShareViewController

-(id)init{
  self = [super init];
  if (self) {
    self.view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 200, 100)];
    self.messageLabel =[[UILabel alloc] init];
    self.messageLabel.numberOfLines = 0;
    [self.messageLabel setContentCompressionResistancePriority:UILayoutPriorityRequired forAxis:UILayoutConstraintAxisVertical];
    [self.view  addSubview:self.messageLabel];
    self.shareButton = ({UIButton* b = [UIButton buttonWithType:UIButtonTypeSystem];
      [b addTarget:self action:@selector(shareFact) forControlEvents:UIControlEventTouchUpInside];
      [b setTitle:@"Share" forState:UIControlStateNormal];
      b;
    });
    self.dismissButton = ({UIButton* b = [UIButton buttonWithType:UIButtonTypeSystem];
      [b addTarget:self action:@selector(dismiss) forControlEvents:UIControlEventTouchUpInside];
      [b setTitle:@"OK" forState:UIControlStateNormal];
      b;
    });

    [self.view addSubview:self.shareButton];
    [self.view addSubview:self.dismissButton];
    self.view.backgroundColor =[UIColor colorWithRed:0.680 green:0.759 blue:0.683 alpha:1.000];
    self.view.layer.cornerRadius = 6.0;
    self.view.translatesAutoresizingMaskIntoConstraints = NO;
  }
  return self;
}

-(void)viewWillAppear:(BOOL)animated{

}

-(void)setMessage:(NSString *)message{
  if ([message isEqualToString:_message]) {
    return;
  }
  _message = message;
  self.messageLabel.text = message;
  [self.view setNeedsLayout];
}

-(void)updateViewConstraints{
  [self.view makeConstraints:^(MASConstraintMaker *make) {
    make.width.equalTo(@200).priorityHigh();
  }];

  [self.messageLabel mas_makeConstraints:^(MASConstraintMaker *make) {
    make.left.equalTo(self.view.left).offset(10);
    make.top.equalTo(self.view.top).offset(10);
    make.right.equalTo(self.view.right).offset(-10);
  }];
  [self.dismissButton makeConstraints:^(MASConstraintMaker *make) {
    make.right.equalTo(self.view.right).offset(-20);
    make.centerY.equalTo(self.shareButton.centerY);
  }];
  [self.shareButton mas_makeConstraints:^(MASConstraintMaker *make) {
    make.right.equalTo(self.dismissButton.left).offset(-20);
    make.top.equalTo(self.messageLabel.bottom);
    make.bottom.equalTo(self.view.bottom).offset(-10);
  }];

  [super updateViewConstraints];
}

+(DJFactShareViewController *)withMessage:(NSString *)message{
  DJFactShareViewController * factShareView = [[DJFactShareViewController alloc] init];
  if (factShareView) {
    factShareView.message = message;

  }
  return factShareView;
}

#pragma mark fact Sharing

-(void)shareFact {
  DLog(@"Sharing fact");
  //if ([SLComposeViewController isAvailableForServiceType:SLServiceTypeTwitter]) {
  SLComposeViewController *socialViewController = [SLComposeViewController composeViewControllerForServiceType:SLServiceTypeTwitter];
  //  (SLComposeViewControllerResult)(^SLComposeViewControllerCompletionHandler)(void){nil; return SLComposeViewControllerResultDone;}
  //  [socialViewController setCompletionHandler:handler];
  //
  [socialViewController setInitialText:self.message];

  [self presentViewController:socialViewController animated:YES completion:nil];
  //}
}
#pragma mark Dismiss Me
-(void)dismiss {
  DLog();
  [self.view removeFromSuperview];
  [self removeFromParentViewController];
}

@end
