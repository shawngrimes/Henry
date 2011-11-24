

//
//  UserSelectionLayer.m
//  HenryAndHisHeadlamp
//
//  Created by Shawn Grimes on 10/20/11.
//  Copyright 2011 Shawn's Bits, LLC. All rights reserved.
//

#import "UserSelectionLayer.h"
#import "StoryLevel.h"
#import "MaterialSelectionLayer.h"
#import "Player.h"
#import "PrizeSelectionScene.h"

@implementation UserSelectionLayer
+(CCScene *) scene
{
	// 'scene' is an autorelease object.
	CCScene *scene = [CCScene node];
	
	// 'layer' is an autorelease object.
	UserSelectionLayer *layer = [UserSelectionLayer node];
	
	// add layer as a child to scene
	[scene addChild: layer];
    
	
	// return the scene
	return scene;
}

-(id) init
{
	// always call "super" init
	// Apple recommends to re-assign "self" with the "super" return value
	if( (self=[super init])) {
        [CCTexture2D PVRImagesHavePremultipliedAlpha:YES];
        
        CGSize size=[[CCDirector sharedDirector] winSize];
        
        CCSprite *backgroundSprite;
#if SMART
        backgroundSprite=[CCSprite spriteWithFile:@"UserSelectScreen.png"];
#elif WINTER
        backgroundSprite=[CCSprite spriteWithFile:@"UserSelectionScreen.png"];
#endif
        
        if (UI_USER_INTERFACE_IDIOM() != UIUserInterfaceIdiomPad) { 
            [[CCSpriteFrameCache sharedSpriteFrameCache] addSpriteFramesWithFile:@"UserIconsTextures.plist"];
            batchNode = [CCSpriteBatchNode batchNodeWithFile:@"UserIconsTextures.pvr.ccz"];
        }else{
            [[CCSpriteFrameCache sharedSpriteFrameCache] addSpriteFramesWithFile:@"UserIconsTextures-hd.plist"];
            batchNode = [CCSpriteBatchNode batchNodeWithFile:@"UserIconsTextures-hd.pvr.ccz"];
        }

        backgroundSprite.position=ccp(size.width *0.5, size.height *0.5);
        [self addChild:backgroundSprite];
        
        
        CCMenu *userIconMenu;
        for(int x=1;x<=9;x++){
            CCSprite *inactiveSprite=[CCSprite spriteWithSpriteFrameName:[NSString stringWithFormat:@"%i_inactive.png", x]];
            inactiveSprite.tag=x;
//            inactiveSprite.scale=.51;
//            [batchNode addChild:inactiveSprite];
            CCSprite *activeSprite=[CCSprite spriteWithSpriteFrameName:[NSString stringWithFormat:@"%i_active.png", x]];                                      
//            [batchNode addChild:activeSprite];
            CCMenuItemSprite *userIconSprite=[CCMenuItemSprite 
                                              itemFromNormalSprite:inactiveSprite 
                                              selectedSprite:activeSprite 
                                              target:self 
                                              selector:@selector(setUserIcon:)];
            if(x==1){
                userIconMenu=[CCMenu menuWithItems:userIconSprite, nil];
            }else{
                [userIconMenu addChild:userIconSprite];
            }
            userIconSprite.position=ccp(0,0);
            userIconSprite.scale=.51;
            CGSize testSize=CGSizeMake(userIconSprite.contentSize.width * userIconSprite.scale, userIconSprite.contentSize.height * userIconSprite.scale);

            if(x<=3){
//                 CCLOG(@"ContentSize: %f x %f", userIconSprite.contentSize.width, userIconSprite.contentSize.height);
//                CCLOG(@"testSize: %f x %f", testSize.width, testSize.height);
                
                userIconSprite.position=ccp((x-1)*testSize.width + ((x-1)*testSize.width/2),
                                            0);
            }else if(x>3 && x<=6){
                if(UI_USER_INTERFACE_IDIOM() != UIUserInterfaceIdiomPad){
                    userIconSprite.position=ccp((x-4)*testSize.width + ((x-4)*testSize.width/2),
                                            (.4*testSize.height + testSize.height));
                }else{
                    userIconSprite.position=ccp((x-4)*testSize.width + ((x-4)*testSize.width/2),
                                                (.7*testSize.height + testSize.height));
                }
#if WINTER
                if(UI_USER_INTERFACE_IDIOM()==UIUserInterfaceIdiomPad){
                    userIconSprite.position=ccp(userIconSprite.position.x, userIconSprite.position.y * .8); 
                }
#endif
            }else if(x>6){
                if(UI_USER_INTERFACE_IDIOM() != UIUserInterfaceIdiomPad){
                    userIconSprite.position=ccp((x-7)*testSize.width + ((x-7)*testSize.width/2),
                                                (1.8*testSize.height + testSize.height));
                }else{
                    userIconSprite.position=ccp((x-7)*testSize.width + ((x-7)*testSize.width/2),
                                            (2.3*testSize.height + testSize.height));
                }
#if WINTER
                if(UI_USER_INTERFACE_IDIOM()==UIUserInterfaceIdiomPad){
                    userIconSprite.position=ccp(userIconSprite.position.x, userIconSprite.position.y * .83); 
                }
#endif
            }
        }
        

        
        userIconMenu.anchorPoint=ccp(0,0);
        if (UI_USER_INTERFACE_IDIOM() != UIUserInterfaceIdiomPad) { 
            //                [userIconMenu setScaleX:(size.width/1024.0f)];
            //                [userIconMenu setScaleY:(size.height/768.0f)];
            userIconMenu.position=ccp(size.width * (560.0/1024.0),size.height-(size.height * (535.0/768.0)));
        }else{
            userIconMenu.position=ccp(size.width * (540.0/1024.0),size.height-(size.height * (535.0/768.0)));
        }
#if WINTER
        if(UI_USER_INTERFACE_IDIOM()==UIUserInterfaceIdiomPad){
            userIconMenu.position=ccp(userIconMenu.position.x * 1.1, userIconMenu.position.y * 1); 
        }else{
            userIconMenu.position=ccp(userIconMenu.position.x * 1, userIconMenu.position.y * .9); 
        }
#endif
        
       
        
        [self addChild:userIconMenu z:1 tag:kTAGuserSelectionMenu];
        
        [self schedule:@selector(showUserIconAlert) interval:.5];
    }
    return self;
}

