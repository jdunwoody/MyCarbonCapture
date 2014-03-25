//
//
//  Created by Dallas Johnson on 1/12/2013.
//  Copyright (c) 2013 Dallas Johnson. All rights reserved.
//

#import <XCTest/XCTest.h>
#import "DJWifiUsageModel.h"

@interface MyCarbonCaptureTests : XCTestCase
@property (nonatomic,strong) DJWifiUsageModel *m;
@end

@implementation MyCarbonCaptureTests

- (void)setUp
{
  [super setUp];
  self.m = [DJWifiUsageModel sharedInstance];
}

- (void)tearDown
{
  // Put teardown code here. This method is called after the invocation of each test method in the class.
  [super tearDown];
}

- (void)testExample
{
  XCTAssertEqualWithAccuracy( self.m.co2gPerByte, 0.000034, .000001, @"CO2 per byte returning incorrect amount");
  XCTAssertEqualWithAccuracy( self.m.costPerCO2g, 0.000023, .000002, @"Cost per gram returning incorrect amount");
  XCTAssertEqualWithAccuracy( self.m.costPerKilobyte, 0.000000779567, 0.000000001, @"Cost per Kilobyte returning incorrect amount");

}

@end
