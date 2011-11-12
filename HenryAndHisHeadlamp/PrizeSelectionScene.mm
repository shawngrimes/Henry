//
//  PrizeSelectionScene.m
//  HenryAndHisHeadlamp
//
//  Created by Shawn Grimes on 10/21/11.
//  Copyright 2011 Shawn's Bits, LLC. All rights reserved.
//

#import "PrizeSelectionScene.h"
#import "ScoreNode.h"
#import <CoreData/CoreData.h>
#import "Player.h"
#import "Prize.h"
#import "AppDelegate.h"
#import "StartUpScreenLayer.h"

float _userTime=0.0;


@implementation PrizeSelectionScene

+(CCScene *) sceneWithTime:(float) userTime;
{
	// 'scene' is an autorelease object.
	CCScene *scene = [CCScene node];
	
	// 'layer' is an autorelease object.
	PrizeSelectionScene *layer = [PrizeSelectionScene node];
	[layer withTime:userTime];
    
	// add layer as a child to scene
	[scene addChild: layer];

	// return the scene
	return scene;
}

- (void) onEnterTransitionDidFinish {
    [self showPrizes];
    [super onEnterTransitionDidFinish];
}

-(void) showPrizes{
}


-(id) initWithTime:(float)userTime andGameModeType:(GameModeType) gameMode{
    if(self=[super init]){
        
        selectedGameMode=gameMode;
        
        [CCTexture2D PVRImagesHavePremultipliedAlpha:YES];
        
        CGSize size=[[CCDirector sharedDirector] winSize];
        
        
        CCSprite *backgroundSprite;
#if SMART
        backgroundSprite=[CCSprite spriteWithFile:@"PrizeSelectScreen.png"];
#endif
        [[CCSpriteFrameCache sharedSpriteFrameCache] removeUnusedSpriteFrames];
        
        [[CCSpriteFrameCache sharedSpriteFrameCache] addSpriteFramesWithFile:@"PrizeSelectionObjects.plist"];
        
        if (UI_USER_INTERFACE_IDIOM() != UIUserInterfaceIdiomPad) { 
            [[CCSpriteFrameCache sharedSpriteFrameCache] addSpriteFramesWithFile:@"UserIconsTextures.plist"];
        }else{
            [[CCSpriteFrameCache sharedSpriteFrameCache] addSpriteFramesWithFile:@"UserIconsTextures-hd.plist"];
        }
        
        backgroundSprite.position=ccp(size.width *0.5, size.height *0.5);
        [self addChild:backgroundSprite];
        
        _userTime=userTime;
        [self withTime:_userTime];
        
        AppDelegate *sharedAppDelegate=(AppDelegate *)[UIApplication sharedApplication].delegate;
        
        CCSprite *userIconSprite=[CCSprite spriteWithSpriteFrameName:
                                  [NSString stringWithFormat:@"%i_inactive.png", sharedAppDelegate.currentPlayerIconNumber]];  
        userIconSprite.anchorPoint=ccp(0,0.5);
        if(UI_USER_INTERFACE_IDIOM()==UIUserInterfaceIdiomPad){
            userIconSprite.scale=.5;
            userIconSprite.position=ccp(.31*size.width,size.height-size.height*.19);
        }else{
            userIconSprite.scale=.4;
            userIconSprite.position=ccp(.33*size.width,size.height-size.height*.19);
        }
        
        [self addChild:userIconSprite];
        
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
        
        CCMenu *prizeMenu;
        
        for (int x=1; x<=15; x++) {
            bool hasPrize=NO;
            for (Prize *currentPrize in prizesWonSet) {
                if ([currentPrize.prizeNumber integerValue]==x) {
                    hasPrize=YES;
                }
            }
            
            CCMenuItemSprite *prizeIconItem;
            if(x>5){
                CCSprite *activeSprite=[CCSprite spriteWithSpriteFrameName:[NSString stringWithFormat:@"Active Prize PNGs/%i_active.png",x]];
                CCSprite *inactiveSprite=[CCSprite spriteWithSpriteFrameName:[NSString stringWithFormat:@"Inactive Prize PNGs/%i_inactive.png",x]];
                inactiveSprite.tag=x;
                CCSprite *disabledSprite;
                if(hasPrize==YES){
                    disabledSprite=nil;
                }else{
                    disabledSprite=[CCSprite spriteWithSpriteFrameName:[NSString stringWithFormat:@"Gray Prize PNGs/%i_gray.png",x]];
                }
               prizeIconItem=[CCMenuItemSprite itemFromNormalSprite:inactiveSprite selectedSprite:activeSprite disabledSprite:disabledSprite target:self selector:@selector(selectPrize:)];
            }else{
                CCSprite *activeSprite=[CCSprite spriteWithSpriteFrameName:[NSString stringWithFormat:@"Active Prize PNGs/%i_active.png",x]];
                CCSprite *inactiveSprite=[CCSprite spriteWithSpriteFrameName:[NSString stringWithFormat:@"Inactive Prize PNGs/%i_inactive.png",x]];
                inactiveSprite.tag=x;
                prizeIconItem=[CCMenuItemSprite itemFromNormalSprite:inactiveSprite selectedSprite:activeSprite disabledSprite:nil target:self selector:@selector(selectPrize:)];
            }
            
            if(x==1){
                prizeMenu=[CCMenu menuWithItems:prizeIconItem, nil];
            }else{
                [prizeMenu addChild:prizeIconItem];
            }
            if(hasPrize==YES){
                if([prizesWonSet count]<15)
                    prizeIconItem.isEnabled=FALSE;
                
                CCSprite *checkMark=[CCSprite spriteWithSpriteFrameName:@"CheckMark.png"];
                [prizeIconItem addChild:checkMark];
                checkMark.position=ccp(prizeIconItem.contentSize.width * .5, prizeIconItem.contentSize.height * .5);
            }
            
            int starCount=[ScoreNode scoreForTime:userTime];
            if(starCount<5){
                if(starCount<4){
                    if(x>5){
                        prizeIconItem.isEnabled=FALSE;
                    }
                }else{
                    if(x>10){
                        prizeIconItem.isEnabled=FALSE;
                    }
                }
            }
            
            CGSize testSize=prizeIconItem.boundingBox.size;
            
            
            if(x<=5){
                if(UI_USER_INTERFACE_IDIOM() != UIUserInterfaceIdiomPad){
                    prizeIconItem.position=ccp((x-1)*testSize.width + ((x-1)*testSize.width/2),
                                        (1.15*testSize.height + testSize.height));
                }else{
                    prizeIconItem.position=ccp((x-1)*testSize.width + ((x-1)*testSize.width/2),
                                       (1.2*testSize.height + testSize.height));
                }
            }else if(x>5 && x<=10){
                if(UI_USER_INTERFACE_IDIOM() != UIUserInterfaceIdiomPad){
                    prizeIconItem.position=ccp((x-6)*testSize.width + ((x-6)*testSize.width/2),
                                                (.1*testSize.height + testSize.height));
                }else{
                    prizeIconItem.position=ccp((x-6)*testSize.width + ((x-6)*testSize.width/2),
                                                (.1*testSize.height + testSize.height));
                }
            }else if(x>10){
                if(UI_USER_INTERFACE_IDIOM() != UIUserInterfaceIdiomPad){
                    prizeIconItem.position=ccp((x-11)*testSize.width + ((x-11)*testSize.width/2),
                                                0);
                }else{
                    prizeIconItem.position=ccp((x-11)*testSize.width + ((x-11)*testSize.width/2),
                                                0);
                }
            }
        }
            
        [self addChild:prizeMenu];
        prizeMenu.anchorPoint=ccp(0,0);
        if(UI_USER_INTERFACE_IDIOM()!=UIUserInterfaceIdiomPad){
            prizeMenu.position=ccp(60,40);
        }else{
            prizeMenu.position=ccp(150,125);
        }
        [self schedule:@selector(speakPrize) interval:2.0];
    }
    return self;
}

