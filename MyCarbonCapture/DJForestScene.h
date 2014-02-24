//
//  DJForest.h
//  SpritePlay
//
//  Created by Dallas Johnson on 16/02/2014.
//  Copyright (c) 2014 Dallas. All rights reserved.
//

#import <SpriteKit/SpriteKit.h>

@protocol DJForestControllerUpdateDelegate
- (void)forestDidUpdateTreeCollection;
@end

@interface DJForestScene : SKScene
@property(nonatomic,strong) NSManagedObjectContext *moc;
@property (nonatomic, weak) id<DJForestControllerUpdateDelegate>delegate;

@end
