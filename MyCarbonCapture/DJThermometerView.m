//
//  DJThermometerView.m
//  MyCarbonCapture
//
//  Created by Dallas Johnson on 23/02/2014.
//  Copyright (c) 2014 Dallas Johnson. All rights reserved.
//

#import "DJThermometerView.h"

@interface DJThermometerView ()
@property (nonatomic, strong) UIImageView * thermBG;

@property (nonatomic ,strong) UILabel *scaleStart;
@property (nonatomic ,strong) UILabel *scaleMiddle;
@property (nonatomic ,strong) UILabel *scaleEnd;

@property (nonatomic ,strong) UILabel *co2LabelStart;
@property (nonatomic ,strong) UILabel *co2LabelMiddle;
@property (nonatomic ,strong) UILabel *co2LabelEnd;
@property (nonatomic, strong) UIView *maskBar;
@property (nonatomic,strong) NSLayoutConstraint * maskConstraint;


@end

@implementation DJThermometerView

- (id)initWithFrame:(CGRect)frame
{
  self = [super initWithFrame:frame];
  if (self) {
    self.thermBG = [[UIImageView alloc] initWithImage:[UIImage imageNamed: @"SlideScaleBar_v1"]];

    self.scaleStart = [[UILabel alloc] initWithFrame:CGRectZero];
    self.scaleStart.text = @"$0";

    self.scaleMiddle = [[UILabel alloc] initWithFrame:CGRectZero];
    self.scaleMiddle.text = @"$2.50";

    self.scaleEnd = [[UILabel alloc] initWithFrame:CGRectZero];
    self.scaleEnd.text = @"5.00";

    self.co2LabelStart = [[UILabel alloc] initWithFrame:CGRectZero];
    self.co2LabelStart.text = @"0";

    self.co2LabelMiddle = [[UILabel alloc] initWithFrame:CGRectZero];
    self.co2LabelMiddle.text = @"500kg";

    self.co2LabelEnd = [[UILabel alloc] initWithFrame:CGRectZero];
    self.co2LabelEnd.text = @"1t";

    self.maskBar = [[UIView alloc] initWithFrame:CGRectZero];


    [self addSubview:self.scaleStart];
    [self addSubview:self.scaleMiddle];
    [self addSubview:self.scaleEnd];
    [self addSubview:self.co2LabelStart];
    [self addSubview:self.co2LabelMiddle];
    [self addSubview:self.co2LabelEnd];
    [self addSubview:self.thermBG];
    [self addSubview:self.maskBar];
    [self bringSubviewToFront:self.maskBar];
    self.maskBar.backgroundColor = [UIColor whiteColor];

    [self.subviews enumerateObjectsUsingBlock:^(UIView* view, NSUInteger idx, BOOL *stop) {
      view.translatesAutoresizingMaskIntoConstraints = NO;
    }];

    NSDictionary *viewsDict = NSDictionaryOfVariableBindings(_thermBG,_scaleStart,_scaleMiddle,_scaleEnd,_co2LabelStart,_co2LabelMiddle,_co2LabelEnd,_maskBar);
    [self addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|-20-[_thermBG]-20-|"
                                                                 options:0 metrics:nil
                                                                   views:viewsDict]];
    [self addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|[_scaleStart][_thermBG][_co2LabelStart]|"
                                                                 options:0 metrics:nil
                                                                   views:viewsDict]];

    [self addConstraint:[NSLayoutConstraint constraintWithItem:self.scaleStart attribute:NSLayoutAttributeCenterX
                                                     relatedBy:NSLayoutRelationEqual
                                                        toItem:self.thermBG attribute:NSLayoutAttributeLeft
                                                    multiplier:1 constant:0]];
    [self addConstraint:[NSLayoutConstraint constraintWithItem:self.co2LabelStart attribute:NSLayoutAttributeCenterX
                                                     relatedBy:NSLayoutRelationEqual
                                                        toItem:self.thermBG attribute:NSLayoutAttributeLeft
                                                    multiplier:1 constant:0]];
    [self addConstraint:[NSLayoutConstraint constraintWithItem:self.scaleMiddle attribute:NSLayoutAttributeCenterX
                                                     relatedBy:NSLayoutRelationEqual
                                                        toItem:self.thermBG attribute:NSLayoutAttributeCenterX
                                                    multiplier:1 constant:0]];
    [self addConstraint:[NSLayoutConstraint constraintWithItem:self.co2LabelMiddle attribute:NSLayoutAttributeCenterX
                                                     relatedBy:NSLayoutRelationEqual
                                                        toItem:self.thermBG attribute:NSLayoutAttributeCenterX
                                                    multiplier:1 constant:0]];
    [self addConstraint:[NSLayoutConstraint constraintWithItem:self.scaleEnd attribute:NSLayoutAttributeCenterX
                                                     relatedBy:NSLayoutRelationEqual
                                                        toItem:self.thermBG attribute:NSLayoutAttributeRight
                                                    multiplier:1 constant:0]];
    [self addConstraint:[NSLayoutConstraint constraintWithItem:self.co2LabelEnd attribute:NSLayoutAttributeCenterX
                                                     relatedBy:NSLayoutRelationEqual
                                                        toItem:self.thermBG attribute:NSLayoutAttributeRight
                                                    multiplier:1 constant:0]];

    [self addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"[_scaleStart]->=20-[_scaleMiddle]->=20-[_scaleEnd]"
                                                                 options:NSLayoutFormatAlignAllCenterY
                                                                 metrics:nil
                                                                   views:viewsDict]];
    [self addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"[_co2LabelStart]->=20-[_co2LabelMiddle]->=20-[_co2LabelEnd]"
                                                                 options:NSLayoutFormatAlignAllCenterY
                                                                 metrics:nil
                                                                   views:viewsDict]];

    [self addConstraint:[NSLayoutConstraint constraintWithItem:self.maskBar attribute:NSLayoutAttributeRight
                                                     relatedBy:NSLayoutRelationEqual
                                                        toItem:self.thermBG attribute:NSLayoutAttributeRight
                                                    multiplier:1 constant:-0.5]];
    [self addConstraint:[NSLayoutConstraint constraintWithItem:self.maskBar attribute:NSLayoutAttributeTop
                                                     relatedBy:NSLayoutRelationEqual
                                                        toItem:self.thermBG attribute:NSLayoutAttributeTop
                                                    multiplier:1 constant:9]];
    [self addConstraint:[NSLayoutConstraint constraintWithItem:self.maskBar attribute:NSLayoutAttributeBottom
                                                     relatedBy:NSLayoutRelationEqual
                                                        toItem:self.thermBG attribute:NSLayoutAttributeBottom
                                                    multiplier:1 constant:-1]];
    self.maskConstraint = [NSLayoutConstraint constraintWithItem:self.maskBar attribute:NSLayoutAttributeLeft
                                                       relatedBy:NSLayoutRelationEqual
                                                          toItem:self.thermBG attribute:NSLayoutAttributeLeft
                                                      multiplier:1 constant:1];
    [self addConstraint:self.maskConstraint];
    
  }
  return self;
}

-(void)setLevel:(CGFloat)level {
  if (level >=1) {
    _level = 1;
  } else {
  _level = level;

    CGFloat newConst = _level * self.thermBG.frame.size.width - 1;

    if (newConst < 1) {
      newConst = 1;
    }
    self.maskConstraint.constant = newConst;
  [self layoutIfNeeded];
  }
}



@end
