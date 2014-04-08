//
//  TreeSpec.m
//  MyCarbonCapture
//
//  Created by Dallas Johnson on 30/03/2014.
//  Copyright 2014 Dallas Johnson. All rights reserved.
//

#import <Kiwi/Kiwi.h>
#import "Tree.h"


SPEC_BEGIN(TreeSpec)

describe(@"Tree", ^{
  it(@"Test should get written", ^{
    [[@(false) should] beFalse];
  });
});

SPEC_END
