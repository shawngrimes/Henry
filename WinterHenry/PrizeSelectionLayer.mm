//
//  PrizeSelectionLayer.m
//  HenryAndHisHeadlamp
//
//  Created by Shawn Grimes on 11/24/11.
//  Copyright 2011 Shawn's Bits, LLC. All rights reserved.
//

#import "PrizeSelectionLayer.h"
#import <CoreData/CoreData.h>
#import "AppDelegate.h"
#import "Player.h"
#import "Prize.h"
#import "FlurryAnalytics.h"
#import "GingerBreadLayer.h"
#import "StartUpScreenLayer.h"

@implementation PrizeSelectionLayer
@synthesize prizeHeight;
//@synthesize currentPlayer;
@synthesize gingerBreadLayer;

enum nodeTags
{
	kScrollLayer = 256,
	kAdviceLabel = 257,
	kFastPageChangeMenu = 258,
};

-(void)loadStartup{
    [[CCDirector sharedDirector] replaceScene:[CCTransitionMoveInR transitionWithDuration:1.0f scene:[StartUpScreenLayer scene]]];
}

-(id) initWithGingerBreadLayer:(GingerBreadLayer *)gbLayer
{
	// always call "super" init
	// Apple recommends to re-assign "self" with the "super" return value
	if( (self=[super init])) {
		// Do initial positioning & create scrollLayer.
//        CCLayerColor *colorLayer=[CCLayerColor layerWithColor:ccc4(128, 48, 200, 255)];
//        [self addChild:colorLayer];
        self.gingerBreadLayer=gbLayer;
		[self updateForScreenReshape];
	}
	return self;
}

- (void) updateForScreenReshape
{
	CGSize screenSize = [CCDirector sharedDirector].winSize;
	
	// ReCreate Scroll Layer for each Screen Reshape (slow, but easy).
	CCScrollLayer *scrollLayer = (CCScrollLayer *)[self getChildByTag:kScrollLayer];
	if (scrollLayer)
	{
		[self removeChild:scrollLayer cleanup:YES];
	}
	
	scrollLayer = [self scrollLayer];
	[self addChild: scrollLayer z: 0 tag: kScrollLayer];
	[scrollLayer selectPage: 0];
	scrollLayer.delegate = self;
}


#pragma mark ScrollLayer Creation

