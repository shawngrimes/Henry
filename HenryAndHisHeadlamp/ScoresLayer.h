//
//  ScoresLayer.h
//  HenryAndHisHeadlamp
//
//  Created by Shawn Grimes on 9/30/11.
//  Copyright 2011 Shawn's Bits, LLC. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "cocos2d.h"
#import "TestFlight.h"
#import "GameLayer.h"
#import "ScoreNode.h"
#import "FlurryAnalytics.h"
#import "StartUpScreenLayer.h"

typedef enum {
  kTAGuserIconMenu=70,
    kTAGiconBackground,
} sceneTags;    
    
@interface ScoresLayer : CCLayer {
}

@property (nonatomic) float timeToFindObjects;

-(void)withTime:(float)userTime;
+(CCScene *) scene;

@end