-(void)speakPrize{
    [self unschedule:@selector(speakPrize)];
    NSString *stringToSpeak=@"Henry_Pick_Your_Prize.caf";
    NSLog(@"Saying: %@", stringToSpeak);
    CDSoundSource *_effectSpeech=[[SimpleAudioEngine sharedEngine] soundSourceForFile:stringToSpeak];
    [_effectSpeech play];
}


-(void)selectPrize:(id) sender{
    CCMenuItemSprite *selectedMaterialSprite=(CCMenuItemSprite *) sender;
    
    for (CCNode *childElement in selectedMaterialSprite.children) {
        CCLOG(@"ChildELement: %@", childElement);
    }
    
    
    CCSprite *selectedSprite=(CCSprite *)[selectedMaterialSprite.children objectAtIndex:0];
    CCLOG(@"TAG: %i", selectedSprite.tag);
    CCLOG(@"Did select sender: %i", selectedSprite.tag);
    
    NSString *gameModeString;
    switch (selectedGameMode) {
        case kGameModeUpperAlphabet:
            gameModeString=@"ABCs";
            break;
        case kGameModeLowerAlphabet:
            gameModeString=@"abcs";
            break;
        case kGameModeNumbers:
            gameModeString=@"123s";
            break;
        case kGameModeShapes:
            gameModeString=@"Shapes";
            break;
        case kGameModeSmartAll:
            gameModeString=@"All";
            break;
        default:
            break;
    }
    
       
    
    
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
    AppDelegate *sharedAppDelegate=(AppDelegate *)[UIApplication sharedApplication].delegate;
    
    NSEntityDescription *entity = [NSEntityDescription 
                                   entityForName:@"Prize" inManagedObjectContext:sharedAppDelegate.managedObjectContext];
    NSPredicate *searchPredicate=[NSPredicate predicateWithFormat:
                                  [NSString stringWithFormat:@"prizeNumber=%i", selectedSprite.tag]];
    [fetchRequest setEntity:entity];
    [fetchRequest setPredicate:searchPredicate];
    NSError *error;
    NSArray *fetchedObjects = [sharedAppDelegate.managedObjectContext executeFetchRequest:fetchRequest error:&error];
    Prize *selectedPrize;
    if([fetchedObjects count]==0){
       selectedPrize = [NSEntityDescription
                          insertNewObjectForEntityForName:@"Prize" 
                          inManagedObjectContext:sharedAppDelegate.managedObjectContext];
        selectedPrize.prizeNumber=[NSNumber numberWithInt:selectedSprite.tag];
        NSError *error;
        if (![sharedAppDelegate.managedObjectContext save:&error]) {
            CCLOG(@"Whoops, couldn't save prize: %@", [error localizedDescription]);
        }
    }else{
        if([[fetchedObjects objectAtIndex:0] isKindOfClass:[Prize class]]){
            selectedPrize=[fetchedObjects objectAtIndex:0];
        }else{
            CCLOG(@"Error getting prize");
        }
    }
    
    CCLOG(@"currentPlayer is of class: %i", [currentPlayer isKindOfClass:[Player class]]);
    [currentPlayer addPrizesObject:selectedPrize];
    if (![sharedAppDelegate.managedObjectContext save:&error]) {
        CCLOG(@"Whoops, couldn't save prize to player: %@", [error localizedDescription]);
    }
    sharedAppDelegate.currentPlayerIconNumber=selectedSprite.tag;
    [fetchRequest release];
    
    [FlurryAnalytics logEvent:@"PRIZE_PICKED" withParameters:[NSDictionary dictionaryWithObject:[NSNumber numberWithInt:selectedSprite.tag] forKey:@"PRIZE_ICON"]];
    
    
     [[CCDirector sharedDirector] replaceScene:[CCTransitionMoveInR transitionWithDuration:1.0f scene:[StartUpScreenLayer scene]]]; 
    
    
}

-(void)withTime:(float)userTime{
    CGSize size=[[CCDirector sharedDirector] winSize];
    playerScore=[ScoreNode timeOf:userTime];
    if (UI_USER_INTERFACE_IDIOM() != UIUserInterfaceIdiomPad) {
        [playerScore setScale:1.2 * (size.width/1024.0f)];
    }else{
        playerScore.scale=1.2;
    }
    playerScore.position=ccp((420.0/1024.0)*size.width,size.height-((140.0/768.0)*size.height));
    
    _userTime=userTime;
    [self addChild:playerScore];
}

-(void)dealloc{
    [currentPlayer release];
    [super dealloc];
}

@end
