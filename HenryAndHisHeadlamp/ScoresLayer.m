//
//  ScoresLayer.m
//  HenryAndHisHeadlamp
//
//  Created by Shawn Grimes on 9/30/11.
//  Copyright 2011 Shawn's Bits, LLC. All rights reserved.
//

#import "ScoresLayer.h"


@implementation ScoresLayer
+(CCScene *) scene
{
	// 'scene' is an autorelease object.
	CCScene *scene = [CCScene node];
	
	// 'layer' is an autorelease object.
	ScoresLayer *layer = [ScoresLayer node];
	
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
    [TestFlight passCheckpoint:@"INIT_SCORES_LAYER"];
	// always call "super" init
	// Apple recommends to re-assign "self" with the "super" return value
	if( (self=[super init])) {
        
        self.isTouchEnabled=YES;
        
        CGSize size = [[CCDirector sharedDirector] winSize];
        
#ifdef HALLOWEEN
        //Stuff for Lite version
        CCSprite *backgroundSprite=[CCSprite spriteWithFile:@"Henry_Spooky_Scores.png"];
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
        

        [[CCSpriteFrameCache sharedSpriteFrameCache] addSpriteFramesWithFile:@"UserIcons.plist"];
        
        CCSprite *iconSelectorBackground=[CCSprite spriteWithSpriteFrameName:@"Henry_Spooky_Icon_Selection.png"];
        iconSelectorBackground.position=ccp(size.width * 0.5, size.height * 0.5);
        [self addChild:iconSelectorBackground z:2 tag:kTAGiconBackground];

        
        CCMenu *userIconMenu;
        for(int x=1;x<=9;x++){
            CCSprite *inactiveSprite=[CCSprite spriteWithSpriteFrameName:[NSString stringWithFormat:@"%i_inactive.png", x]];
            inactiveSprite.tag=x;
            CCSprite *activeSprite=[CCSprite spriteWithSpriteFrameName:[NSString stringWithFormat:@"%i_active.png", x]];                                      
            CCMenuItemSprite *userIconSprite=[CCMenuItemSprite 
                                              itemFromNormalSprite:inactiveSprite 
                                             selectedSprite:activeSprite 
                                             target:self 
                                              selector:@selector(setUserIcon:)];
            if (UI_USER_INTERFACE_IDIOM() != UIUserInterfaceIdiomPad) {
                [userIconSprite setScaleX:(size.width/1024.0f)];
                [userIconSprite setScaleY:(size.width/768.0f)];
            }
            
            
            
            if(x==1){
                userIconMenu=[CCMenu menuWithItems:userIconSprite, nil];
            }else{
                [userIconMenu addChild:userIconSprite];
            }
            userIconSprite.position=ccp(0,0);
            if(x<=3){
                userIconSprite.position=ccp((x-1)*userIconSprite.boundingBox.size.width + ((x-1)*userIconSprite.boundingBox.size.width/3),
                                        0);
            }else if(x>3 && x<=6){
                userIconSprite.position=ccp((x-4)*userIconSprite.boundingBox.size.width + ((x-4)*userIconSprite.boundingBox.size.width/3),
                                            (.5*userIconSprite.boundingBox.size.height + userIconSprite.boundingBox.size.height));
            }else if(x>6){
                userIconSprite.position=ccp((x-7)*userIconSprite.boundingBox.size.width + ((x-7)*userIconSprite.boundingBox.size.width/3),
                                            (2*userIconSprite.boundingBox.size.height + userIconSprite.boundingBox.size.height));
            }
            userIconMenu.anchorPoint=ccp(0,0);
            userIconMenu.position=ccp(iconSelectorBackground.boundingBox.origin.x+(userIconSprite.boundingBox.size.width), 
                                      iconSelectorBackground.boundingBox.origin.y+userIconSprite.boundingBox.size.height);
        }
//        [userIconMenu setContentSize:CGSizeMake(iconSelectorBackground.boundingBox.size.width, iconSelectorBackground.boundingBox.size.height)];
//        [userIconMenu setContentSize:CGSizeMake(size.width*0.5, size.height * 0.5)];
//        [userIconMenu alignItemsInColumns:[NSNumber numberWithInt:3],[NSNumber numberWithInt:3],[NSNumber numberWithInt:3], nil];
        
        
        [self addChild:userIconMenu z:4 tag:kTAGuserIconMenu];
    }
    
    [TestFlight passCheckpoint:@"RETURNING_SCORES"];
    
	return self;
    
}

-(void)setUserIcon:(id) sender{
    CCMenuItemSprite *selectedUserIcon=(CCMenuItemSprite *) sender;

    CGSize size = [[CCDirector sharedDirector] winSize];
    
    for (CCNode *childElement in selectedUserIcon.children) {
        NSLog(@"ChildELement: %@", childElement);
    }
    CCSprite *selectedSprite=(CCSprite *)[selectedUserIcon.children objectAtIndex:0];
    CCSprite *userIconSprite=[CCSprite spriteWithTexture:selectedSprite.texture rect:selectedSprite.textureRect];
    if (UI_USER_INTERFACE_IDIOM() != UIUserInterfaceIdiomPad) { 
        [userIconSprite setScaleX:size.width/1024.0f];
        [userIconSprite setScaleY:size.height/768.0f];
    }

    userIconSprite.position=ccp(.27*size.width,size.height-size.height*.235);
    [FlurryAnalytics logEvent:@"USER_ICON_SELECTED" withParameters:[NSDictionary dictionaryWithObjectsAndKeys:[NSNumber numberWithInt:userIconSprite.tag],
                                                                    @"Icon Selected", 
                                                                    nil]
     ];
    userIconSprite.anchorPoint=ccp(0,0.5);
    [self addChild:userIconSprite];
    [self removeChildByTag:kTAGuserIconMenu cleanup:YES];
    [self removeChildByTag:kTAGiconBackground cleanup:YES];
}

-(void)setScore:(int)playerScore{
    CGSize size = [[CCDirector sharedDirector] winSize];
    ScoreNode *playerScoreNode=[ScoreNode scoreOf:playerScore];
    playerScoreNode.position=ccp(380,size.height-180);
    [self addChild:playerScoreNode];
}

-(void) transitionToStartUpScreen{
    [TestFlight passCheckpoint:@"LOADING_SPLASH_SCREEN"];
    [[CCDirector sharedDirector] replaceScene:
     [CCTransitionSlideInL transitionWithDuration:1.0f scene:[GameLayer scene]]];
}

-(void)dealloc{
    [super dealloc];
}

@end
