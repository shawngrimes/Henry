//
//  GameLayer.m
//  HenryAndHisHeadlamp
//
//  Created by Shawn Grimes on 9/8/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "GameLayer.h"


@implementation GameLayer
@synthesize arrCharacters=_arrCharacters;

typedef enum {
    kTAGfireWorks=1,
    kTAGtargetLabel,
    kTAGtargetSprite,
    kTAGnight,
    kTAGhenry,
    kTAGhenryHead,
    kTAGheadLamp,
    kTAGInstructions,
    kTAGHUD,
    kTAGTimer,
} tags;

+(CCScene *) scene
{
	// 'scene' is an autorelease object.
	CCScene *scene = [CCScene node];
	
	// 'layer' is an autorelease object.
	GameLayer *layer = [GameLayer node];
	
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
    [TestFlight passCheckpoint:@"INIT_SCENE"];
	// always call "super" init
	// Apple recommends to re-assign "self" with the "super" return value
	if( (self=[super init])) {
        
        self.isTouchEnabled=YES;

        CGSize size = [[CCDirector sharedDirector] winSize];
        
        CCSpriteFrameCache *frameCache=[CCSpriteFrameCache sharedSpriteFrameCache];
        [frameCache addSpriteFramesWithFile:@"HenryBodyTextures.plist"];
        
#ifdef HALLOWEEN
        //Stuff for Lite version
        CCSprite *backgroundSprite=[CCSprite spriteWithFile:@"Henry_Hallo_bkgrd.png"];
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
        
#ifdef HALLOWEEN
        [[CCSpriteFrameCache sharedSpriteFrameCache] addSpriteFramesWithFile:@"buttonsAndResources-Halloween.plist"];
        CCSprite *statusBarSprite=[CCSprite spriteWithSpriteFrameName:@"Henry_Spooky_Status_Box.png"];
#else
        CCSprite *statusBarSprite=[CCSprite spriteWithFile:@"Hallow_status_bar.png"];
#endif
        if (UI_USER_INTERFACE_IDIOM() != UIUserInterfaceIdiomPad) { 
            [statusBarSprite setScaleX:size.width/1024.0f];
            [statusBarSprite setScaleY:size.height/768.0f];
        }else{
            [statusBarSprite setScale:1.2];
        }
        statusBarSprite.anchorPoint=ccp(1,1);
        statusBarSprite.position=ccp(size.width,size.height);
        [self addChild:statusBarSprite z:3 tag:kTAGHUD];
        
        
        CCSprite *henryBody=[CCSprite spriteWithSpriteFrameName:@"HenryBody.png"];
        _henryHead=[CCSprite spriteWithSpriteFrameName:@"HenryHead-Off.png"];
        if (UI_USER_INTERFACE_IDIOM() != UIUserInterfaceIdiomPad) { 
            [henryBody setScaleX:size.width/1024.0f];
            [henryBody setScaleY:size.height/768.0f];
            [_henryHead setScaleX:size.width/1024.0f];
            [_henryHead setScaleY:size.height/768.0f];
        }
        henryBody.anchorPoint=ccp(0.5, 0);
        henryBody.position=ccp(size.width-((henryBody.textureRect.size.width * henryBody.scaleX) + .01*size.width), 0);
        
        _henryHead.anchorPoint=ccp(0.72,0.18);
        _henryHead.position=ccp(size.width-((henryBody.textureRect.size.width * henryBody.scaleX) + .002*size.width), 
                                (henryBody.textureRect.size.height-(.10*henryBody.textureRect.size.height)) * _henryHead.scaleY);
//        CCLOG(@"Henry Head Position: %f %f", _henryHead.position.x, _henryHead.position.y);
        _henryHead.rotation= 22.700861;
        
        [self addChild:henryBody z:9 tag:kTAGhenry];
        [self addChild:_henryHead z:10 tag:kTAGhenryHead];

        
         CGSize playableAreaSize=CGSizeMake(size.width, size.height);

        _arrCharacters=[[NSMutableArray alloc] initWithCapacity:5];        

#ifdef HALLOWEEN
        
        [TestFlight passCheckpoint:@"PLACING_CHARACTERS"];
        
        int MAX_CHARACTERS=28;
        
        NSMutableArray *aryCharacterTypes=[NSMutableArray arrayWithCapacity:5];
        for (int c=0; c<7; c++) {
            int randomCharacter=arc4random() % MAX_CHARACTERS+1;
            while ([aryCharacterTypes containsObject:[NSNumber numberWithInt:randomCharacter]]){
                randomCharacter=arc4random() % MAX_CHARACTERS+1;
            }
            [aryCharacterTypes addObject:[NSNumber numberWithInt:randomCharacter]];
            CCLOG(@"Random Character Type: %i", randomCharacter);
            CharacterSprite *randomSprite=[CharacterSprite characterOfType:randomCharacter];
            if (UI_USER_INTERFACE_IDIOM() != UIUserInterfaceIdiomPad) { 
                [randomSprite setScaleX:size.width/1024.0f];
                [randomSprite setScaleY:size.height/768.0f];
            }
            if(_arrCharacters.count<1){
                [randomSprite setRandomPosition:playableAreaSize];
                while(CGRectIntersectsRect(statusBarSprite.boundingBox, randomSprite.boundingBox) 
                      || CGRectIntersectsRect(henryBody.boundingBox, randomSprite.boundingBox) 
                      || CGRectIntersectsRect(_henryHead.boundingBox, randomSprite.boundingBox)){
                    CCLOG(@"Intersect other RECT1");
                            [randomSprite setRandomPosition:playableAreaSize];
                }
            }else{
                [randomSprite setRandomPosition:playableAreaSize checkOtherSprites:_arrCharacters];
                 while(CGRectIntersectsRect(statusBarSprite.boundingBox, randomSprite.boundingBox) 
                       || CGRectIntersectsRect(henryBody.boundingBox, randomSprite.boundingBox) 
                       || CGRectIntersectsRect(_henryHead.boundingBox, randomSprite.boundingBox)){
//                while(CGRectIntersectsRect(CGRectMake(statusBarSprite.boundingBox.origin.x, 0, size.width-statusBarSprite.boundingBox.origin.x, size.height), randomSprite.boundingBox)){
                     CCLOG(@"Intersect other RECT2");
                            [randomSprite setRandomPosition:playableAreaSize checkOtherSprites:_arrCharacters];
                }
            }
            
            [_arrCharacters addObject:randomSprite];
            [self addChild:randomSprite];
        }
        
        [TestFlight passCheckpoint:@"PLACED_CHARACTERS"];
        
#else
        CharacterSprite *redOvalSprite=[CharacterSprite characterOfType:kCharacterTypeOval withColor:kCharacterColorRed];
        [redOvalSprite setRandomPosition:playableAreaSize checkOtherSprites:_arrCharacters];
        [self addChild:redOvalSprite];
        [_arrCharacters addObject:redOvalSprite];
        
        CharacterSprite *greenSquareSprite=[CharacterSprite characterOfType:kCharacterTypeSquare withColor:kCharacterColorGreen];
        [greenSquareSprite setRandomPosition:playableAreaSize checkOtherSprites:_arrCharacters];
        [self addChild:greenSquareSprite];
        [_arrCharacters addObject:greenSquareSprite];
        
        CharacterSprite *blueTriangleSprite=[CharacterSprite characterOfType:kCharacterTypeTriangle withColor:kCharacterColorBlue];
        [blueTriangleSprite setRandomPosition:playableAreaSize checkOtherSprites:_arrCharacters];
        [self addChild:blueTriangleSprite];
        [_arrCharacters addObject:blueTriangleSprite];  
#endif
        
        
        
        
        
        _headLampLight=[CCSprite spriteWithFile:@"headLampLight.png"];
        if (UI_USER_INTERFACE_IDIOM() != UIUserInterfaceIdiomPad) { 
            [_headLampLight setScaleX:size.width/1024.0f];
            [_headLampLight setScaleY:size.height/768.0f];
        }
        _headLampLight.anchorPoint=ccp(0.5,0.5);
        _headLampLight.position=ccp(size.width/2, size.height/2);
        [_headLampLight setVisible:NO];
        [self addChild:_headLampLight z:1 tag:kTAGheadLamp];
        
        CCLayerColor *layerColor=[CCLayerColor layerWithColor:ccc4(0,0,0,255)];
        [self addChild:layerColor z:1 tag:kTAGnight];
        
        

    
        
        
//        CCLabelTTF *labelInstructions = [CCLabelTTF labelWithString:@"Touch to shine your light on the scene" fontName:@"Marker Felt" fontSize:32];
        CCLabelBMFont *labelInstructions=[CCLabelBMFont labelWithString:@"Tap & Hold, drag to move light" fntFile:@"Corben-64.fnt"];
        
#ifdef HALLOWEEN
        labelInstructions.color=ccORANGE;
#endif
        if (UI_USER_INTERFACE_IDIOM() != UIUserInterfaceIdiomPad) { 
            [labelInstructions setScaleX:(size.width/1024.0f)/2.0];
            [labelInstructions setScaleY:(size.height/768.0f)/2.0];
        }else{
            [labelInstructions setScale:0.33];
        }
		labelInstructions.position =  ccp( size.width /2 , size.height - size.height/15 );
		[self addChild: labelInstructions z:9 tag:kTAGInstructions];
        
        
        _timerLabel=[CCLabelBMFont labelWithString:@"0" fntFile:@"Corben-64.fnt"];
        if (UI_USER_INTERFACE_IDIOM() != UIUserInterfaceIdiomPad){
            [_timerLabel setScaleX:size.width/1024.0f * 0.4];
            [_timerLabel setScaleY:size.height/768.0f * 0.4];
        }else{
            _timerLabel.scale=.4;
        }

        CCLOG(@"Status Bar: %f, %f",statusBarSprite.boundingBox.origin.x, statusBarSprite.boundingBox.origin.y);
        _timerLabel.position=ccp(statusBarSprite.boundingBox.origin.x + size.width*.15,statusBarSprite.boundingBox.origin.y + size.height*0.055);
//        _timerLabel.position=ccp(size.width-size.width/15,size.height-(size.height/10));
        [self addChild:_timerLabel z:4 tag:kTAGTimer];
        
        
        [[SimpleAudioEngine sharedEngine] preloadEffect:@"click.caf"];
        [[SimpleAudioEngine sharedEngine] preloadEffect:@"ding.caf"];
#ifdef HALLOWEEN
//        [[SimpleAudioEngine sharedEngine] preloadBackgroundMusic:@"spooky2.caf"];
//        [[SimpleAudioEngine sharedEngine] playBackgroundMusic:@"spooky2.caf" loop:YES];
#endif

        
	}
    
    winCount=0;
    
    _targetCharacter=[_arrCharacters objectAtIndex:0];
    _targetCharacter.isTarget=YES;
    [self showTargetLabel];
    [TestFlight passCheckpoint:@"SET_INITIAL_TARGET"];
    
    [self schedule: @selector(updateTimer:) interval:1.0];
       
    [TestFlight passCheckpoint:@"RETURNING_SCENE"];
    
	return self;
}

