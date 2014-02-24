//
//  DJTreeContainer.h
//
//  Created by Dallas Johnson on 8/12/2013.
//  Copyright (c) 2013 Dallas Johnson. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "DJTreeTileCVController.h"

@class DJBankViewController;
@class DJThermometerView;


@interface DJTreeContainer : UIViewController <DJTreeTileCVControllerDelegate>
@property (nonatomic,strong) NSManagedObjectContext *moc;
@end
