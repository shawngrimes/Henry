//
//  GingerBreadLayer.h
//  HenryAndHisHeadlamp
//
//  Created by Shawn Grimes on 11/23/11.
//  Copyright 2011 Shawn's Bits, LLC. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "cocos2d.h"

@class Player;

@interface GingerBreadLayer : CCLayer {
    Player *currentPlayer;
}

@property (nonatomic, retain, readonly) NSSet *prizesWonSet;

-(void)refreshPrizes;

@end
