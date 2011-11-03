//
//  MaterialSelectionLayer.m
//  HenryAndHisHeadlamp
//
//  Created by Shawn Grimes on 10/20/11.
//  Copyright 2011 Shawn's Bits, LLC. All rights reserved.
//

#import "MaterialSelectionLayer.h"
#import "GameLayer.h"
#import "UserSelectionLayer.h"

@implementation MaterialSelectionLayer

+(CCScene *) scene
{
	// 'scene' is an autorelease object.
	CCScene *scene = [CCScene node];
	
	// 'layer' is an autorelease object.
	MaterialSelectionLayer *layer = [MaterialSelectionLayer node];
	
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
        backgroundSprite=[CCSprite spriteWithFile:@"MaterialSelectScreen.png"];
        
        
        if (UI_USER_INTERFACE_IDIOM() != UIUserInterfaceIdiomPad) { 
            [[CCSpriteFrameCache sharedSpriteFrameCache] addSpriteFramesWithFile:@"MaterialSelectionButtons.plist"];
            //            batchNode = [CCSpriteBatchNode batchNodeWithFile:@"UserIconsTextures.pvr.ccz"];
        }else{
            [[CCSpriteFrameCache sharedSpriteFrameCache] addSpriteFramesWithFile:@"MaterialSelectionButtons-hd.plist"];
            //            batchNode = [CCSpriteBatchNode batchNodeWithFile:@"UserIconsTextures-hd.pvr.ccz"];
        }
#endif
        backgroundSprite.position=ccp(size.width *0.5, size.height *0.5);
        [self addChild:backgroundSprite];
        
        
        CCMenu *materialMenu;
        
        CCSprite *ABCcap_inactive=[CCSprite spriteWithSpriteFrameName:@"ABCcap_inactive.png"];
        ABCcap_inactive.tag=kGameModeUpperAlphabet;
        CCSprite *ABCcap_active=[CCSprite spriteWithSpriteFrameName:@"ABCcap_active.png"]; 
        CCMenuItemSprite *ABCcap=[CCMenuItemSprite 
                                          itemFromNormalSprite:ABCcap_inactive 
                                          selectedSprite:ABCcap_active 
                                          target:self 
                                          selector:@selector(startGame:)];
        ABCcap.anchorPoint=ccp(0,0);
        ABCcap.scale=.8629;
        ABCcap.position=ccp(size.width * 185/1024, size.height - (size.height * 292/768));
        
        CCSprite *abc_inactive=[CCSprite spriteWithSpriteFrameName:@"abc_inactive.png"];
        abc_inactive.tag=kGameModeLowerAlphabet;
        CCSprite *abc_active=[CCSprite spriteWithSpriteFrameName:@"abc_active.png"]; 
        CCMenuItemSprite *abcLower=[CCMenuItemSprite 
                                  itemFromNormalSprite:abc_inactive 
                                  selectedSprite:abc_active 
                                  target:self 
                                  selector:@selector(startGame:)];
        abcLower.anchorPoint=ccp(0,0);
        abcLower.scale=.8629;
        abcLower.position=ccp(size.width * 534/1024,  size.height - (size.height * 292/768));
        
        CCSprite *number_inactive=[CCSprite spriteWithSpriteFrameName:@"123_inactive.png"];
        number_inactive.tag=kGameModeNumbers;
        CCSprite *number_active=[CCSprite spriteWithSpriteFrameName:@"123_active.png"]; 
        CCMenuItemSprite *numberSprite=[CCMenuItemSprite 
                                    itemFromNormalSprite:number_inactive 
                                    selectedSprite:number_active 
                                    target:self 
                                    selector:@selector(startGame:)];
        numberSprite.anchorPoint=ccp(0,0);
        numberSprite.scale=.8629;
        numberSprite.position=ccp(size.width * 185/1024,size.height - ( size.height * 490/768));
        
        CCSprite *shapes_inactive=[CCSprite spriteWithSpriteFrameName:@"Shapes_inactive.png"];
        shapes_inactive.tag=kGameModeShapes;
        CCSprite *shapes_active=[CCSprite spriteWithSpriteFrameName:@"Shapes_active.png"]; 
        CCMenuItemSprite *shapeSprite=[CCMenuItemSprite 
                                        itemFromNormalSprite:shapes_inactive 
                                        selectedSprite:shapes_active 
                                        target:self 
                                        selector:@selector(startGame:)];
        shapeSprite.anchorPoint=ccp(0,0);
        shapeSprite.scale=.8629;
        shapeSprite.position=ccp(size.width * 534/1024,size.height - ( size.height * 490/768));
        
        CCSprite *all_inactive=[CCSprite spriteWithSpriteFrameName:@"PlayAll_inactive.png"];
        all_inactive.tag=5;
        CCSprite *all_active=[CCSprite spriteWithSpriteFrameName:@"PlayAll_active.png"]; 
        CCMenuItemSprite *playAllSprite=[CCMenuItemSprite 
                                       itemFromNormalSprite:all_inactive 
                                       selectedSprite:all_active 
                                       target:self 
                                       selector:@selector(startGame:)];
        playAllSprite.anchorPoint=ccp(0,0);
        playAllSprite.scale=.8616;
        playAllSprite.position=ccp(size.width * 195/1024,size.height - ( size.height * 620/768));
        
        materialMenu=[CCMenu menuWithItems:ABCcap,abcLower,numberSprite,shapeSprite,playAllSprite, nil];
       materialMenu.anchorPoint=ccp(0,0);
        materialMenu.position=ccp(size.width * 10/1024,0);
//        materialMenu.anchorPoint=ccp(0,0);
//        [materialMenu alignItemsInRows:[NSNumber numberWithInt:2],[NSNumber numberWithInt:2], [NSNumber numberWithInt:1], nil];
        [self addChild:materialMenu z:4];
        
#ifdef SMART
        [[CCSpriteFrameCache sharedSpriteFrameCache] addSpriteFramesWithFile:@"buttonsAndResources-Smart.plist"];
        CCMenuItemSprite *backSprite=[CCMenuItemSprite 
                                      itemFromNormalSprite:[CCSprite spriteWithSpriteFrameName:@"BackArrow_inactive.png"] 
                                      selectedSprite:[CCSprite spriteWithSpriteFrameName:@"BackArrow_active.png"] 
                                      target:self 
                                      selector:@selector(transitionToPrevScreen)];
        CCMenu *backMenu=[CCMenu menuWithItems:backSprite, nil];
        [self addChild:backMenu];
        backMenu.anchorPoint=ccp(0.5,0.5);
        backMenu.position=ccp(0+backSprite.contentSize.width,size.height-backSprite.contentSize.height);
#endif

        
    }
    return self;
}

-(void) startGame:(id) sender{
    CCMenuItemSprite *selectedMaterialSprite=(CCMenuItemSprite *) sender;
    
    for (CCNode *childElement in selectedMaterialSprite.children) {
        CCLOG(@"ChildELement: %@", childElement);
    }
    CCSprite *selectedSprite=(CCSprite *)[selectedMaterialSprite.children objectAtIndex:0];
    CCLOG(@"TAG: %i", selectedSprite.tag);
    [[CCDirector sharedDirector] replaceScene:[CCTransitionMoveInR transitionWithDuration:1.0f scene:[GameLayer sceneWithGameMode:(GameModeType) selectedSprite.tag]]];    

}

-(void)transitionToPrevScreen{
    [[CCDirector sharedDirector] replaceScene:
     [CCTransitionSlideInL transitionWithDuration:1.0f scene:[UserSelectionLayer scene]]];
}

@end
