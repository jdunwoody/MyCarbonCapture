//
//  DJWifiUsageModel.h
//  MyCarbonCapture
//
//  Created by Dallas Johnson on 8/12/2013.
//  Copyright (c) 2013 Dallas Johnson. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface DJWifiUsageModel : NSObject

+(id)sharedInstance;
-(void)persistWebUsage;

-(void)refreshNetworkStats;

@property (nonatomic, readonly) double costPerKilobyte;
@property (nonatomic, readonly) double co2gPerByte;
@property (nonatomic, readonly) double costPerCO2g;

@property (nonatomic, readonly) long latestNetworkUsage;
@property (nonatomic, readonly) long savedNetworkUsage;
@end