-(CharacterSprite *) setNextTarget
{
//   NSLog(@"Characters Array: %i", self.arrCharacters.count);
    
    NSEnumerator *characterEnum=[_arrCharacters objectEnumerator];
    CharacterSprite *nextCharacter;
    while(nextCharacter=[characterEnum nextObject]){
        if(nextCharacter.isTarget){
            nextCharacter.isTarget=NO;
            nextCharacter=[characterEnum nextObject];
            nextCharacter.isTarget=YES;
            return nextCharacter;
            [TestFlight passCheckpoint:@"SET_NEXT_TARGET"];
        }
    }
    [TestFlight passCheckpoint:@"NO_MORE_TARGETS_RETURNING_NIL"];
    return nil;
}

-(void)signalWin{
    
    [TestFlight passCheckpoint:@"SIGNALING_WIN"];
    
    [self unschedule:@selector(removeFireworks)];
    
    CGSize size = [[CCDirector sharedDirector] winSize];
   
    //Hide instructions
    winCount++;
    if(winCount>1)
        [self getChildByTag:kTAGInstructions].visible=NO;
    
    //Move all the other characters around
    CGSize playableAreaSize=CGSizeMake(size.width, size.height-(2 * (size.height/8)));
    NSEnumerator *characterEnum=[_arrCharacters objectEnumerator];
    CharacterSprite *nextCharacter;
    //First set them to 0,0
    while(nextCharacter=[characterEnum nextObject]){
        if(!nextCharacter.isTarget){
            nextCharacter.position=ccp(0,0);
        }
    }
    
    characterEnum=[_arrCharacters objectEnumerator]; 
    while(nextCharacter=[characterEnum nextObject]){
//        CCLOG(@"Setting %@", nextCharacter.description);
        if(!nextCharacter.isTarget){
            [nextCharacter setRandomPosition:playableAreaSize checkOtherSprites:_arrCharacters];
            CCSprite *statusBarSprite=(CCSprite*)[self getChildByTag:kTAGHUD];
            CCSprite *henryBody=(CCSprite*)[self getChildByTag:kTAGhenry];
            while(CGRectIntersectsRect(statusBarSprite.boundingBox, nextCharacter.boundingBox) 
                  || CGRectIntersectsRect(henryBody.boundingBox, nextCharacter.boundingBox) 
                  || CGRectIntersectsRect(_henryHead.boundingBox, nextCharacter.boundingBox)){
                [nextCharacter setRandomPosition:playableAreaSize checkOtherSprites:_arrCharacters];
            }
        }
    }


    
    CCParticleSystem *system=(CCParticleSystem *)[self getChildByTag:kTAGfireWorks];
    if(system!=nil){
        [self removeChild:system cleanup:YES];
    }
    system=[CCParticleSystemQuad particleWithFile:@"startParticles.plist"];
    if (UI_USER_INTERFACE_IDIOM() != UIUserInterfaceIdiomPad) { 
        [system setScaleX:size.width/1024.0f];
        [system setScaleY:size.height/768.0f];
    }
    system.position=_targetCharacter.position;
    [self addChild:system z:1 tag:kTAGfireWorks];


    [[SimpleAudioEngine sharedEngine] playEffect:@"ding.caf"];
    
    
        
    _targetCharacter=[self setNextTarget];
    if(_targetCharacter==nil){
        [self gameOver];
        
    }else{
        [self schedule:@selector(removeFireworks) interval:4];
        [self showTargetLabel];
    }
    [TestFlight passCheckpoint:@"WIN_SIGNALED"];
}

