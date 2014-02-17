//
//  DJAppDelegate.h
//
//  Created by Dallas Johnson on 1/12/2013.
//  Copyright (c) 2013 Dallas Johnson. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "DJCoredataStack.h"


@interface DJAppDelegate : UIResponder <UIApplicationDelegate>

@property (strong, nonatomic) UIWindow *window;
@property (strong, nonatomic) DJCoredataStack *coredataStack;

@end
