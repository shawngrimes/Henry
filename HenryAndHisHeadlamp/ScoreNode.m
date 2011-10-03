//
//  ScoreNode.m
//  HenryAndHisHeadlamp
//
//  Created by Shawn Grimes on 9/30/11.
//  Copyright 2011 Shawn's Bits, LLC. All rights reserved.
//

#import "ScoreNode.h"


@implementation ScoreNode

+(ScoreNode *) timeOf:(float)playerTime{
    ScoreNode *newScore;
    if(playerTime<=15.0){
        newScore=[ScoreNode scoreOf:5];
    }else if(playerTime>15.0 && playerTime<=30.0){
        newScore=[ScoreNode scoreOf:4];
    }else if(playerTime>30.0 && playerTime<=60.0){
        newScore=[ScoreNode scoreOf:3];
    }else if(playerTime>60.0 && playerTime<=90.0){
        newScore=[ScoreNode scoreOf:2];
    }else if(playerTime>90.0 && playerTime<=120.0){
        newScore=[ScoreNode scoreOf:1];
    }else{
        newScore=[ScoreNode scoreOf:0];
    }
    return newScore;
}

+(ScoreNode *) scoreOf:(int)playerScore {
    //    NSString *frameName;
    
//    CGSize size = [[CCDirector sharedDirector] winSize];
    
    ScoreNode *newScore=[[[ScoreNode alloc] init] autorelease];
    
    CCSpriteFrameCache *frameCache=[CCSpriteFrameCache sharedSpriteFrameCache];
#ifdef HALLOWEEN
    [frameCache addSpriteFramesWithFile:@"HenryBodyTextures.plist"];
#else
    [frameCache addSpriteFramesWithFile:@"characterTextures.plist"];
#endif
    
    for(int counter=0;counter<5;counter++){
        if(counter<playerScore){
            CCSprite *starSprite=[CCSprite spriteWithSpriteFrameName:@"lg_star_filled.png"];
            starSprite.scale=.75;
            starSprite.position=ccp(counter*starSprite.boundingBox.size.width+starSprite.boundingBox.size.width/2,0);
            [newScore addChild:starSprite];
        }else{
            CCSprite *starSprite=[CCSprite spriteWithSpriteFrameName:@"lg_star_unfilled.png"];
            starSprite.scale=.75;
            starSprite.position=ccp(counter*starSprite.boundingBox.size.width+starSprite.boundingBox.size.width/2,0);
            [newScore addChild:starSprite];
        }
    }
    
    
    return newScore;
}


@end
