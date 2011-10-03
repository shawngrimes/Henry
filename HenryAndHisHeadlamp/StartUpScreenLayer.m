//
//  StartUpScreenLayer.m
//  HenryAndHisHeadlamp
//
//  Created by Shawn Grimes on 9/29/11.
//  Copyright 2011 Shawn's Bits, LLC. All rights reserved.
//

#import "StartUpScreenLayer.h"


@implementation StartUpScreenLayer

+(CCScene *) scene
{
	// 'scene' is an autorelease object.
	CCScene *scene = [CCScene node];
	
	// 'layer' is an autorelease object.
	StartUpScreenLayer *layer = [StartUpScreenLayer node];
	
	// add layer as a child to scene
	[scene addChild: layer];
    
    //    ParentLoginViewController *parentVC=[[ParentLoginViewController alloc] init];
    //    AppDelegate *myDelegate=(AppDelegate *)[[UIApplication sharedApplication] delegate];
    //    [[myDelegate.window.subviews objectAtIndex:0] addSubview:parentVC.view];
    //    [parentVC release];
	
	// return the scene
	return scene;
}


-(id) init
{
    [TestFlight passCheckpoint:@"INIT_MAIN_SPLASH"];
	// always call "super" init
	// Apple recommends to re-assign "self" with the "super" return value
	if( (self=[super init])) {
        
        self.isTouchEnabled=YES;
        
        CGSize size = [[CCDirector sharedDirector] winSize];
        
#ifdef HALLOWEEN
        //Stuff for Lite version
        CCSprite *backgroundSprite=[CCSprite spriteWithFile:@"Henry_Spooky_Title_Screen.png"];
#else
        //Stuff for Full version
        CCSprite *backgroundSprite=[CCSprite spriteWithFile:@"campingBackground.png"];
        
#endif
        
        if (UI_USER_INTERFACE_IDIOM() != UIUserInterfaceIdiomPad) { 
            [backgroundSprite setScaleX:size.width/1024.0f];
            [backgroundSprite setScaleY:size.height/768.0f];
        }
        backgroundSprite.position=ccp(size.width/2, size.height/2);
        [self addChild:backgroundSprite];
        
        
        [[CCSpriteFrameCache sharedSpriteFrameCache] addSpriteFramesWithFile:@"buttonsAndResources-Halloween.plist"];
        CCMenuItemSprite *playSprite=[CCMenuItemSprite 
                                      itemFromNormalSprite:[CCSprite spriteWithSpriteFrameName:@"play_inactive.png"] 
                                      selectedSprite:[CCSprite spriteWithSpriteFrameName:@"play_active.png"] 
                                      target:self 
                                      selector:@selector(transitionToGamePlay)];
       
        CCMenuItemSprite *aboutSprite=[CCMenuItemSprite 
                                       itemFromNormalSprite:[CCSprite spriteWithSpriteFrameName:@"about_inactive.png"] 
                                       selectedSprite:[CCSprite spriteWithSpriteFrameName:@"about_active.png"]
                                       target:self 
                                       selector:@selector(transitionToAboutPage)];
        
        CCMenu *mainMenu=[CCMenu menuWithItems:playSprite,aboutSprite, nil];
        if (UI_USER_INTERFACE_IDIOM() != UIUserInterfaceIdiomPad) {
            [playSprite setScaleX:(size.width/1024.0f)];
            [playSprite setScaleY:(size.width/768.0f)];
            
            [aboutSprite setScaleX:(size.width/1024.0f)];
            [aboutSprite setScaleY:(size.width/768.0f)];
        }

        [mainMenu alignItemsVerticallyWithPadding:0.08*size.height];
        aboutSprite.position=ccp(.0195*size.width, aboutSprite.position.y);
        
        mainMenu.position=ccp(size.width *.5, size.height/4);

        [self addChild:mainMenu];
    }
    
    
    [TestFlight passCheckpoint:@"RETURNING_SPLASH"];
    
	return self;
    
}


-(void) transitionToGamePlay{
    [TestFlight passCheckpoint:@"LOADING_GAME_SCENE"];
//    CGSize size = [[CCDirector sharedDirector] winSize];
//        CCLabelBMFont *labelLoading=[CCLabelBMFont labelWithString:@"Loading..." fntFile:@"Corben-64.fnt"];
//#ifdef HALLOWEEN
//        labelLoading.color=ccORANGE;
//#endif
//        if (UI_USER_INTERFACE_IDIOM() != UIUserInterfaceIdiomPad) { 
//            [labelLoading setScaleX:(size.width/1024.0f)];
//            [labelLoading setScaleY:(size.height/768.0f)];
//        }
//		labelLoading.position =  ccp( size.width /2 , size.height/2 );
//		[self addChild:labelLoading];

    [self loadGameLayer];
    
//    [self schedule:@selector(loadGameLayer) interval:0.5];
}

-(void) loadGameLayer{
    [[CCDirector sharedDirector] replaceScene:
     [CCTransitionSlideInR transitionWithDuration:1.0f scene:[StoryLevel scene]]];

}

-(void) transitionToAboutPage{
    [TestFlight passCheckpoint:@"LOADING_ABOUT_SCENE"];
    [[CCDirector sharedDirector] replaceScene:
     [CCTransitionSlideInR transitionWithDuration:1.0f scene:[AboutUsLayer scene]]];
}


-(void)dealloc{
    [super dealloc];
}



@end