-(void)gameOver{

    [TestFlight passCheckpoint:@"SIGNALING_GAME_OVER"];
    
    [self unschedule:@selector(updateTimer:)];
//    [self removeChildByTag:kTAGtargetLabel cleanup:YES];
    [self removeChildByTag:kTAGtargetSprite cleanup:YES];
    [self removeChildByTag:kTAGHUD cleanup:YES];
    [self removeChildByTag:kTAGTimer cleanup:YES];
    
    CGSize size = [[CCDirector sharedDirector] winSize];
//    CCLabelTTF *gameOverLabel = [CCLabelTTF labelWithString:@"Game Over" fontName:@"Marker Felt" fontSize:64];
    CCLabelBMFont *gameOverLabel=[CCLabelBMFont labelWithString:@"Game Over" fntFile:@"Corben-64.fnt"];
    CCLabelBMFont *gameOverTime=[CCLabelBMFont labelWithString:[NSString stringWithFormat:@"All objects found in %.0f seconds", gameTimer] fntFile:@"Corben-64.fnt"];
    
    [FlurryAnalytics logEvent:@"GAME_WON" withParameters:[NSDictionary dictionaryWithObjectsAndKeys:[NSNumber numberWithInt:(int)gameTimer],
                                                          @"Time To Complete", 
                                                          nil]
     ];
    
#ifdef HALLOWEEN
    gameOverLabel.color=ccORANGE;
    gameOverTime.color=ccORANGE;
#endif

    if (UI_USER_INTERFACE_IDIOM() != UIUserInterfaceIdiomPad) { 
        [gameOverLabel setScaleX:size.width/1024.0f];
        [gameOverLabel setScaleY:size.height/768.0f];
        
        [gameOverTime setScaleX:(size.width/1024.0f) *0.4];
        [gameOverTime setScaleY:(size.height/768.0f) *0.4];
    }else{
        [gameOverTime setScale:0.4];
    }
    gameOverLabel.position =  ccp( size.width /2 , size.height/2 );
    gameOverTime.position=ccp(size.width * 0.5, size.height-size.height * 0.6);
    [self addChild: gameOverLabel];
    [self addChild:gameOverTime];
    
    [self removeChildByTag:kTAGnight cleanup:YES];
    [_headLampLight setVisible:NO];
        
    [TestFlight passCheckpoint:@"GAME_OVER_SIGNALED"];
    
    [self schedule:@selector(loadScores) interval:2.0];
    
//    playAgainMenu.position=ccp(size.width/2, size.height/2);  //size.height-size.height * 0.8);
//    labelPlayAgainItem.position=ccp(size.width/2, size.height/2);
    
}

