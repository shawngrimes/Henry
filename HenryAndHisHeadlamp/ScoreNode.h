//
//  ScoreNode.h
//  HenryAndHisHeadlamp
//
//  Created by Shawn Grimes on 9/30/11.
//  Copyright 2011 Shawn's Bits, LLC. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "cocos2d.h"

@interface ScoreNode : CCNode {
    int score; 
}

@property (nonatomic) int score;

+(int) scoreForTime:(float)playerTime;

+(ScoreNode *) scoreOf:(int)playerScore;
+(ScoreNode *) timeOf:(float)playerTime;
@end
