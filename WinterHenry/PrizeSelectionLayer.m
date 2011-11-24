//
//  PrizeSelectionLayer.m
//  HenryAndHisHeadlamp
//
//  Created by Shawn Grimes on 11/24/11.
//  Copyright 2011 Shawn's Bits, LLC. All rights reserved.
//

#import "PrizeSelectionLayer.h"


@implementation PrizeSelectionLayer

enum nodeTags
{
	kScrollLayer = 256,
	kAdviceLabel = 257,
	kFastPageChangeMenu = 258,
};


-(id) init
{
	// always call "super" init
	// Apple recommends to re-assign "self" with the "super" return value
	if( (self=[super init])) {
		// Do initial positioning & create scrollLayer.
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
    CCMenu *gbManMenu=[CCMenu menuWithItems:nil];
    if (UI_USER_INTERFACE_IDIOM() != UIUserInterfaceIdiomPad) { 
        [[CCSpriteFrameCache sharedSpriteFrameCache] addSpriteFramesWithFile:@"PrizeSelectionObjects.plist"];
        CCSpriteBatchNode *batchMenuNode=[CCSpriteBatchNode batchNodeWithFile:@"PrizeSelectionObjects.pvr.ccz"];
        [self addChild:batchMenuNode];
    }else{
        [[CCSpriteFrameCache sharedSpriteFrameCache] addSpriteFramesWithFile:@"PrizeSelectionObjects-hd.plist"];
         CCSpriteBatchNode *batchMenuNode=[CCSpriteBatchNode batchNodeWithFile:@"PrizeSelectionObjects-hd.pvr.ccz"];
        [self addChild:batchMenuNode];
    }
    

	for(int x=0;x<5;x++){
        CCSprite *prizeMenuItemSprite=[CCSprite 
                                       spriteWithSpriteFrameName:
                                       [NSString stringWithFormat:@"%i.png",
                                        x]];
        CCMenuItemSprite *prizeMenuItem=[CCMenuItemSprite 
                                         itemFromNormalSprite:prizeMenuItemSprite 
                                         selectedSprite:nil target:self selector:nil];
        [gbManMenu addChild:prizeMenuItem];
    }
    
    [gbManMenu alignItemsHorizontally];
    [pageOne addChild:gbManMenu];
	
	// PAGE 2 - Custom Font Menu in the center.
	CCLayer *pageTwo = [CCLayer node];
    CCMenu *gbWomanMenu=[CCMenu menuWithItems:nil];
	for(int x=5;x<10;x++){
        CCSprite *prizeMenuItemSprite=[CCSprite 
                                       spriteWithSpriteFrameName:
                                       [NSString stringWithFormat:@"%i.png",
                                        x]];
        CCMenuItemSprite *prizeMenuItem=[CCMenuItemSprite itemFromNormalSprite:prizeMenuItemSprite selectedSprite:nil block:^(id sender) {
            CCLOG(@"Selected menu item");
        }];
        [gbWomanMenu addChild:prizeMenuItem];
    }
    [gbWomanMenu alignItemsHorizontally];
    [pageTwo addChild:gbWomanMenu];
	
	return [NSArray arrayWithObjects: pageOne,pageTwo,nil];
}

// Creates new Scroll Layer with pages returned from scrollLayerPages.
- (CCScrollLayer *) scrollLayer
{
	CGSize screenSize = [CCDirector sharedDirector].winSize;
	
	// Create the scroller and pass-in the pages (set widthOffset to 0 for fullscreen pages).
	CCScrollLayer *scroller = [CCScrollLayer nodeWithLayers: [self scrollLayerPages] widthOffset: 0.48f * screenSize.width ];
	scroller.pagesIndicatorPosition = ccp(screenSize.width * 0.5f, screenSize.height - 30.0f);
    
    // New feature: margin offset - to slowdown scrollLayer when scrolling out of it contents.
    // Comment this line or change marginOffset to screenSize.width to disable this effect.
    scroller.marginOffset = 0.5f * screenSize.width;
	
	return scroller;
}



@end
