//
//  GingerBreadLayer.m
//  HenryAndHisHeadlamp
//
//  Created by Shawn Grimes on 11/23/11.
//  Copyright 2011 Shawn's Bits, LLC. All rights reserved.
//

#import "GingerBreadLayer.h"
#import "AppDelegate.h"
#import "Player.h"
#import "Prize.h"
#import <CoreData/CoreData.h>

@implementation GingerBreadLayer


-(id) init
{
	// always call "super" init
	// Apple recommends to re-assign "self" with the "super" return value
	if( (self=[super init])) {
        [CCTexture2D PVRImagesHavePremultipliedAlpha:YES];
        
        CGSize size=[[CCDirector sharedDirector] winSize];
        
        CCSprite *backgroundSprite=[CCSprite spriteWithFile:@"PrizeSelectionScreen.png"];
        backgroundSprite.position=ccp(size.width * 0.5, size.height *0.5);
        [self addChild:backgroundSprite];
        
        AppDelegate *sharedAppDelegate=(AppDelegate *)[UIApplication sharedApplication].delegate;
        NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
        
        
        NSEntityDescription *entity = [NSEntityDescription 
                                       entityForName:@"Player" inManagedObjectContext:sharedAppDelegate.managedObjectContext];
        NSPredicate *searchPredicate=[NSPredicate predicateWithFormat:[NSString stringWithFormat:@"iconNumber=%i", sharedAppDelegate.currentPlayerIconNumber]];
        [fetchRequest setEntity:entity];
        [fetchRequest setPredicate:searchPredicate];
        NSError *error;
        NSArray *fetchedObjects = [sharedAppDelegate.managedObjectContext executeFetchRequest:fetchRequest error:&error];
        NSSet *prizesWonSet;
        if([fetchedObjects count]==0){
            CCLOG(@"No user found in database");
        }else{
            currentPlayer=[[fetchedObjects objectAtIndex:0] retain];
            prizesWonSet=[NSSet setWithSet:currentPlayer.prizes];
            CCLOG(@"prizesWon Count: %i", [prizesWonSet count]);
            
        }
        [fetchRequest release];
        
        [[CCSpriteFrameCache sharedSpriteFrameCache] removeUnusedSpriteFrames];
        CCSpriteBatchNode *batchNode;
        for (Prize *currentPrize in prizesWonSet) {
            if (batchNode==nil) {
                if (UI_USER_INTERFACE_IDIOM() != UIUserInterfaceIdiomPad) { 
                    [[CCSpriteFrameCache sharedSpriteFrameCache] addSpriteFramesWithFile:@"GingerBreadObjects.plist"];
                    batchNode=[CCSpriteBatchNode batchNodeWithFile:@"GingerBreadObjects.pvr.ccz"];
                }else{
                    [[CCSpriteFrameCache sharedSpriteFrameCache] addSpriteFramesWithFile:@"GingerBreadObjects-hd.plist"];
                    batchNode=[CCSpriteBatchNode batchNodeWithFile:@"GingerBreadObjects-hd.pvr.ccz"];
                }
                [self addChild:batchNode];
            }
            //Has prize, add to GB
            CCSprite *prizeSprite=[CCSprite 
                                  spriteWithSpriteFrameName:
                                    [NSString stringWithFormat:@"%i.png",
                                     [currentPrize.prizeNumber integerValue]]];
            [batchNode addChild:prizeSprite];
            switch ([currentPrize.prizeNumber integerValue]) {
                case 0:
                    prizeSprite.position=ccp(size.width * .5, size.height *.5);
                    break;
                    
                default:
                    prizeSprite.position=ccp(size.width * .5, size.height *.5);
                    break;
            }
        }
    }
    return self;
}

@end
