//
//  ScoresLayer.m
//  HenryAndHisHeadlamp
//
//  Created by Shawn Grimes on 9/30/11.
//  Copyright 2011 Shawn's Bits, LLC. All rights reserved.
//

#import "ScoresLayer.h"


@implementation ScoresLayer

@synthesize timeToFindObjects;

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
        if (UI_USER_INTERFACE_IDIOM() != UIUserInterfaceIdiomPad) { 
            [iconSelectorBackground setScaleX:(size.width/1024.0f)];
            [iconSelectorBackground setScaleY:(size.height/768.0f)];
        }
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
//            if (UI_USER_INTERFACE_IDIOM() != UIUserInterfaceIdiomPad) {
//                [userIconSprite setScaleX:(size.width/1024.0f)];
//                [userIconSprite setScaleY:(size.width/768.0f)];
//            }
            
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
            if (UI_USER_INTERFACE_IDIOM() != UIUserInterfaceIdiomPad) { 
                [userIconMenu setScaleX:(size.width/1024.0f)];
                [userIconMenu setScaleY:(size.height/768.0f)];
                userIconMenu.position=ccp(iconSelectorBackground.boundingBox.origin.x+(userIconSprite.boundingBox.size.width*(size.width/1024.0)), 
                                          iconSelectorBackground.boundingBox.origin.y+userIconSprite.boundingBox.size.height*(size.height/768.0));
            }else{
                userIconMenu.position=ccp(iconSelectorBackground.boundingBox.origin.x+(userIconSprite.boundingBox.size.width), 
                                      iconSelectorBackground.boundingBox.origin.y+userIconSprite.boundingBox.size.height);
            }
        }
   
        
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
        [userIconSprite setScale:(size.width/1024.0f) * 1.2];
//        [userIconSprite setScaleY:(size.height/768.0f) * 1.2];
    }else{
        [userIconSprite setScale:1.2];
    }

    userIconSprite.position=ccp(.27*size.width,size.height-size.height*.235);
    [FlurryAnalytics logEvent:@"USER_ICON_SELECTED" withParameters:[NSDictionary dictionaryWithObjectsAndKeys:[NSNumber numberWithInt:selectedSprite.tag],
                                                                    @"Icon Selected", 
                                                                    nil]
     ];
    
    userIconSprite.anchorPoint=ccp(0,0.5);
    [self addChild:userIconSprite];
    [self removeChildByTag:kTAGuserIconMenu cleanup:YES];
    [self removeChildByTag:kTAGiconBackground cleanup:YES];
    
    [[CCSpriteFrameCache sharedSpriteFrameCache] addSpriteFramesWithFile:@"buttonsAndResources-Halloween.plist"];
    CCMenuItemSprite *playSprite=[CCMenuItemSprite 
                                  itemFromNormalSprite:[CCSprite spriteWithSpriteFrameName:@"play_inactive.png"] 
                                  selectedSprite:[CCSprite spriteWithSpriteFrameName:@"play_active.png"] 
                                  target:self 
                                  selector:@selector(transitionToGameScreen)];
    
    CCMenuItemSprite *homeSprite=[CCMenuItemSprite 
                                  itemFromNormalSprite:[CCSprite spriteWithSpriteFrameName:@"home_inactive.png"] 
                                  selectedSprite:[CCSprite spriteWithSpriteFrameName:@"home_active.png"]
                                  target:self 
                                  selector:@selector(transitionToStartUpScreen)];
    
    if (UI_USER_INTERFACE_IDIOM() != UIUserInterfaceIdiomPad) {
        [playSprite setScaleX:(size.width/1024.0f)];
        [playSprite setScaleY:(size.width/768.0f)];
        
        [homeSprite setScaleX:(size.width/1024.0f)];
        [homeSprite setScaleY:(size.width/768.0f)];
    }
    CCMenu *mainMenu=[CCMenu menuWithItems:homeSprite,playSprite, nil];
    [mainMenu alignItemsHorizontallyWithPadding:0.5*size.width];
    //        aboutSprite.position=ccp(.0195*size.width, aboutSprite.position.y);
    
    mainMenu.position=ccp(size.width * .5, size.height/8);
    
    [self addChild:mainMenu];
    
    NSNumber *userTimeNumber=[NSNumber numberWithFloat:self.timeToFindObjects];
    NSNumber *iconNumber=[NSNumber numberWithInt:selectedSprite.tag];
    
    NSUserDefaults *scores=[NSUserDefaults standardUserDefaults];
    NSDictionary *thirdPlace=[scores dictionaryForKey:@"thirdPlace"];
    NSDictionary *secondPlace=[scores dictionaryForKey:@"secondPlace"];
    NSDictionary *firstPlace=[scores dictionaryForKey:@"firstPlace"];
    
    NSLog(@"First: %f", [[firstPlace valueForKey:@"time"] floatValue]);
    NSLog(@"Second: %f", [[secondPlace valueForKey:@"time"] floatValue]);    
    NSLog(@"Third: %f", [[thirdPlace valueForKey:@"time"] floatValue]);
    
    NSNumber *firstPlaceTime=[firstPlace valueForKey:@"time"];
    if([firstPlaceTime floatValue]>[userTimeNumber floatValue] || firstPlaceTime==0){
        thirdPlace=secondPlace;
        secondPlace=firstPlace;
        firstPlace=[NSDictionary dictionaryWithObjectsAndKeys:userTimeNumber, @"time",iconNumber,@"icon", nil];
        [scores setValue:thirdPlace forKey:@"thirdPlace"];
        [scores setValue:secondPlace forKey:@"secondPlace"];
        [scores setValue:firstPlace forKey:@"firstPlace"];
        [TestFlight passCheckpoint:@"SETTING_FIRST_PLACE"];
    }else if([[secondPlace valueForKey:@"time"] floatValue]>[userTimeNumber floatValue] || [secondPlace valueForKey:@"time"]==0){
        thirdPlace=secondPlace;
        secondPlace=[NSDictionary dictionaryWithObjectsAndKeys:userTimeNumber, @"time",iconNumber,@"icon", nil];
        [scores setValue:thirdPlace forKey:@"thirdPlace"];
        [scores setValue:secondPlace forKey:@"secondPlace"];
        [TestFlight passCheckpoint:@"SETTING_SECOND_PLACE"];
    }else if([[thirdPlace valueForKey:@"time"] floatValue]>[userTimeNumber floatValue] || [thirdPlace valueForKey:@"time"]==0){
        thirdPlace=[NSDictionary dictionaryWithObjectsAndKeys:userTimeNumber, @"time",iconNumber,@"icon", nil];;
        [scores setValue:thirdPlace forKey:@"thirdPlace"];
        [TestFlight passCheckpoint:@"SETTING_THIRD_PLACE"];
    }
    
