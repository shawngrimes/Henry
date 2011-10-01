//
//  GameLayer.h
//  HenryAndHisHeadlamp
//
//  Created by Shawn Grimes on 9/8/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "cocos2d.h"
#import "SimpleAudioEngine.h"
#import "CharacterSprite.h"
#import "CCSpriteExtension.h"
#import "AppDelegate.h"
#import "FlurryAnalytics.h"
#import "TestFlight.h"
#import "ScoresLayer.h"

@interface GameLayer : CCLayer {
    CCSprite *_headLampLight;
    CCSprite *_henryHead;
    NSMutableArray *_arrCharacters;
    CharacterSprite *_targetCharacter;
    int winCount;
    CCLabelBMFont *_timerLabel;
    float gameTimer;
}

@property (nonatomic, retain) NSMutableArray *arrCharacters;

+(CCScene *) scene;
-(void)showTargetLabel;
-(void)gameOver;
@end