// Returns array of CCLayers - pages for ScrollLayer.
- (NSArray *) scrollLayerPages
{
	CGSize screenSize = [CCDirector sharedDirector].winSize;
	
    [CCTexture2D PVRImagesHavePremultipliedAlpha:YES];
    
	// PAGE 1 - Simple Label in the center.
	CCLayer *pageOne = [CCLayer node];
    gbManMenu=[CCMenu menuWithItems:nil];
    if (UI_USER_INTERFACE_IDIOM() != UIUserInterfaceIdiomPad) { 
        [[CCSpriteFrameCache sharedSpriteFrameCache] addSpriteFramesWithFile:@"PrizeSelectionObjects.plist"];
        CCSpriteBatchNode *batchMenuNode=[CCSpriteBatchNode batchNodeWithFile:@"PrizeSelectionObjects.pvr.ccz"];
        [self addChild:batchMenuNode];
    }else{
        [[CCSpriteFrameCache sharedSpriteFrameCache] addSpriteFramesWithFile:@"PrizeSelectionObjects-hd.plist"];
         CCSpriteBatchNode *batchMenuNode=[CCSpriteBatchNode batchNodeWithFile:@"PrizeSelectionObjects-hd.pvr.ccz"];
        [self addChild:batchMenuNode];
    }

    [FlurryAnalytics logEvent:@"TOTAL_PRIZES_WON" withParameters:[NSDictionary dictionaryWithObject:[NSNumber numberWithInt:[self.gingerBreadLayer.prizesWonSet count]] forKey:@"PRIZES_WON_COUNT"]];

    CCLOG(@"Prizes Won Count: %i", [self.gingerBreadLayer.prizesWonSet count]);
    
	for(int x=0;x<5;x++){
        BOOL alreadyWon=NO;
        for (Prize *prizeInSet in self.gingerBreadLayer.prizesWonSet) {
            if ([prizeInSet.prizeNumber integerValue]==x) {
                alreadyWon=YES;
                break;
            }
        }
        if(!alreadyWon){
            CCSprite *prizeMenuItemSprite=[CCSprite 
                                           spriteWithSpriteFrameName:
                                           [NSString stringWithFormat:@"%i.png",
                                            x]];
            prizeMenuItemSprite.tag=x;
            if(prizeMenuItemSprite.contentSize.height>self.prizeHeight){
                self.prizeHeight=prizeMenuItemSprite.contentSize.height;
            }
            CCMenuItemSprite *prizeMenuItem=[CCMenuItemSprite 
                                             itemFromNormalSprite:prizeMenuItemSprite 
                                             selectedSprite:nil block:^(id sender) {
                                                 CCLOG(@"Selected menu item");
                                                 CCMenuItemSprite *selectedMaterialSprite=(CCMenuItemSprite *) sender;
                                                                                              
                                                 CCSprite *selectedSprite=(CCSprite *)[selectedMaterialSprite.children objectAtIndex:0];
                                                 CCLOG(@"TAG: %i", selectedSprite.tag);
                                                 CCLOG(@"Did select sender: %i", selectedSprite.tag);
     
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
                                                                                      
                                                 if(self.currentPlayer!=nil){
                                                     [self.currentPlayer addPrizesObject:selectedPrize];
                                                     if (![sharedAppDelegate.managedObjectContext save:&error]) {
                                                         CCLOG(@"Whoops, couldn't save prize to player: %@", [error localizedDescription]);
                                                     }
                                                     [fetchRequest release];
                                                     
                                                     [FlurryAnalytics logEvent:@"PRIZE_PICKED" withParameters:[NSDictionary dictionaryWithObject:[NSNumber numberWithInt:selectedSprite.tag] forKey:@"PRIZE_ICON"]];
                                                     [gbManMenu setVisible:NO];
                                                     [gbWomanMenu setVisible:NO];
                                                     [self.gingerBreadLayer refreshPrizes];
                                                 }
                                             [self schedule:@selector(loadStartup) interval:2.5];      
                                                 
                                             }];
            [gbManMenu addChild:prizeMenuItem];
        }
    }
    if([gbManMenu.children count]==0){
        CCMenuItemFont *menuItemFont = [CCMenuItemFont itemFromString:@"No more pieces here" block:^(id sender) {
            [gbManMenu removeChild:sender cleanup:YES];
            [self schedule:@selector(loadStartup) interval:2.5];
        }];
        [gbManMenu addChild:menuItemFont];
    }
    [gbManMenu alignItemsHorizontallyWithPadding:screenSize.width/20.0];
    [pageOne addChild:gbManMenu];
    
	
	// PAGE 2 - Custom Font Menu in the center.
	CCLayer *pageTwo = [CCLayer node];
    gbWomanMenu=[CCMenu menuWithItems:nil];
	for(int x=5;x<10;x++){
        BOOL alreadyWon=NO;
        for (Prize *prizeInSet in self.gingerBreadLayer.prizesWonSet) {
            if ([prizeInSet.prizeNumber integerValue]==x) {
                alreadyWon=YES;
            }
        }
        if(!alreadyWon){
            CCSprite *prizeMenuItemSprite=[CCSprite 
                                           spriteWithSpriteFrameName:
                                           [NSString stringWithFormat:@"%i.png",
                                            x]];
            prizeMenuItemSprite.tag=x;
            
            if(prizeMenuItemSprite.contentSize.height>self.prizeHeight){
                self.prizeHeight=prizeMenuItemSprite.contentSize.height;
            }
            CCMenuItemSprite *prizeMenuItem=[CCMenuItemSprite itemFromNormalSprite:prizeMenuItemSprite selectedSprite:nil block:^(id sender) {
                CCLOG(@"Selected menu item");
                CCMenuItemSprite *selectedMaterialSprite=(CCMenuItemSprite *) sender;
                
                CCSprite *selectedSprite=(CCSprite *)[selectedMaterialSprite.children objectAtIndex:0];
                CCLOG(@"TAG: %i", selectedSprite.tag);
                CCLOG(@"Did select sender: %i", selectedSprite.tag);
                
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
                
                if(self.currentPlayer!=nil){
                    [self.currentPlayer addPrizesObject:selectedPrize];
                    if (![sharedAppDelegate.managedObjectContext save:&error]) {
                        CCLOG(@"Whoops, couldn't save prize to player: %@", [error localizedDescription]);
                    }
                    [fetchRequest release];
                    
                    [FlurryAnalytics logEvent:@"PRIZE_PICKED" withParameters:[NSDictionary dictionaryWithObject:[NSNumber numberWithInt:selectedSprite.tag] forKey:@"PRIZE_ICON"]];
                    [gbManMenu setVisible:NO];
                    [gbWomanMenu setVisible:NO];
                    [self.gingerBreadLayer refreshPrizes];
                }
              [self schedule:@selector(loadStartup) interval:2.5];      
                
            }];
            [gbWomanMenu addChild:prizeMenuItem];
        }
    }
    
    if([gbWomanMenu.children count]==0){
        CCMenuItemFont *menuItemFont = [CCMenuItemFont itemFromString:@"No more pieces here" block:^(id sender) {
            [gbWomanMenu removeChild:sender cleanup:YES];
            [self schedule:@selector(loadStartup) interval:2.5];
        }];
        [gbWomanMenu addChild:menuItemFont];
    }

    
    [gbWomanMenu alignItemsHorizontallyWithPadding:screenSize.width/20.0];
    [pageTwo addChild:gbWomanMenu];
//    gbManMenu.anchorPoint=ccp(0,0.5);
    gbManMenu.position=ccp(gbManMenu.position.x,screenSize.height-self.prizeHeight);
//    gbWomanMenu.anchorPoint=ccp(0,0.5);
    gbWomanMenu.position=ccp(gbWomanMenu.position.x,screenSize.height-self.prizeHeight);
    
	return [NSArray arrayWithObjects: pageOne,pageTwo,nil];
}

