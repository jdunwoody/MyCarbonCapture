//
//  DJForestViewController.h
//  MyCarbonCapture
//
//  Created by Dallas Johnson on 15/02/2014.
//  Copyright (c) 2014 Dallas Johnson. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <SpriteKit/SpriteKit.h>
#import "DJForestScene.h"

@class DJBankViewController;

@interface DJForestViewController : UIViewController <DJForestControllerUpdateDelegate>
@property (nonatomic,strong) NSManagedObjectContext * moc;

@end
