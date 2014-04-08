//
//  DJFactShareViewController.m
//  MyCarbonCapture
//
//  Created by Dallas Johnson on 31/03/2014.
//  Copyright (c) 2014 Dallas Johnson. All rights reserved.
//


#import "DJFactShareViewController.h"
#import "Masonry.h"


@interface DJFactShareViewController ()

@property(nonatomic,strong) NSString* message;
@property ( nonatomic,strong) UILabel *messageLabel;

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
    make.centerX.equalTo(self.view.centerX);
    make.centerY.equalTo(self.view.centerY);
    make.edges.equalTo(self.view).insets(UIEdgeInsetsMake(10, 10, 10, 10));
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

@end