-(void) loadScores{
    [TestFlight passCheckpoint:@"LOADING_SCORES_SCENE"];
    CCScene *scoresScene=[CCScene node];
    ScoresLayer *showScores=[ScoresLayer node];
    [showScores withTime:gameTimer];
    [scoresScene addChild:showScores];
    [[CCDirector sharedDirector] replaceScene:
     [CCTransitionRotoZoom transitionWithDuration:3.0f scene:scoresScene]];
}

-(void)showTargetLabel{
//    [self removeChildByTag:kTAGtargetLabel cleanup:YES];
    [self removeChildByTag:kTAGtargetSprite cleanup:YES];
    CGSize size = [[CCDirector sharedDirector] winSize];
    CCSprite *HUDSprite=(CCSprite *)[self getChildByTag:kTAGHUD];
    
//    _timerLabel.position=ccp(statusBarSprite.boundingBox.origin.x + size.width*.15,statusBarSprite.boundingBox.origin.y + size.width*0.04);
    
//    float usableHUDHeight=(.35*HUDSprite.boundingBox.size.height);
    float usableHUDHeight=(.4*HUDSprite.boundingBox.size.height);
    float usableHUDWidth=(.86*HUDSprite.boundingBox.size.width);
    
    
    CharacterSprite *targetSpriteCopy=[CharacterSprite spriteWithTexture:_targetCharacter.texture rect:_targetCharacter.textureRect];
//    [targetSpriteCopy setScale:.25];
    if (UI_USER_INTERFACE_IDIOM() != UIUserInterfaceIdiomPad) { 
        float scale = MAX(targetSpriteCopy.boundingBox.size.height/usableHUDHeight, targetSpriteCopy.boundingBox.size.width/usableHUDWidth);
        [targetSpriteCopy setScale:1/scale];
//        [targetSpriteCopy setScaleX:size.width/1024.0f * (1/scale) * 1.4];
//        [targetSpriteCopy setScaleY:size.height/768.0f * (1/scale) * 1.4];
//        targetSpriteCopy.position=ccp(size.width/3, .5*(size.height/8));
    }else{
        float scale = MAX(targetSpriteCopy.boundingBox.size.height/usableHUDHeight, targetSpriteCopy.boundingBox.size.width/usableHUDWidth);
        [targetSpriteCopy setScale:1/scale];
//        targetSpriteCopy.position=ccp(1.2*(size.width/3), .5*(size.height/8));
    }
    targetSpriteCopy.anchorPoint=ccp(0.5,0);
    targetSpriteCopy.position=ccp(HUDSprite.boundingBox.origin.x + HUDSprite.boundingBox.size.width/2, HUDSprite.boundingBox.origin.y + size.height*0.1);
    targetSpriteCopy.color=_targetCharacter.color;
    [self addChild:targetSpriteCopy z:5 tag:kTAGtargetSprite];
}

