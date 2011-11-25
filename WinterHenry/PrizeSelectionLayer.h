//
//  PrizeSelectionLayer.h
//  HenryAndHisHeadlamp
//
//  Created by Shawn Grimes on 11/24/11.
//  Copyright 2011 Shawn's Bits, LLC. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "cocos2d.h"
#import "CCScrollLayer.h"

@class GingerBreadLayer;
@class Player;

@interface PrizeSelectionLayer : CCLayer <CCScrollLayerDelegate> {
    CCMenu *gbManMenu;
    CCMenu *gbWomanMenu;
}

@property (nonatomic, retain, readonly) Player *currentPlayer;
@property (nonatomic) float prizeHeight;
@property (nonatomic, retain) GingerBreadLayer *gingerBreadLayer;

-(id) initWithGingerBreadLayer:(GingerBreadLayer *)gbLayer;

@end
