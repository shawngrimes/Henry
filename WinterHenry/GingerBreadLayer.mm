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
        [self refreshPrizes];
    }
    return self;
}

-(NSSet *)prizesWonSet{
    AppDelegate *sharedAppDelegate=(AppDelegate *)[UIApplication sharedApplication].delegate;
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
    
    
    NSEntityDescription *entity = [NSEntityDescription 
                                   entityForName:@"Player" inManagedObjectContext:sharedAppDelegate.managedObjectContext];
    NSPredicate *searchPredicate=[NSPredicate predicateWithFormat:[NSString stringWithFormat:@"iconNumber=%i", sharedAppDelegate.currentPlayerIconNumber]];
    CCLOG(@"Search Predicate: %@", searchPredicate);
    
    [fetchRequest setEntity:entity];
    [fetchRequest setPredicate:searchPredicate];
    NSError *error;
    NSArray *fetchedObjects = [sharedAppDelegate.managedObjectContext executeFetchRequest:fetchRequest error:&error];
    NSSet *prizesWon;
    if([fetchedObjects count]==0){
        CCLOG(@"No user found in database");
    }else{
        currentPlayer=[[fetchedObjects objectAtIndex:0] retain];
        prizesWon=[NSSet setWithSet:currentPlayer.prizes];
        CCLOG(@"prizesWon Count: %i", [prizesWon count]);
    }
    [fetchRequest release];
    return prizesWon;
}

-(void)refreshPrizes{
    
    
    CGSize size=[[CCDirector sharedDirector] winSize];
//    
//    AppDelegate *sharedAppDelegate=(AppDelegate *)[UIApplication sharedApplication].delegate;
//    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
//    
//    
//    NSEntityDescription *entity = [NSEntityDescription 
//                                   entityForName:@"Player" inManagedObjectContext:sharedAppDelegate.managedObjectContext];
//    NSPredicate *searchPredicate=[NSPredicate predicateWithFormat:[NSString stringWithFormat:@"iconNumber=%i", sharedAppDelegate.currentPlayerIconNumber]];
//    CCLOG(@"Search Predicate: %@", searchPredicate);
//    
//    [fetchRequest setEntity:entity];
//    [fetchRequest setPredicate:searchPredicate];
//    NSError *error;
//    NSArray *fetchedObjects = [sharedAppDelegate.managedObjectContext executeFetchRequest:fetchRequest error:&error];
//    NSSet *prizesWonSet;
//    if([fetchedObjects count]==0){
//        CCLOG(@"No user found in database");
//    }else{
//        currentPlayer=[[fetchedObjects objectAtIndex:0] retain];
//        prizesWonSet=[NSSet setWithSet:currentPlayer.prizes];
//        CCLOG(@"prizesWon Count: %i", [prizesWonSet count]);
//    }
//    [fetchRequest release];
    
//    [[CCSpriteFrameCache sharedSpriteFrameCache] removeUnusedSpriteFrames];
    CCSpriteBatchNode *batchNode;
    if (UI_USER_INTERFACE_IDIOM() != UIUserInterfaceIdiomPad) { 
        [[CCSpriteFrameCache sharedSpriteFrameCache] addSpriteFramesWithFile:@"GingerBreadObjects.plist"];
        batchNode=[CCSpriteBatchNode batchNodeWithFile:@"GingerBreadObjects.pvr.ccz"];
    }else{
        [[CCSpriteFrameCache sharedSpriteFrameCache] addSpriteFramesWithFile:@"GingerBreadObjects-hd.plist"];
        batchNode=[CCSpriteBatchNode batchNodeWithFile:@"GingerBreadObjects-hd.pvr.ccz"];
    }
    [self addChild:batchNode z:5];

    for (Prize *currentPrize in self.prizesWonSet) {
        //Has prize, add to GB
        CCSprite *prizeSprite=[CCSprite 
                               spriteWithSpriteFrameName:
                               [NSString stringWithFormat:@"%i.png",
                                [currentPrize.prizeNumber integerValue]]];
        [batchNode addChild:prizeSprite z:5];
        switch ([currentPrize.prizeNumber integerValue]) {
            case 0:
                prizeSprite.position=ccp(size.width * 330.0/1024.0, size.height - size.height * 260.0/768.0);
                break;
                
            case 1:
                prizeSprite.position=ccp(size.width * 330.0/1024.0, size.height - size.height * 190.0/768.0);
                break;
            case 2:
                prizeSprite.position=ccp(size.width * 175.0/1024.0, size.height - size.height * 300.0/768.0);
                break;
            case 3:
                prizeSprite.position=ccp(size.width * 330.0/1024.0, size.height - size.height * 395.0/768.0);
                break;
            case 4:
                prizeSprite.position=ccp(size.width * 330.0/1024.0, size.height - size.height * 325.0/768.0);
                [batchNode reorderChild:prizeSprite z:4];
                break;
            case 5:
                prizeSprite.position=ccp(size.width * 685.0/1024.0, size.height - size.height * 370.0/768.0);                
                break;

            case 6:
                prizeSprite.position=ccp(size.width * 685.0/1024.0, size.height - size.height * 200.0/768.0);                
                break;
            case 7:
                prizeSprite.position=ccp(size.width * 815.0/1024.0, size.height - size.height * 320.0/768.0);  
                break;
            case 8:
                prizeSprite.position=ccp(size.width * 655.0/1024.0, size.height - size.height * 137.0/768.0);                  
                break;
            case 9:
                prizeSprite.position=ccp(size.width * 685.0/1024.0, size.height - size.height * 310.0/768.0);                
                [batchNode reorderChild:prizeSprite z:4];
                break;

            default:
                prizeSprite.position=ccp(size.width * 330.0/1024.0, size.height - size.height * 190.0/768.0);
                break;
        }
    }
}

@end
