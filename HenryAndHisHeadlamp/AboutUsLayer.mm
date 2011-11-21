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
        [CCTexture2D PVRImagesHavePremultipliedAlpha:YES];
        
        
        CGSize size = [[CCDirector sharedDirector] winSize];
        CCSprite *backgroundSprite;
#ifdef HALLOWEEN
        //Stuff for Lite version
         backgroundSprite=[CCSprite spriteWithFile:@"Henry_Spooky_About_Page.png"];
#elif SMART
        //Stuff for Full version
        backgroundSprite=[CCSprite spriteWithFile:@"AboutScreen.png"];
#endif
        
//        if (UI_USER_INTERFACE_IDIOM() != UIUserInterfaceIdiomPad) { 
//            [backgroundSprite setScaleX:size.width/1024.0f];
//            [backgroundSprite setScaleY:size.height/768.0f];
//        }
        backgroundSprite.position=ccp(size.width/2, size.height/2);
        [self addChild:backgroundSprite];
        
#ifdef HALLOWEEN       
        [[CCSpriteFrameCache sharedSpriteFrameCache] addSpriteFramesWithFile:@"buttonsAndResources-Halloween.plist"];
#elif SMART
        [[CCSpriteFrameCache sharedSpriteFrameCache] addSpriteFramesWithFile:@"buttonsAndResources-Smart.plist"];
#endif
        CCMenuItemSprite *backSprite=[CCMenuItemSprite 
                                      itemFromNormalSprite:[CCSprite spriteWithSpriteFrameName:@"BackArrow_inactive.png"] 
                                      selectedSprite:[CCSprite spriteWithSpriteFrameName:@"BackArrow_active.png"] 
                                      target:self 
                                      selector:@selector(transitionToStartUpScreen)];
        
        CCMenuItemSprite *rateSprite=[CCMenuItemSprite 
                                       itemFromNormalSprite:[CCSprite spriteWithSpriteFrameName:@"RateApp_inactive.png"] 
                                       selectedSprite:[CCSprite spriteWithSpriteFrameName:@"RateApp_active.png"]
                                       target:self 
                                       selector:@selector(transitionToRateApp)];
        
        CCMenuItemSprite *moreSprite=[CCMenuItemSprite 
                                      itemFromNormalSprite:[CCSprite spriteWithSpriteFrameName:@"MoreApps_inactive.png"] 
                                      selectedSprite:[CCSprite spriteWithSpriteFrameName:@"MoreApps_active.png"]
                                      target:self 
                                      selector:@selector(transitionToMoreApps)];

        
        CCMenu *mainMenu=[CCMenu menuWithItems:backSprite,rateSprite,moreSprite, nil];
//        if (UI_USER_INTERFACE_IDIOM() != UIUserInterfaceIdiomPad) {
//            [backSprite setScaleX:(size.width/1024.0f)];
//            [backSprite setScaleY:(size.width/768.0f)];
//            
//            [rateSprite setScaleX:(size.width/1024.0f)];
//            [rateSprite setScaleY:(size.width/768.0f)];
//            
//            [moreSprite setScaleX:(size.width/1024.0f)];
//            [moreSprite setScaleY:(size.width/768.0f)];
//        }
        
        [mainMenu alignItemsHorizontallyWithPadding:0.2*size.width];
        if (UI_USER_INTERFACE_IDIOM() != UIUserInterfaceIdiomPad) {
            mainMenu.position=ccp(size.width *.5, size.height/11);
        }else{
            mainMenu.position=ccp(size.width *.5, size.height/6);
        }
        
        //        aboutSprite.position=ccp(.0195*size.width, aboutSprite.position.y);
        
        
        
        [self addChild:mainMenu];
        
        
        CCMenuItemSprite *visitSprite=[CCMenuItemSprite 
                                       itemFromNormalSprite:[CCSprite spriteWithSpriteFrameName:@"VisitSite_inactive.png"] 
                                       selectedSprite:[CCSprite spriteWithSpriteFrameName:@"VisitSite_active.png"] 
                                       target:self 
                                       selector:@selector(visitCFSite)];
        
        CCMenuItemSprite *visitSupportSprite=[CCMenuItemSprite 
                                       itemFromNormalSprite:[CCSprite spriteWithSpriteFrameName:@"VisitSite_inactive.png"] 
                                       selectedSprite:[CCSprite spriteWithSpriteFrameName:@"VisitSite_active.png"] 
                                       target:self 
                                       selector:@selector(visitSupportSite)];
        
