//
//
//  Created by Dallas Johnson on 1/12/2013.
//  Copyright (c) 2013 Dallas Johnson. All rights reserved.

#import "Kiwi.h"
#import "DJWifiUsageModel.h"


SPEC_BEGIN(WifiUsageModelSpec)

describe(@"Wifi Usage Model", ^{
  let(usageModel, ^DJWifiUsageModel*{
    return [DJWifiUsageModel sharedInstance];
  });

  it(@"convert CO2 grams to bytes", ^{
    [[theValue( [usageModel co2gPerByte]) should] equal:0.000034 withDelta:0.000001];
  });

  it(@"convert CO2 grams to dollars", ^{
    [[theValue( [usageModel costPerCO2g]) should] equal:0.000023 withDelta:0.000001];
  });

  it(@"convert KBs to dollars", ^{
    DLog(@"Cost per KB %f",[usageModel costPerKilobyte]);
    [[theValue( [usageModel costPerKilobyte]) should] equal:0.000000779567 withDelta:0.000000000001];
  });

});

SPEC_END