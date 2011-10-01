//
//  ScoreNode.m
//  HenryAndHisHeadlamp
//
//  Created by Shawn Grimes on 9/30/11.
//  Copyright 2011 Shawn's Bits, LLC. All rights reserved.
//

#import "ScoreNode.h"


@implementation ScoreNode

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
            starSprite.position=ccp(counter*starSprite.boundingBox.size.width+starSprite.boundingBox.size.width/2,0);
            [newScore addChild:starSprite];
        }else{
            CCSprite *starSprite=[CCSprite spriteWithSpriteFrameName:@"lg_star_unfilled.png"];
            starSprite.position=ccp(counter*starSprite.boundingBox.size.width+starSprite.boundingBox.size.width/2,0);
            [newScore addChild:starSprite];
        }
    }
    
    
    return newScore;
}


@end
