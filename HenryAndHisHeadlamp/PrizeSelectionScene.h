//
//  PrizeSelectionScene.h
//  HenryAndHisHeadlamp
//
//  Created by Shawn Grimes on 10/21/11.
//  Copyright 2011 Shawn's Bits, LLC. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "cocos2d.h"
#import "GameLayer.h"

@class ScoreNode;
@class AppDelegate;
@class Player;



@interface PrizeSelectionScene : CCLayer {
    ScoreNode *playerScore;
    Player *currentPlayer;
    GameModeType selectedGameMode;
    CCMenu *prizeSelectionMenu;
}



+(CCScene *) sceneWithTime:(float) userTime;
//-(id) initWithTime:(float)userTime;
-(id) initWithTime:(float)userTime andGameModeType:(GameModeType) gameMode;
-(void)withTime:(float)userTime;
-(void) showPrizes;
-(void)speakPrize;
-(void)loadStartup;

@end