//        if (UI_USER_INTERFACE_IDIOM() != UIUserInterfaceIdiomPad) {
//            [visitSprite setScaleX:(size.width/1024.0f)];
//            [visitSprite setScaleY:(size.width/768.0f)];
//            
//            [visitSupportSprite setScaleX:(size.width/1024.0f)];
//            [visitSupportSprite setScaleY:(size.width/768.0f)];
//        }
        
        CCMenu *visitMenu=[CCMenu menuWithItems:visitSprite,visitSupportSprite, nil];
        if (UI_USER_INTERFACE_IDIOM() != UIUserInterfaceIdiomPad) {
            [visitMenu alignItemsVerticallyWithPadding:size.height/9];
            visitMenu.position=ccp(3.9*size.width/5, size.height-size.height/3.1);
        }else{
            [visitMenu alignItemsVerticallyWithPadding:size.height/9];   
            visitMenu.position=ccp(3.9*size.width/5, size.height-size.height/3.4);
        }
        
//        visitSprite.position=ccp(size.width-size.width*.22,size.height-size.height*.2);
//        visitSupportSprite.position=ccp(size.width-size.width*.22,size.height-size.height*.38);
        [self addChild:visitMenu];
//        [self addChild:visitSprite];
//        [self addChild:visitSupportSprite];
        
    }
    
    [TestFlight passCheckpoint:@"RETURNING_ABOUT_MENU"];
    
	return self;
    
}



-(void) transitionToStartUpScreen{
//    [TestFlight passCheckpoint:@"LOADING_SPLASH_SCREEN"];
    [[CCDirector sharedDirector] replaceScene:
     [CCTransitionSlideInL transitionWithDuration:1.0f scene:[StartUpScreenLayer scene]]];
}

-(void) transitionToRateApp{
//    [TestFlight passCheckpoint:@"LOADING_RATE_APPS"];
    [FlurryAnalytics logEvent:@"RATE_APP_TOUCHED"];
#ifdef HALLOWEEN
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:@"http://click.linksynergy.com/fs-bin/stat?id=ufqtEXoqemY&offerid=146261&type=3&subid=0&tmpid=1826&RD_PARM1=http%253A%252F%252Fitunes.apple.com%252Fus%252Fapp%252Fhenrys-spooky-headlamp%252Fid469760219%253Fmt%253D8%2526uo%253D4%2526partnerId%253D30"]];
#elif SMART
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:@"http://itunes.apple.com/us/app/id482490502"]];
#endif
}

-(void) transitionToMoreApps{
    [TestFlight passCheckpoint:@"LOADING_MORE_APPS"];
    [FlurryAnalytics logEvent:@"MORE_APPS_TOUCHED"];
#ifdef HALLOWEEN
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:@"http://click.linksynergy.com/fs-bin/stat?id=ufqtEXoqemY&offerid=146261&type=3&subid=0&tmpid=1826&RD_PARM1=http%253A%252F%252Fitunes.apple.com%252Fus%252Fartist%252Fcampfire-apps-llc.%252Fid469760222%253Fuo%253D4%2526partnerId%253D30"]];
#elif SMART
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:@"http://click.linksynergy.com/fs-bin/stat?id=ufqtEXoqemY&offerid=146261&type=3&subid=0&tmpid=1826&RD_PARM1=http%253A%252F%252Fitunes.apple.com%252Fus%252Fartist%252Fcampfire-apps-llc.%252Fid469760222%253Fuo%253D4%2526partnerId%253D30"]];
#endif

}

-(void)visitCFSite{
    [FlurryAnalytics logEvent:@"VISIT_CF_APPS_SITE"];
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:@"http://www.campfireapps.com"]];
}

-(void)visitSupportSite{
    [FlurryAnalytics logEvent:@"VISIT_SUPPORT_SITE"];
#ifdef HALLOWEEN
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:@"http://spookyhenry.campfireapps.com"]];
#elif SMART
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:@"http://smarthenry.campfireapps.com"]];
#endif
}

-(void)dealloc{
    [super dealloc];
}


@end
