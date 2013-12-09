//
//  DJWifiUsageModel.m
//  MyCarbonCapture
//
//  Created by Dallas Johnson on 8/12/2013.
//  Copyright (c) 2013 APDM. All rights reserved.
//

#import "DJWifiUsageModel.h"

#import <arpa/inet.h>
#import <net/if.h>
#import <ifaddrs.h>
#import <net/if_dl.h>


@interface DJWifiUsageModel ()
@property (nonatomic) long currentWebUsage;
@end

@implementation DJWifiUsageModel
static NSString * WIFI_KEY = @"WifiUsage";

//  This info was provided from the Android code for WithOneSeed:
// - 43.3kWh/GB, 840.5 CO2g/kWH = 36393.65 CO2g/GB

static double KWH_PER_GB = 43.3;
static double CO2G_PER_KWH = 840.5;
static double DOLLAR_COST_CO2_PER_TON = 23;

+(id)sharedInstance {
  static DJWifiUsageModel * sharedInstance = nil;
  static dispatch_once_t onceToken = 0;
  dispatch_once(&onceToken, ^{
    sharedInstance = [[DJWifiUsageModel alloc] init];
    sharedInstance.currentWebUsage = [[NSUserDefaults standardUserDefaults] integerForKey:WIFI_KEY];
    NSLog(@"The saved usage was %d",[[NSUserDefaults standardUserDefaults] integerForKey:WIFI_KEY]);

    NSLog(@"Dollars cost Per CO2g: $%f",sharedInstance.costPerCO2g);
    NSLog(@"CO2 grams Per Byte: %f grams",sharedInstance.co2gPerByte);
    NSLog(@"Dollars cost Per Gigabyte: $%f",sharedInstance.costPerKilobyte*1000*1000);
  });
  return sharedInstance;
}

#pragma mark - useful CO2 Units

-(double)costPerKilobyte {
  return (self.costPerCO2g * self.co2gPerByte * 1000);
}

-(double)costPerCO2g {
  // From Andrew, $23 per ton (0.000023)
  //Convert ton to g by dividing
  return DOLLAR_COST_CO2_PER_TON / 1000 / 1000;
}

-(double)co2gPerByte {
  //Convert GB to Byte
  return KWH_PER_GB * CO2G_PER_KWH / 1024 / 1024 / 1024;
}

#pragma mark - get data usage
-(int)networkUsageKB {
  struct ifaddrs *addrs;
  const struct ifaddrs *addr_cursor;
  const struct if_data *networkStats;
  int traffic = 0;
  if (getifaddrs(&addrs) == 0){
    addr_cursor = addrs;
    while (addr_cursor != NULL){
      if (addr_cursor->ifa_addr->sa_family == AF_LINK && !(addr_cursor->ifa_flags & IFF_LOOPBACK)){
        networkStats = (const struct if_data *) addr_cursor->ifa_data;
        //NSLog(@"the network interface is %s, inBytes : %d, obytes : %d",addr_cursor->ifa_name, networkStats->ifi_ibytes, networkStats->ifi_obytes);
        traffic+= networkStats->ifi_obytes + networkStats->ifi_ibytes;
      }
      addr_cursor = addr_cursor->ifa_next;
    }
    freeifaddrs(addrs);
  }
  // NSLog(@"The total traffic is %d",traffic);
  return traffic / 1024;
}

-(void)persistWebUsage {
  [[NSUserDefaults standardUserDefaults] setInteger:[self networkUsageKB] forKey:WIFI_KEY];
}

-(void)refreshNetworkStats {

}

@end