//    NSNumber *thirdPlaceTime=[thirdPlace objectForKey:@"time"];
//    
//    if(thirdPlaceTime>userTimeNumber || thirdPlaceTime==0){
//        NSNumber *secondPlaceTime=[secondPlace valueForKey:@"time"];
//        if(secondPlaceTime>userTimeNumber || secondPlaceTime==0){
//            NSNumber *firstPlaceTime=[firstPlace valueForKey:@"time"];
//            if(firstPlaceTime>userTimeNumber  || firstPlaceTime==0){
//                thirdPlace=secondPlace;
//                secondPlace=firstPlace;
//                firstPlace=[NSDictionary dictionaryWithObjectsAndKeys:userTimeNumber, @"time",iconNumber,@"icon", nil];
//                [scores setValue:thirdPlace forKey:@"thirdPlace"];
//                [scores setValue:secondPlace forKey:@"secondPlace"];
//                [scores setValue:firstPlace forKey:@"firstPlace"];
//                [TestFlight passCheckpoint:@"SETTING_FIRST_PLACE"];
//            }else{
//                thirdPlace=secondPlace;
//                secondPlace=[NSDictionary dictionaryWithObjectsAndKeys:userTimeNumber, @"time",iconNumber,@"icon", nil];
//                [scores setValue:thirdPlace forKey:@"thirdPlace"];
//                [scores setValue:secondPlace forKey:@"secondPlace"];
//                [TestFlight passCheckpoint:@"SETTING_SECOND_PLACE"];
//            }
//        }else{
//            thirdPlace=[NSDictionary dictionaryWithObjectsAndKeys:userTimeNumber, @"time",iconNumber,@"icon", nil];;
//            [scores setValue:thirdPlace forKey:@"thirdPlace"];
//            [TestFlight passCheckpoint:@"SETTING_THIRD_PLACE"];
//        }
//        
//    }
    [scores synchronize];
    
    //First Place
    if([firstPlace valueForKey:@"icon"]>0){
        CCSprite *firstPlaceSprite=[CCSprite spriteWithSpriteFrameName:[NSString stringWithFormat:@"%i_inactive.png", [[firstPlace valueForKey:@"icon"] integerValue]]];
        if (UI_USER_INTERFACE_IDIOM() != UIUserInterfaceIdiomPad) {
            [firstPlaceSprite setScale:(size.width/1024.0f) * .7];
//            [firstPlaceSprite setScaleY:(size.width/768.0f) * .6];
        }else{
            [firstPlaceSprite setScale:.7];
        }
        firstPlaceSprite.position=ccp((370.0/1024.0)*size.width,(350.0/768.0)*size.height);
        [self addChild:firstPlaceSprite];
        ScoreNode *firstPlacePlayerScoreNode=[ScoreNode timeOf:[[firstPlace valueForKey:@"time"] floatValue]];
        if (UI_USER_INTERFACE_IDIOM() != UIUserInterfaceIdiomPad) {
            [firstPlacePlayerScoreNode setScale:(size.width/1024.0f)];
//            [firstPlacePlayerScoreNode setScaleY:(size.width/768.0f)];
        }

        firstPlacePlayerScoreNode.position=ccp((420.0/1024.0)*size.width,(350.0/768.0)*size.height);
        [self addChild:firstPlacePlayerScoreNode];
    }


    //Second Place
    if([secondPlace valueForKey:@"icon"]>0){
        CCSprite *secondPlaceSprite=[CCSprite spriteWithSpriteFrameName:[NSString stringWithFormat:@"%i_inactive.png", [[secondPlace valueForKey:@"icon"] integerValue]]];
        if (UI_USER_INTERFACE_IDIOM() != UIUserInterfaceIdiomPad) {
            [secondPlaceSprite setScale:(size.width/1024.0f) * .7];
//            [secondPlaceSprite setScaleY:(size.width/768.0f) * .7];
        }else{
            [secondPlaceSprite setScale:.7];
        }
        secondPlaceSprite.position=ccp((370.0/1024.0)*size.width,(270.0/768.0)*size.height);
        [self addChild:secondPlaceSprite];
        ScoreNode *secondPlacePlayerScoreNode=[ScoreNode timeOf:[[secondPlace valueForKey:@"time"] floatValue]];
        if (UI_USER_INTERFACE_IDIOM() != UIUserInterfaceIdiomPad) {
            [secondPlacePlayerScoreNode setScale:(size.width/1024.0f)];
//            [secondPlacePlayerScoreNode setScaleY:(size.width/768.0f)];
        }

        secondPlacePlayerScoreNode.position=ccp((420.0/1024.0)*size.width,(270.0/768.0)*size.height);
        [self addChild:secondPlacePlayerScoreNode];
    }
    
    //Third Place
    if([thirdPlace valueForKey:@"icon"]>0){
        CCSprite *thirdPlaceSprite=[CCSprite spriteWithSpriteFrameName:[NSString stringWithFormat:@"%i_inactive.png", [[thirdPlace valueForKey:@"icon"] integerValue]]];
        if (UI_USER_INTERFACE_IDIOM() != UIUserInterfaceIdiomPad) {
            [thirdPlaceSprite setScale:(size.width/1024.0f) * .7];
//            [thirdPlaceSprite setScaleY:(size.width/768.0f) * .7];
        }else{
            [thirdPlaceSprite setScale:.7];
        }
        thirdPlaceSprite.position=ccp((370.0/1024.0)*size.width,(190.0/768.0)*size.height);
        [self addChild:thirdPlaceSprite];
        ScoreNode *thirdPlacePlayerScoreNode=[ScoreNode timeOf:[[thirdPlace valueForKey:@"time"] floatValue]];
        if (UI_USER_INTERFACE_IDIOM() != UIUserInterfaceIdiomPad) {
            [thirdPlacePlayerScoreNode setScale:(size.width/1024.0f)];
//            [thirdPlacePlayerScoreNode setScaleY:(size.width/768.0f)];
        }
        thirdPlacePlayerScoreNode.position=ccp((420.0/1024.0)*size.width,(190.0/768.0)*size.height);
        [self addChild:thirdPlacePlayerScoreNode];
    }
}

