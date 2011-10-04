//
//  AboutUsLayer.m
//  HenryAndHisHeadlamp
//
//  Created by Shawn Grimes on 9/29/11.
//  Copyright 2011 Shawn's Bits, LLC. All rights reserved.
//

#import "AboutUsLayer.h"


@implementation AboutUsLayer

+(CCScene *) scene
{
	// 'scene' is an autorelease object.
	CCScene *scene = [CCScene node];
	
	// 'layer' is an autorelease object.
	AboutUsLayer *layer = [AboutUsLayer node];
	
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
    [TestFlight passCheckpoint:@"INIT_ABOUT_US"];
	// always call "super" init
	// Apple recommends to re-assign "self" with the "super" return value
	if( (self=[super init])) {
        
        self.isTouchEnabled=YES;
        
        CGSize size = [[CCDirector sharedDirector] winSize];
        
#ifdef HALLOWEEN
        //Stuff for Lite version
        CCSprite *backgroundSprite=[CCSprite spriteWithFile:@"Henry_Spooky_About_Page.png"];
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
        CCMenuItemSprite *backSprite=[CCMenuItemSprite 
                                      itemFromNormalSprite:[CCSprite spriteWithSpriteFrameName:@"back_inactive.png"] 
                                      selectedSprite:[CCSprite spriteWithSpriteFrameName:@"back_active.png"] 
                                      target:self 
                                      selector:@selector(transitionToStartUpScreen)];
        
//        CCMenuItemSprite *rateSprite=[CCMenuItemSprite 
//                                       itemFromNormalSprite:[CCSprite spriteWithSpriteFrameName:@"rate_inactive.png"] 
//                                       selectedSprite:[CCSprite spriteWithSpriteFrameName:@"rate_active.png"]
//                                       target:self 
//                                       selector:@selector(transitionToRateApp)];
//        
//        CCMenuItemSprite *moreSprite=[CCMenuItemSprite 
//                                      itemFromNormalSprite:[CCSprite spriteWithSpriteFrameName:@"more_inactive.png"] 
//                                      selectedSprite:[CCSprite spriteWithSpriteFrameName:@"more_active.png"]
//                                      target:self 
//                                      selector:@selector(transitionToMoreApps)];

        
        CCMenu *mainMenu=[CCMenu menuWithItems:backSprite,nil]; //rateSprite,moreSprite, nil];
        if (UI_USER_INTERFACE_IDIOM() != UIUserInterfaceIdiomPad) {
            [backSprite setScaleX:(size.width/1024.0f)];
            [backSprite setScaleY:(size.width/768.0f)];
            
//            [rateSprite setScaleX:(size.width/1024.0f)];
//            [rateSprite setScaleY:(size.width/768.0f)];
//            
//            [moreSprite setScaleX:(size.width/1024.0f)];
//            [moreSprite setScaleY:(size.width/768.0f)];
        }
        
        [mainMenu alignItemsHorizontallyWithPadding:0.2*size.width];
//        aboutSprite.position=ccp(.0195*size.width, aboutSprite.position.y);
        
        mainMenu.position=ccp(size.width *.5, size.height/6);
        
        [self addChild:mainMenu];
        
        
        CCMenuItemSprite *visitSprite=[CCMenuItemSprite 
                                       itemFromNormalSprite:[CCSprite spriteWithSpriteFrameName:@"visit_inactive.png"] 
                                       selectedSprite:[CCSprite spriteWithSpriteFrameName:@"visit_active.png"] 
                                       target:self 
                                       selector:@selector(visitCFSite)];
        
        CCMenuItemSprite *visitSupportSprite=[CCMenuItemSprite 
                                       itemFromNormalSprite:[CCSprite spriteWithSpriteFrameName:@"visit_inactive.png"] 
                                       selectedSprite:[CCSprite spriteWithSpriteFrameName:@"visit_active.png"] 
                                       target:self 
                                       selector:@selector(visitSupportSite)];
        
        if (UI_USER_INTERFACE_IDIOM() != UIUserInterfaceIdiomPad) {
            [visitSprite setScaleX:(size.width/1024.0f)];
            [visitSprite setScaleY:(size.width/768.0f)];
            
            [visitSupportSprite setScaleX:(size.width/1024.0f)];
            [visitSupportSprite setScaleY:(size.width/768.0f)];
        }
        visitSprite.position=ccp(size.width-size.width*.22,size.height-size.height*.2);
        visitSupportSprite.position=ccp(size.width-size.width*.22,size.height-size.height*.38);

        
        [self addChild:visitSprite];
        [self addChild:visitSupportSprite];
        
    }
    
    [TestFlight passCheckpoint:@"RETURNING_SPLASH"];
    
	return self;
    
}

-(void) transitionToStartUpScreen{
    [TestFlight passCheckpoint:@"LOADING_SPLASH_SCREEN"];
    [[CCDirector sharedDirector] replaceScene:
     [CCTransitionSlideInL transitionWithDuration:1.0f scene:[StartUpScreenLayer scene]]];
}

-(void) transitionToRateApp{
    [TestFlight passCheckpoint:@"LOADING_RATE_APPS"];
    [[CCDirector sharedDirector] replaceScene:
     [CCTransitionMoveInR transitionWithDuration:1.0f scene:[StartUpScreenLayer scene]]];
}

-(void) transitionToMoreApps{
    [TestFlight passCheckpoint:@"LOADING_MORE_APPS"];
    [[CCDirector sharedDirector] replaceScene:
     [CCTransitionMoveInR transitionWithDuration:1.0f scene:[StartUpScreenLayer scene]]];
}

-(void)visitCFSite{
    [FlurryAnalytics logEvent:@"VISIT_CF_APPS_SITE"];
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:@"http://www.campfireapps.com"]];
}

-(void)visitSupportSite{
    [FlurryAnalytics logEvent:@"VISIT_SUPPORT_SITE"];
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:@"http://spookyhenry.campfireapps.com"]];
}

-(void)dealloc{
    [super dealloc];
}


@end
