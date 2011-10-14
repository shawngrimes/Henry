//
//  StoryLevel.m
//  HenryAndHisHeadlamp
//
//  Created by Shawn Grimes on 9/30/11.
//  Copyright 2011 Shawn's Bits, LLC. All rights reserved.
//

#import "StoryLevel.h"

int touchCount=0;
ALuint soundEffect;

@implementation StoryLevel
+(CCScene *) scene
{
	// 'scene' is an autorelease object.
	CCScene *scene = [CCScene node];
	
	// 'layer' is an autorelease object.
	StoryLevel *layer = [StoryLevel node];
	
	// add layer as a child to scene
	[scene addChild: layer];
    
	
	// return the scene
	return scene;
}

// on "init" you need to initialize your instance
-(id) init
{
	// always call "super" init
	// Apple recommends to re-assign "self" with the "super" return value
	if( (self=[super init])) {
#ifdef HALLOWEEN
        [[SimpleAudioEngine sharedEngine] preloadEffect:@"HenrySpeech1.caf"];
        [[SimpleAudioEngine sharedEngine] preloadEffect:@"HenrySpeech2.caf"];
#endif
        // ask director the the window size
		CGSize size = [[CCDirector sharedDirector] winSize];
        
		CCSprite *backgroundSprite=[CCSprite spriteWithFile:@"Henry_Spooky_Story_Scene.png"];
        backgroundSprite.position=ccp(size.width *0.5, size.height *0.5);
        if (UI_USER_INTERFACE_IDIOM() != UIUserInterfaceIdiomPad) { 
            [backgroundSprite setScaleX:size.width/1024.0f];
            [backgroundSprite setScaleY:size.height/768.0f];
        }

        [self addChild:backgroundSprite];
        
        CCSprite *speechBubble1=[CCSprite spriteWithFile:@"Henry_Spooky_Speech1.png"];
        speechBubble1.anchorPoint=ccp(0.5,0.5);
        if (UI_USER_INTERFACE_IDIOM() != UIUserInterfaceIdiomPad) { 
            [speechBubble1 setScale:size.width/1024.0f * 1.5];
//            [speechBubble1 setScaleY:size.height/768.0f];
        }

        speechBubble1.position=ccp(size.width * .366,size.height-(size.height * (230.0/768.0)));
        [self addChild:speechBubble1 z:2 tag:2];
        
        
        
        self.isTouchEnabled=YES;
        
        touchCount=0;
        
#ifdef HALLOWEEN
        soundEffect=[[SimpleAudioEngine sharedEngine] playEffect:@"HenrySpeech1.caf"];
#endif
	}
	return self;
}

// on "dealloc" you need to release all your retained objects
- (void) dealloc
{
	// in case you have something to dealloc, do it in this method
	// in this particular example nothing needs to be released.
	// cocos2d will automatically release all the children (Label)
	
	// don't forget to call "super dealloc"
	[super dealloc];
}

- (void)registerWithTouchDispatcher {
    [[CCTouchDispatcher sharedDispatcher] addTargetedDelegate:self 
                                                     priority:0 swallowsTouches:YES];
}

- (BOOL)ccTouchBegan:(UITouch *)touch withEvent:(UIEvent *)event {
    CGPoint location = [touch locationInView:[touch view]];
    location = [[CCDirector sharedDirector] convertToGL:location];
    
    
    return TRUE;
}

-(void)ccTouchMoved:(UITouch *)touch withEvent:(UIEvent *)event{
    CGPoint location = [touch locationInView:[touch view]];
    
    location = [[CCDirector sharedDirector] convertToGL:location];
    
    
}

-(void)ccTouchEnded:(UITouch *)touch withEvent:(UIEvent *)event{
    touchCount++;
    
    [self removeChildByTag:2 cleanup:YES];
    
    // ask director the the window size
    CGSize size = [[CCDirector sharedDirector] winSize];
    
    if(touchCount>0 && touchCount<2){
        CCSprite *speechBubble2=[CCSprite spriteWithFile:@"Henry_Spooky_Speech2.png"];
        speechBubble2.anchorPoint=ccp(0.5,0.5);
        speechBubble2.position=ccp((375.0/1024.0)*size.width,size.height-((230.0/768.0)*size.height));
        if (UI_USER_INTERFACE_IDIOM() != UIUserInterfaceIdiomPad) { 
            [speechBubble2 setScale:size.width/1024.0f * 1.5];
//            [speechBubble2 setScaleY:size.height/768.0f];
        }
        [self addChild:speechBubble2 z:2 tag:2];
#ifdef HALLOWEEN
        [[SimpleAudioEngine sharedEngine] stopEffect:soundEffect];
        soundEffect=[[SimpleAudioEngine sharedEngine] playEffect:@"HenrySpeech2.caf"];
#endif
    }
    
    if(touchCount>=2){
        CGSize size = [[CCDirector sharedDirector] winSize];
        CCLabelBMFont *labelLoading=[CCLabelBMFont labelWithString:@"Loading..." fntFile:@"Corben-64.fnt"];
#ifdef HALLOWEEN
        labelLoading.color=ccORANGE;
#endif
        if (UI_USER_INTERFACE_IDIOM() != UIUserInterfaceIdiomPad) { 
            [labelLoading setScaleX:(size.width/1024.0f)];
            [labelLoading setScaleY:(size.height/768.0f)];
        }
		labelLoading.position =  ccp( size.width /2 , size.height/2 );
		[self addChild:labelLoading];
        
        [self schedule:@selector(loadGameLayer) interval:0.2];

    }
}

-(void) loadGameLayer{
    [[SimpleAudioEngine sharedEngine] stopEffect:soundEffect];
    [[CCDirector sharedDirector] replaceScene:
     [CCTransitionSlideInR transitionWithDuration:1.0f scene:[GameLayer scene]]];
    
}




@end