-(void)withTime:(float)userTime{
    CGSize size = [[CCDirector sharedDirector] winSize];
    ScoreNode *playerScoreNode=[ScoreNode timeOf:userTime];
    if (UI_USER_INTERFACE_IDIOM() != UIUserInterfaceIdiomPad) {
        [playerScoreNode setScale:(size.width/1024.0f)];
//        [playerScoreNode setScaleY:(size.width/768.0f)];
    }
    playerScoreNode.position=ccp((420.0/1024.0)*size.width,size.height-((160.0/768.0)*size.height));
    [self addChild:playerScoreNode];
    
    CCLabelBMFont *labelTime=[CCLabelBMFont labelWithString:[NSString stringWithFormat:@"%.0f seconds",userTime] fntFile:@"Corben-64.fnt"];
    
#ifdef HALLOWEEN
    labelTime.color=ccORANGE;
#endif
    if (UI_USER_INTERFACE_IDIOM() != UIUserInterfaceIdiomPad) { 
        [labelTime setScaleX:(size.width/1024.0f) * .5];
        [labelTime setScaleY:(size.height/768.0f) * .5];
    }else{
        [labelTime setScale:0.5];
    }
    labelTime.position =  ccp( (550.0/1024.0)*size.width, size.height - ((215.0/768.0)*size.height) );
    [self addChild: labelTime]; 
    
    self.timeToFindObjects=userTime;
    

}

-(void) transitionToStartUpScreen{
    [TestFlight passCheckpoint:@"LOADING_SPLASH_SCREEN"];
    [[CCDirector sharedDirector] replaceScene:
     [CCTransitionSlideInL transitionWithDuration:1.0f scene:[StartUpScreenLayer scene]]];
}

-(void) transitionToGameScreen{
    [TestFlight passCheckpoint:@"LOADING_GAME_SCENE"];
    [FlurryAnalytics logEvent:@"PLAY_AGAING_SELECTED_ON_SCORES_SCREEN"];
    [[CCDirector sharedDirector] replaceScene:
     [CCTransitionSlideInL transitionWithDuration:1.0f scene:[GameLayer scene]]];
}

-(void)dealloc{
    [super dealloc];
}

@end