-(Player *)currentPlayer{
    AppDelegate *sharedAppDelegate=(AppDelegate *)[UIApplication sharedApplication].delegate;
    Player *activePlayer;
    
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];

    NSEntityDescription *entity = [NSEntityDescription 
                                   entityForName:@"Player" inManagedObjectContext:sharedAppDelegate.managedObjectContext];
    NSPredicate *searchPredicate=[NSPredicate predicateWithFormat:[NSString stringWithFormat:@"iconNumber=%i", sharedAppDelegate.currentPlayerIconNumber]];
    CCLOG(@"search Predicate: %@", searchPredicate);
    [fetchRequest setEntity:entity];
    [fetchRequest setPredicate:searchPredicate];
    NSError *error;
    NSArray *fetchedObjects = [sharedAppDelegate.managedObjectContext executeFetchRequest:fetchRequest error:&error];
    if([fetchedObjects count]==0){
        CCLOG(@"No user found in database");
    }else{
        activePlayer=[[fetchedObjects objectAtIndex:0] retain];
    }
    
    [fetchRequest release];
    
    return activePlayer;
}

// Creates new Scroll Layer with pages returned from scrollLayerPages.
- (CCScrollLayer *) scrollLayer
{
	CGSize screenSize = [CCDirector sharedDirector].winSize;
	
	// Create the scroller and pass-in the pages (set widthOffset to 0 for fullscreen pages).
	CCScrollLayer *scroller = [CCScrollLayer nodeWithLayers: [self scrollLayerPages] widthOffset: 0.25f * screenSize.width ];
	scroller.pagesIndicatorPosition = ccp(screenSize.width * 0.5f, screenSize.height - 30.0f);
    
    // New feature: margin offset - to slowdown scrollLayer when scrolling out of it contents.
    // Comment this line or change marginOffset to screenSize.width to disable this effect.
    scroller.marginOffset = 0.2f * screenSize.width;
	
	return scroller;
}



@end