-(void)showUserIconAlert{
    [self unschedule:@selector(showUserIconAlert)];
    
    NSUserDefaults *userDefaults=[NSUserDefaults standardUserDefaults];
    NSNumber *alertCount=[userDefaults valueForKey:@"alertCount"];
    int alertCountInt=[alertCount integerValue];
    if(alertCountInt<3){
        ++alertCountInt;
        alertCount=[NSNumber numberWithInt:alertCountInt];
        [userDefaults setValue:alertCount forKey:@"alertCount"];
        [userDefaults synchronize];
        [[[UIAlertView alloc] initWithTitle:@"Attention Parents" message:@"Please have your child choose the same user icon each time in order to track their prizes.  This alert will show three times." delegate:nil cancelButtonTitle:@"Ok" otherButtonTitles:nil] show];
    }
}

-(NSString *)uuid{
    NSUserDefaults *userDefaults=[NSUserDefaults standardUserDefaults];
    NSString *uuidString=[userDefaults valueForKey:@"uuid"];
    if(uuidString==nil || [uuidString isEqualToString:@""]){
        CFUUIDRef theUUID = CFUUIDCreate(NULL);
        uuidString=[(NSString *)CFUUIDCreateString(NULL, theUUID) autorelease];
        CFRelease(theUUID);
        [userDefaults setValue:uuidString forKey:@"uuid"];
        [userDefaults synchronize];
    }
    
    return uuidString;
}

-(void)setUserIcon:(id) sender{
    
    
    
    BOOL loadInstructions=YES;
    CCMenuItemSprite *selectedMaterialSprite=(CCMenuItemSprite *) sender;
    
    CCSprite *selectedSprite=(CCSprite *)[selectedMaterialSprite.children objectAtIndex:0];

    [FlurryAnalytics setUserID:[NSString stringWithFormat:@"%@-%i", [self uuid], selectedSprite.tag]];
    
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
    AppDelegate *sharedAppDelegate=(AppDelegate *)[UIApplication sharedApplication].delegate;
    
    NSEntityDescription *entity = [NSEntityDescription 
                                   entityForName:@"Player" inManagedObjectContext:sharedAppDelegate.managedObjectContext];
    NSPredicate *searchPredicate=[NSPredicate predicateWithFormat:[NSString stringWithFormat:@"iconNumber=%i", selectedSprite.tag]];
    [fetchRequest setEntity:entity];
    [fetchRequest setPredicate:searchPredicate];
    NSError *error;
    NSArray *fetchedObjects = [sharedAppDelegate.managedObjectContext executeFetchRequest:fetchRequest error:&error];
    if([fetchedObjects count]==0){
        Player *player = [NSEntityDescription
                                           insertNewObjectForEntityForName:@"Player" 
                                           inManagedObjectContext:sharedAppDelegate.managedObjectContext];
        player.iconNumber=[NSNumber numberWithInt:selectedSprite.tag];
        NSError *error;
        if (![sharedAppDelegate.managedObjectContext save:&error]) {
            CCLOG(@"Whoops, couldn't save: %@", [error localizedDescription]);
        }
    }else{
        loadInstructions=NO;
    }
    [fetchRequest release];
    
    sharedAppDelegate.currentPlayerIconNumber=selectedSprite.tag;
    
    [FlurryAnalytics logEvent:@"USER_ICON_SELECTED" withParameters:[NSDictionary dictionaryWithObject:[NSNumber numberWithInt:selectedSprite.tag] forKey:@"USER_ICON"]];
    
    if(loadInstructions){
         [FlurryAnalytics logEvent:@"LOADING_STORY_SCENE"];
        [[CCDirector sharedDirector] replaceScene:
         [CCTransitionMoveInR transitionWithDuration:1.0 scene:[StoryLevel scene]]];
    }else{

#if SMART
        [FlurryAnalytics logEvent:@"LOADING_MATERIAL_SELECTION_SCENE"];
        [[CCDirector sharedDirector] replaceScene:
         [CCTransitionMoveInR transitionWithDuration:1.0 scene:[MaterialSelectionLayer scene]]];
#elif WINTER
        [FlurryAnalytics logEvent:@"LOADING_GAME_SCENE"];
        [[CCDirector sharedDirector] replaceScene:
         [CCTransitionMoveInR transitionWithDuration:1.0 scene:[GameLayer sceneWithGameMode:kGameModeNone]]];
#endif
    }
}




@end
