//
//  ScoreNode.m
//  HenryAndHisHeadlamp
//
//  Created by Shawn Grimes on 9/30/11.
//  Copyright 2011 Shawn's Bits, LLC. All rights reserved.
//

#import "ScoreNode.h"


@implementation ScoreNode

@synthesize score;

+(ScoreNode *) timeOf:(float)playerTime{
    ScoreNode *newScore=[ScoreNode scoreOf:[ScoreNode scoreForTime:playerTime]];;
    return newScore;
}

+(int) scoreForTime:(float)playerTime{
    int numberOfStars=0;
    if(playerTime<=30.0){
        numberOfStars=5;
    }else if(playerTime>30.0 && playerTime<=37.0){
        numberOfStars=4;
    }else if(playerTime>37.0 && playerTime<=60.0){
        numberOfStars=3;
    }else if(playerTime>60.0 && playerTime<=90.0){
        numberOfStars=2;
    }else if(playerTime>90.0 && playerTime<=120.0){
        numberOfStars=1;
    }else{
        numberOfStars=0;
    }
    return numberOfStars;
}

+(ScoreNode *) scoreOf:(int)playerScore {
    //    NSString *frameName;
    
//    CGSize size = [[CCDirector sharedDirector] winSize];
    
    ScoreNode *newScore=[[[ScoreNode alloc] init] autorelease];
    
    CCSpriteFrameCache *frameCache=[CCSpriteFrameCache sharedSpriteFrameCache];
#ifdef HALLOWEEN
    [frameCache addSpriteFramesWithFile:@"HenryBodyTextures.plist"];
#elif SMART
    [frameCache addSpriteFramesWithFile:@"PrizeSelectionObjects.plist"];
#endif
    
    for(int counter=0;counter<5;counter++){
        if(counter<playerScore){
            CCSprite *starSprite;
#ifdef HALLOWEEN
            starSprite=[CCSprite spriteWithSpriteFrameName:@"lg_star_filled.png"];
#elif SMART
            starSprite=[CCSprite spriteWithSpriteFrameName:@"FilledStar.png"];
#endif
            if(UI_USER_INTERFACE_IDIOM()==UIUserInterfaceIdiomPad){
                starSprite.scale=.5;
            }
            starSprite.position=ccp(counter*starSprite.boundingBox.size.width+starSprite.boundingBox.size.width/2,0);
            [newScore addChild:starSprite];
        }else{
            CCSprite *starSprite;
#ifdef HALLOWEEN
            starSprite=[CCSprite spriteWithSpriteFrameName:@"lg_star_unfilled.png"];
#elif SMART
            starSprite=[CCSprite spriteWithSpriteFrameName:@"UnfilledStar.png"];
#endif
            if(UI_USER_INTERFACE_IDIOM()==UIUserInterfaceIdiomPad){
                starSprite.scale=.5;
            }
            starSprite.position=ccp(counter*starSprite.boundingBox.size.width+starSprite.boundingBox.size.width/2,0);
            [newScore addChild:starSprite];
        }
    }
    
    
    return newScore;
}


@end
