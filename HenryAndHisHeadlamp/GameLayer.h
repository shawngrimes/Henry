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
#import "CDAudioManager.h"

typedef enum {
    kGameModeNone=0,
    kGameModeUpperAlphabet,
    kGameModeLowerAlphabet,
    kGameModeNumbers,
    kGameModeShapes,
    kGameModeSmartAll,
} GameModeType;

@interface GameLayer : CCLayer <CDLongAudioSourceDelegate>{
    CCSprite *_headLampLight;
    CCSprite *_henryHead;
    NSMutableArray *_arrCharacters;
    CharacterSprite *_targetCharacter;
    int winCount;
    CCLabelBMFont *_timerLabel;
    float gameTimer;
    GameModeType gameMode;
    BOOL _isEffectPlaying;
    CDSoundSource *_effectSpeech;
}

@property (nonatomic, retain) NSMutableArray *arrCharacters;
@property (nonatomic, retain) CDSoundSource *effectSpeech;

+(CCScene *) sceneWithGameMode:(GameModeType)selectedGameMode;
-(id) initWithGameMode:(GameModeType) selectedGameMode;
-(void)showTargetLabel;
-(void)gameOver;
-(float)getDelayForStringFound:(CharacterSprite* )selectedCharacter;
-(void)removeFireworks;

@end