-(void)removeFireworks{
    CCLOG(@"Removing fireworks");
    [self unschedule:@selector(removeFireworks)];
//    CCParticleSystem *system=(CCParticleSystem *)[self getChildByTag:kTAGfireWorks];
//    system.visible=NO;
    [self removeChildByTag:kTAGfireWorks cleanup:YES];
}

-(void) updateTimer: (ccTime) dt
{
    gameTimer+=dt;
    _timerLabel.string=[NSString stringWithFormat:@"%i", (int)gameTimer];
//    if(gameTimer>2)
//        [self gameOver];
}

- (void)registerWithTouchDispatcher {
    [[CCTouchDispatcher sharedDispatcher] addTargetedDelegate:self 
                                                     priority:0 swallowsTouches:YES];
}

- (BOOL)ccTouchBegan:(UITouch *)touch withEvent:(UIEvent *)event {
    CGPoint location = [touch locationInView:[touch view]];
    location = [[CCDirector sharedDirector] convertToGL:location];

    [[SimpleAudioEngine sharedEngine] playEffect:@"click.caf"];
    
    _headLampLight.position=location;
    
    
    [_henryHead setDisplayFrame:[[CCSpriteFrameCache sharedSpriteFrameCache] spriteFrameByName:@"HenryHead.png"]];
    
    int offX = _henryHead.position.x - location.x;
    int offY =  _henryHead.position.y - location.y;
    float angleRadians = atanf((float)offY / (float)offX);
    float angleDegrees = CC_RADIANS_TO_DEGREES(angleRadians);
    float cocosAngle = -1 * (angleDegrees+25);
//    CCLOG(@"Rotating TO: %f", cocosAngle);
    if(cocosAngle>=0)
        _henryHead.rotation=cocosAngle;
    
    [_headLampLight setVisible:YES];
    [[self getChildByTag:kTAGnight] setVisible:NO];
    
    [self removeChildByTag:kTAGfireWorks cleanup:YES];
    
    return TRUE;
}

-(void)ccTouchMoved:(UITouch *)touch withEvent:(UIEvent *)event{
    CGPoint location = [touch locationInView:[touch view]];
    
    location = [[CCDirector sharedDirector] convertToGL:location];
   
    _headLampLight.position=location;
    
    [_henryHead setDisplayFrame:[[CCSpriteFrameCache sharedSpriteFrameCache] spriteFrameByName:@"HenryHead.png"]];
    
    int offX = _henryHead.position.x - location.x;
    int offY =  _henryHead.position.y - location.y;
    float angleRadians = atanf((float)offY / (float)offX);
    float angleDegrees = CC_RADIANS_TO_DEGREES(angleRadians);
    float cocosAngle = -1 * (angleDegrees+25);
//    CCLOG(@"Rotating TO: %f", cocosAngle);
    if(cocosAngle>=0)
        _henryHead.rotation=cocosAngle;

    
//    location=[self convertTouchToNodeSpace:touch];
    if(CGRectContainsPoint([_targetCharacter getBoundingRect], location)){
        NSLog(@"Contains Point!");
        [self signalWin];
    }
}

-(void)ccTouchEnded:(UITouch *)touch withEvent:(UIEvent *)event{
    [[self getChildByTag:kTAGnight] setVisible:YES];
    [[SimpleAudioEngine sharedEngine] playEffect:@"click.caf"];

    [_henryHead setDisplayFrame:[[CCSpriteFrameCache sharedSpriteFrameCache] spriteFrameByName:@"HenryHead-Off.png"]];
    
    [_headLampLight setVisible:NO];
}


-(void)dealloc{
    self.arrCharacters=nil;
    [super dealloc];
}

@end
