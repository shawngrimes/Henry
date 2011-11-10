//
//  GameLayer.m
//  HenryAndHisHeadlamp
//
//  Created by Shawn Grimes on 9/8/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "GameLayer.h"
#import "CharacterSprite.h"
#import "PrizeSelectionScene.h"

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

int kNumObjects=7;

+(CCScene *) sceneWithGameMode:(GameModeType)selectedGameMode
{
	// 'scene' is an autorelease object.
	CCScene *scene = [CCScene node];
	
	// 'layer' is an autorelease object.
	GameLayer *layer = [[[GameLayer alloc] initWithGameMode:selectedGameMode] autorelease];
	
	// add layer as a child to scene
	[scene addChild: layer];

    
//    ParentLoginViewController *parentVC=[[ParentLoginViewController alloc] init];
//    AppDelegate *myDelegate=(AppDelegate *)[[UIApplication sharedApplication] delegate];
//    [[myDelegate.window.subviews objectAtIndex:0] addSubview:parentVC.view];
//    [parentVC release];
	
	// return the scene
	return scene;
}

-(id) initWithGameMode:(GameModeType) selectedGameMode
{
    [TestFlight passCheckpoint:@"INIT_SCENE"];
	// always call "super" init
	// Apple recommends to re-assign "self" with the "super" return value
	if( (self=[super init])) {
        
        self.isTouchEnabled=YES;

        gameMode=selectedGameMode;
        
        CGSize size = [[CCDirector sharedDirector] winSize];
        
        CCSpriteFrameCache *frameCache=[CCSpriteFrameCache sharedSpriteFrameCache];
        if (UI_USER_INTERFACE_IDIOM() != UIUserInterfaceIdiomPad) { 
            [frameCache addSpriteFramesWithFile:@"HenryBodyTextures.plist"];
        }else{
            [frameCache addSpriteFramesWithFile:@"HenryBodyTextures-hd.plist"];
        }
        
#ifdef HALLOWEEN
        //Stuff for Lite version
        CCSprite *backgroundSprite=[CCSprite spriteWithFile:@"Henry_Hallo_bkgrd.png"];
#elif SMART
        //Stuff for Full version
        int backGroundNumber=arc4random() % 3;
        CCSprite *backgroundSprite=[CCSprite spriteWithFile:[NSString stringWithFormat:@"SmartHenry_Bkgrd_%i.png", backGroundNumber]];
#endif

//if (UI_USER_INTERFACE_IDIOM() != UIUserInterfaceIdiomPad) { 
//    [backgroundSprite setScaleX:size.width/1024.0f];
//    [backgroundSprite setScaleY:size.height/768.0f];
//}
        backgroundSprite.position=ccp(size.width/2, size.height/2);
        [self addChild:backgroundSprite];
        
#ifdef HALLOWEEN
        [[CCSpriteFrameCache sharedSpriteFrameCache] addSpriteFramesWithFile:@"buttonsAndResources-Halloween.plist"];
        CCSprite *statusBarSprite=[CCSprite spriteWithSpriteFrameName:@"Henry_Spooky_Status_Box.png"];
#elif SMART
        CCSprite *statusBarSprite=[CCSprite spriteWithFile:@"SmartHenry_StatusBox.png"];
#endif
//        if (UI_USER_INTERFACE_IDIOM() != UIUserInterfaceIdiomPad) { 
//            [statusBarSprite setScaleX:size.width/1024.0f];
//            [statusBarSprite setScaleY:size.height/768.0f];
//        }else{
//            [statusBarSprite setScale:1.2];
//        }
        statusBarSprite.anchorPoint=ccp(1,1);
        statusBarSprite.position=ccp(size.width,size.height);
        [self addChild:statusBarSprite z:3 tag:kTAGHUD];
        
        
        CCSprite *henryBody=[CCSprite spriteWithSpriteFrameName:@"HenryBody.png"];
        _henryHead=[CCSprite spriteWithSpriteFrameName:@"HenryHead-Off.png"];
//        if (UI_USER_INTERFACE_IDIOM() != UIUserInterfaceIdiomPad) { 
//            [henryBody setScaleX:size.width/1024.0f];
//            [henryBody setScaleY:size.height/768.0f];
//            [_henryHead setScaleX:size.width/1024.0f * 1.25];
//            [_henryHead setScaleY:size.height/768.0f * 1.25];
//        }else{
            _henryHead.scale=1.25;
//        }
        henryBody.anchorPoint=ccp(0.5, 0);
        henryBody.position=ccp(size.width-((henryBody.textureRect.size.width * henryBody.scaleX) + .01*size.width), 0);
        
        _henryHead.anchorPoint=ccp(0.581,0.188);
        _henryHead.position=ccp(henryBody.boundingBox.origin.x+((henryBody.boundingBox.size.width)/2 + .13 * henryBody.boundingBox.size.width), 
                                ((henryBody.boundingBox.size.height) - (.2*henryBody.boundingBox.size.height)));// * _henryHead.scaleY);
//        CCLOG(@"Henry Head Position: %f %f", _henryHead.position.x, _henryHead.position.y);
//        _henryHead.rotation= 22.700861;
        _henryHead.rotation=-22.700861;
        [self addChild:henryBody z:9 tag:kTAGhenry];
        [self addChild:_henryHead z:10 tag:kTAGhenryHead];

        
         CGSize playableAreaSize=CGSizeMake(size.width, size.height);

        _arrCharacters=[[NSMutableArray alloc] initWithCapacity:7];        
        
        [TestFlight passCheckpoint:@"PLACING_CHARACTERS"];
#ifdef HALLOWEEN
        
        
        
        int MAX_CHARACTERS=28;
        
        NSMutableArray *aryCharacterTypes=[NSMutableArray arrayWithCapacity:kNumObjects];
        for (int c=0; c<kNumObjects; c++) {
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
                     CCLOG(@"Intersect other RECT2");
                            [randomSprite setRandomPosition:playableAreaSize checkOtherSprites:_arrCharacters];
                }
            }
            
            [_arrCharacters addObject:randomSprite];
            [self addChild:randomSprite];
        }
        
       
        
#elif SMART
        switch (gameMode) {
            case kGameModeUpperAlphabet:
            {
                int CHARACTER_COUNT=26;
                NSString *letters=@"ABCDEFGHIJKLMNOPQRSTUVWXYZ";
                NSMutableArray *aryCharacterTypes=[NSMutableArray arrayWithCapacity:kNumObjects];
                for (int c=0; c<kNumObjects; c++) {
                    int randomCharacterInt=arc4random() % CHARACTER_COUNT;
                    while ([aryCharacterTypes containsObject:[NSNumber numberWithInt:randomCharacterInt]]){
                        randomCharacterInt=arc4random() % CHARACTER_COUNT;
                    }
                    [aryCharacterTypes addObject:[NSNumber numberWithInt:randomCharacterInt]];
                    CCLOG(@"Random Character Type: %i", randomCharacterInt);

                    NSString *randomCharacter=[NSString stringWithFormat:@"%c",[letters characterAtIndex:randomCharacterInt]];
                    CCLOG(@"Random Character: %@", randomCharacter);

                    CharacterSprite *randomSprite=[[[CharacterSprite alloc] initWithString:randomCharacter] autorelease];
                    CCLOG(@"randomSprite before scale Box: %f, %f, %f, %f", randomSprite.boundingBox.origin.x, randomSprite.boundingBox.origin.y, randomSprite.boundingBox.size.width,randomSprite.boundingBox.size.height);
                    if (UI_USER_INTERFACE_IDIOM() != UIUserInterfaceIdiomPad) { 
                        CGSize winSizeInPixels=[[CCDirector sharedDirector] winSizeInPixels];
                        [randomSprite setScale:winSizeInPixels.width/1024.0f];
//                        [randomSprite setScaleY:size.height/768.0f];
                    }
                     CCLOG(@"randomSprite after scale : %f, %f, %f, %f", randomSprite.boundingBox.origin.x, randomSprite.boundingBox.origin.y, randomSprite.boundingBox.size.width,randomSprite.boundingBox.size.height);
                    
                    if(_arrCharacters.count<1){
//                        CCLOG(@"Random Sprite Size: %f, %f", randomSprite.boundingBox.size.width,randomSprite.boundingBox.size.height);
                        [randomSprite setRandomPosition:playableAreaSize];
                        while(CGRectIntersectsRect(statusBarSprite.boundingBox, [randomSprite getChildRect]) 
                              || CGRectIntersectsRect(henryBody.boundingBox, [randomSprite getChildRect]) 
                              || CGRectIntersectsRect(_henryHead.boundingBox, [randomSprite getChildRect])){
                            CCLOG(@"Intersect other RECT1");
                            [randomSprite setRandomPosition:playableAreaSize];
                        }
                    }else{
//                        CCLOG(@"Random Sprite Size: %f, %f", randomSprite.contentSize.width, randomSprite.contentSize.height);
//                        [randomSprite setRandomPosition:playableAreaSize];
                        [randomSprite setRandomPosition:playableAreaSize checkOtherSprites:_arrCharacters];
//                        while(CGRectIntersectsRect(statusBarSprite.boundingBox, [randomSprite getChildRect]) 
//                              || CGRectIntersectsRect(henryBody.boundingBox, [randomSprite getChildRect]) 
//                              || CGRectIntersectsRect(_henryHead.boundingBox, [randomSprite getChildRect])){
//                            CCLOG(@"Intersect other RECT2");
//                            [randomSprite setRandomPosition:playableAreaSize checkOtherSprites:_arrCharacters];
//                        }
                    }
//                    for (CCSprite *child in randomSprite.children) {
//                        child.color=ccc3(118,188,241);
//                    }
                    randomSprite.color=ccc3(118,188,241);
                    [_arrCharacters addObject:randomSprite];
                    [self addChild:randomSprite];
                }

                
                break;
            }   
            case kGameModeLowerAlphabet:
            {
                int CHARACTER_COUNT=26;
                NSString *letters=@"abcdefghijklmnopqrstuvwxyz";
                NSMutableArray *aryCharacterTypes=[NSMutableArray arrayWithCapacity:kNumObjects];
                for (int c=0; c<kNumObjects; c++) {
                    int randomCharacterInt=arc4random() % CHARACTER_COUNT;
                    while ([aryCharacterTypes containsObject:[NSNumber numberWithInt:randomCharacterInt]]){
                        randomCharacterInt=arc4random() % CHARACTER_COUNT;
                    }
                    [aryCharacterTypes addObject:[NSNumber numberWithInt:randomCharacterInt]];
                    CCLOG(@"Random Character Type: %i", randomCharacterInt);
                    
                    NSString *randomCharacter=[NSString stringWithFormat:@"%c",[letters characterAtIndex:randomCharacterInt]];
                    CCLOG(@"Random Character: %@", randomCharacter);
                    
                    CharacterSprite *randomSprite=[[[CharacterSprite alloc] initWithString:randomCharacter] autorelease];
                    
                    if (UI_USER_INTERFACE_IDIOM() != UIUserInterfaceIdiomPad) { 
                        CGSize winSizeInPixels=[[CCDirector sharedDirector] winSizeInPixels];
                        [randomSprite setScale:winSizeInPixels.width/1024.0f];
                    }
                    if(_arrCharacters.count<1){
                        [randomSprite setRandomPosition:playableAreaSize];
                        while(CGRectIntersectsRect(statusBarSprite.boundingBox, [randomSprite getChildRect]) 
                              || CGRectIntersectsRect(henryBody.boundingBox, [randomSprite getChildRect]) 
                              || CGRectIntersectsRect(_henryHead.boundingBox, [randomSprite getChildRect])){
                            CCLOG(@"Intersect other RECT1");
                            [randomSprite setRandomPosition:playableAreaSize];
                        }
                    }else{
                        [randomSprite setRandomPosition:playableAreaSize checkOtherSprites:_arrCharacters];
                        while(CGRectIntersectsRect(statusBarSprite.boundingBox, [randomSprite getChildRect]) 
                              || CGRectIntersectsRect(henryBody.boundingBox, [randomSprite getChildRect]) 
                              || CGRectIntersectsRect(_henryHead.boundingBox, [randomSprite getChildRect])){
                            CCLOG(@"Intersect other RECT2");
                            [randomSprite setRandomPosition:playableAreaSize checkOtherSprites:_arrCharacters];
                        }
                    }
//                    for (CCSprite *child in randomSprite.children) {
//                        child.color=ccc3(216,60,68);
//                    }
                    randomSprite.color=ccc3(216,60,68);
                    [_arrCharacters addObject:randomSprite];
                    [self addChild:randomSprite];
                }
                break;
            }
            case kGameModeNumbers:
                {
                    int CHARACTER_COUNT=20;
//                    NSString *letters=@"0123456789";
                    NSMutableArray *aryCharacterTypes=[NSMutableArray arrayWithCapacity:kNumObjects];
                    for (int c=0; c<kNumObjects; c++) {
                        int randomCharacterInt=(arc4random() % CHARACTER_COUNT)+1;
                        while ([aryCharacterTypes containsObject:[NSNumber numberWithInt:randomCharacterInt]]){
                            randomCharacterInt=(arc4random() % CHARACTER_COUNT)+1;
                        }
                        [aryCharacterTypes addObject:[NSNumber numberWithInt:randomCharacterInt]];
                        CCLOG(@"Random Character Type: %i", randomCharacterInt);
                        
                        NSString *randomCharacter=[NSString stringWithFormat:@"%i",randomCharacterInt];
                        CCLOG(@"Random Character: %@", randomCharacter);
                        
                        CharacterSprite *randomSprite=[[[CharacterSprite alloc] initWithString:randomCharacter] autorelease];
                        if (UI_USER_INTERFACE_IDIOM() != UIUserInterfaceIdiomPad) { 
                            CGSize winSizeInPixels=[[CCDirector sharedDirector] winSizeInPixels];
                            [randomSprite setScale:winSizeInPixels.width/1024.0f];
                        }
                        if(_arrCharacters.count<1){
                            [randomSprite setRandomPosition:playableAreaSize];
                            while(CGRectIntersectsRect(statusBarSprite.boundingBox, [randomSprite getChildRect]) 
                                  || CGRectIntersectsRect(henryBody.boundingBox, [randomSprite getChildRect]) 
                                  || CGRectIntersectsRect(_henryHead.boundingBox, [randomSprite getChildRect])){
                                CCLOG(@"Intersect other RECT1");
                                [randomSprite setRandomPosition:playableAreaSize];
                            }
                        }else{
                            [randomSprite setRandomPosition:playableAreaSize checkOtherSprites:_arrCharacters];
                            while(CGRectIntersectsRect(statusBarSprite.boundingBox, [randomSprite getChildRect]) 
                                  || CGRectIntersectsRect(henryBody.boundingBox, [randomSprite getChildRect]) 
                                  || CGRectIntersectsRect(_henryHead.boundingBox, [randomSprite getChildRect])){
                                CCLOG(@"Intersect other RECT2");
                                [randomSprite setRandomPosition:playableAreaSize checkOtherSprites:_arrCharacters];
                            }
                        }
//                        for (CCSprite *child in randomSprite.children) {
//                            child.color=ccc3(93, 185, 51);
//                        }
                        randomSprite.color=ccc3(93, 185, 51);
                        [_arrCharacters addObject:randomSprite];
                        [self addChild:randomSprite];
                    }
                    break;
                }
            case kGameModeShapes:
            {
                int MAX_CHARACTERS=kCharacterTypeMAX-1;
                
                NSMutableArray *aryCharacterTypes=[NSMutableArray arrayWithCapacity:kNumObjects];
                for (int c=0; c<kNumObjects; c++) {
                    int randomCharacter=arc4random() % MAX_CHARACTERS+1;
                    while ([aryCharacterTypes containsObject:[NSNumber numberWithInt:randomCharacter]]){
                        randomCharacter=arc4random() % MAX_CHARACTERS+1;
                    }
                    [aryCharacterTypes addObject:[NSNumber numberWithInt:randomCharacter]];
                    CCLOG(@"Random Character Type: %i", randomCharacter);
                    int randomColor=(arc4random() % kCharacterColorMAX)+1;
                    CharacterSprite *randomSprite=[CharacterSprite characterOfType:randomCharacter withColor:randomColor];
//                    if (UI_USER_INTERFACE_IDIOM() != UIUserInterfaceIdiomPad) { 
//                        CGSize winSizeInPixels=[[CCDirector sharedDirector] winSizeInPixels];
//                        [randomSprite setScale:winSizeInPixels.width/1024.0f];
//                    }
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
                            CCLOG(@"Intersect other RECT2");
                            [randomSprite setRandomPosition:playableAreaSize checkOtherSprites:_arrCharacters];
                        }
                    }
                    
                    [_arrCharacters addObject:randomSprite];
                    [self addChild:randomSprite];
                }

                break;
            }
            case kGameModeSmartAll:
            {
                int MAX_CHARACTERS=kCharacterTypeMAX-1;
                
                NSMutableArray *aryCharacterTypes=[NSMutableArray arrayWithCapacity:kNumObjects];
                for (int c=0; c<kNumObjects; c++) {
                    int spriteTypeInt=arc4random() % 4;
                    CCLOG(@"SpriteInt: %i", spriteTypeInt);
                    CharacterSprite *randomSprite;
                    switch (spriteTypeInt) {
                        case 0:
                        {
                            int CHARACTER_COUNT=26;
                            NSString *letters=@"ABCDEFGHIJKLMNOPQRSTUVWXYZ";
                            int randomCharacterInt=arc4random() % CHARACTER_COUNT;
                            NSString *randomCharacter=[NSString stringWithFormat:@"%c",[letters characterAtIndex:randomCharacterInt]];
                            randomSprite=[[[CharacterSprite alloc] initWithString:randomCharacter] autorelease];
                            while ([aryCharacterTypes containsObject:randomSprite]){
                                int randomCharacterInt=arc4random() % CHARACTER_COUNT;
                                NSString *randomCharacter=[NSString stringWithFormat:@"%c",[letters characterAtIndex:randomCharacterInt]];
                                randomSprite=[[[CharacterSprite alloc] initWithString:randomCharacter] autorelease];
                            }
                            if (UI_USER_INTERFACE_IDIOM() != UIUserInterfaceIdiomPad) { 
                                [randomSprite setScale:size.width/1024.0f];
//                                [randomSprite setScaleY:size.height/768.0f];
                            }
                            for (CCSprite *child in randomSprite.children) {
                                child.color=ccc3(118,188,241);
                            }
                            randomSprite.color=ccc3(118,188,241);
                            
                            break;
                        }
                        case 1:
                        {
                            int CHARACTER_COUNT=26;
                            NSString *letters=@"abcdefghijklmnopqrstuvwxyz";
                            int randomCharacterInt=arc4random() % CHARACTER_COUNT;
                            NSString *randomCharacter=[NSString stringWithFormat:@"%c",[letters characterAtIndex:randomCharacterInt]];
                            randomSprite=[[[CharacterSprite alloc] initWithString:randomCharacter] autorelease];
                            while ([aryCharacterTypes containsObject:randomSprite]){
                                int randomCharacterInt=arc4random() % CHARACTER_COUNT;
                                NSString *randomCharacter=[NSString stringWithFormat:@"%c",[letters characterAtIndex:randomCharacterInt]];
                                randomSprite=[[[CharacterSprite alloc] initWithString:randomCharacter] autorelease];
                            }
                            if (UI_USER_INTERFACE_IDIOM() != UIUserInterfaceIdiomPad) { 
                                [randomSprite setScale:size.width/1024.0f];
//                                [randomSprite setScaleY:size.height/768.0f];
                            }
                            for (CCSprite *child in randomSprite.children) {
                                child.color=ccc3(216,60,68);
                            }
                            randomSprite.color=ccc3(216,60,68);

                            break;
                        }
                        case 2:
                        {
                            int CHARACTER_COUNT=20;
                            int randomCharacterInt=(arc4random() % CHARACTER_COUNT)+1;
                            NSString *randomCharacter=[NSString stringWithFormat:@"%i",randomCharacterInt];
                            randomSprite=[[[CharacterSprite alloc] initWithString:randomCharacter] autorelease];
                            while ([aryCharacterTypes containsObject:randomSprite]){
                                int randomCharacterInt=(arc4random() % CHARACTER_COUNT)+1;
                                NSString *randomCharacter=[NSString stringWithFormat:@"%i",randomCharacterInt];
                                randomSprite=[[[CharacterSprite alloc] initWithString:randomCharacter] autorelease];
                            }
                            if (UI_USER_INTERFACE_IDIOM() != UIUserInterfaceIdiomPad) { 
                                [randomSprite setScale:size.width/1024.0f];
//                                [randomSprite setScaleY:size.height/768.0f];
                            }
                            for (CCSprite *child in randomSprite.children) {
                                child.color=ccc3(93, 185, 51);
                            }
                            randomSprite.color=ccc3(93, 185, 51);
                            break;
                        }
                        
                        case 3:
                        {
                            int MAX_CHARACTERS=kCharacterTypeMAX-1;
                            int randomCharacter=(arc4random() % MAX_CHARACTERS)+1;
                            int randomColor=(arc4random() % kCharacterColorMAX)+1;
                            randomSprite=[CharacterSprite characterOfType:randomCharacter withColor:randomColor];
                            while ([aryCharacterTypes containsObject:randomSprite]){
                                int randomCharacter=arc4random() % MAX_CHARACTERS+1;
                                int randomColor=(arc4random() % kCharacterColorMAX)+1;
                                randomSprite=[CharacterSprite characterOfType:randomCharacter withColor:randomColor];
                            }

                            break;
                        }
                        default:
                            break;
                    }
                    [aryCharacterTypes addObject:randomSprite];
                    if(_arrCharacters.count<1){
                        [randomSprite setRandomPosition:playableAreaSize];
                        while(CGRectIntersectsRect(statusBarSprite.boundingBox, [randomSprite getChildRect]) 
                              || CGRectIntersectsRect(henryBody.boundingBox, [randomSprite getChildRect]) 
                              || CGRectIntersectsRect(_henryHead.boundingBox, [randomSprite getChildRect])){
                            CCLOG(@"Intersect other RECT1");
                            [randomSprite setRandomPosition:playableAreaSize];
                        }
                    }else{
                        [randomSprite setRandomPosition:playableAreaSize checkOtherSprites:_arrCharacters];
                        while(CGRectIntersectsRect(statusBarSprite.boundingBox, [randomSprite getChildRect]) 
                              || CGRectIntersectsRect(henryBody.boundingBox, [randomSprite getChildRect]) 
                              || CGRectIntersectsRect(_henryHead.boundingBox, [randomSprite getChildRect])){
                            CCLOG(@"Intersect other RECT2");
                            [randomSprite setRandomPosition:playableAreaSize checkOtherSprites:_arrCharacters];
                        }
                    }
                    
                    [_arrCharacters addObject:randomSprite];
                    [self addChild:randomSprite];
                    
                }
                
                
                break;
            }
            default:
                break;
        }
        
#endif
        
         [TestFlight passCheckpoint:@"PLACED_CHARACTERS"];
        
        
        
        _headLampLight=[CCSprite spriteWithFile:@"headLampLight.png"];
//        if (UI_USER_INTERFACE_IDIOM() != UIUserInterfaceIdiomPad) { 
//            [_headLampLight setScaleX:size.width/1024.0f * 1.4];
//            [_headLampLight setScaleY:size.height/768.0f * 1.4];
//        }else{
            [_headLampLight setScale:1.4];
//        }
//        if (UI_USER_INTERFACE_IDIOM() != UIUserInterfaceIdiomPad) { 
            _headLampLight.anchorPoint=ccp(0.5,0.45);
//        }else{
//            _headLampLight.anchorPoint=ccp(0.5,0.5);
//        }
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
        CGSize winSizeInPixels=[[CCDirector sharedDirector] winSizeInPixels];
        if (UI_USER_INTERFACE_IDIOM() != UIUserInterfaceIdiomPad) { 
            
            [labelInstructions setScale:(winSizeInPixels.width/1024.0f) * .5];
//            [labelInstructions setScaleY:(size.height/768.0f)/2.0];
        }else{
            [labelInstructions setScale:0.33];
        }
		labelInstructions.position =  ccp( size.width /2 , size.height - size.height/15 );
		[self addChild: labelInstructions z:9 tag:kTAGInstructions];
        
        
        _timerLabel=[CCLabelBMFont labelWithString:@"0" fntFile:@"Corben-64.fnt"];
//        if (UI_USER_INTERFACE_IDIOM() != UIUserInterfaceIdiomPad){
//            [_timerLabel setScaleX:size.width/1024.0f * 0.4];
//            [_timerLabel setScaleY:size.height/768.0f * 0.4];
//        }else{
        [_timerLabel setScale:(winSizeInPixels.width/1024.0f) * .4];
//        }

//        CCLOG(@"Status Bar: %f, %f",statusBarSprite.boundingBox.origin.x, statusBarSprite.boundingBox.origin.y);
        _timerLabel.position=ccp(statusBarSprite.boundingBox.origin.x + size.width*.13,statusBarSprite.boundingBox.origin.y + size.height*0.055);
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
        CGSize winSizeInPixels=[[CCDirector sharedDirector] winSizeInPixels];
        [gameOverLabel setScale:winSizeInPixels.width/1024.0f];
        
        [gameOverTime setScale:(winSizeInPixels.width/1024.0f) *0.4];
//        [gameOverTime setScaleY:(size.height/768.0f) *0.4];
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
    [self unscheduleAllSelectors];
    [TestFlight passCheckpoint:@"LOADING_SCORES_SCENE"];
#ifdef HALLOWEEN
    CCScene *scoresScene=[CCScene node];
    ScoresLayer *showScores=[ScoresLayer node];
    [showScores withTime:gameTimer];
    [scoresScene addChild:showScores];
    [[CCDirector sharedDirector] replaceScene:
     [CCTransitionRotoZoom transitionWithDuration:2.0f scene:scoresScene]];
#elif SMART
    CCScene *scoreScene=[CCScene node];
    PrizeSelectionScene *prizeLayer=[[[PrizeSelectionScene alloc] initWithTime:gameTimer andGameModeType:gameMode] autorelease];
//    [prizeLayer withTime:gameTimer];
    [scoreScene addChild:prizeLayer];
    
    [[CCDirector sharedDirector] replaceScene:
     [CCTransitionRotoZoom transitionWithDuration:2.0f scene:scoreScene]];
#endif
    
}

-(void)showTargetLabel{
    [TestFlight passCheckpoint:@"Showing_Target_Label"];
//    [self removeChildByTag:kTAGtargetLabel cleanup:YES];
    [self removeChildByTag:kTAGtargetSprite cleanup:YES];
    CGSize size = [[CCDirector sharedDirector] winSize];
    CCSprite *HUDSprite=(CCSprite *)[self getChildByTag:kTAGHUD];
    
//    _timerLabel.position=ccp(statusBarSprite.boundingBox.origin.x + size.width*.15,statusBarSprite.boundingBox.origin.y + size.width*0.04);
    
//    float usableHUDHeight=(.35*HUDSprite.boundingBox.size.height);
    float usableHUDHeight=(.4*HUDSprite.boundingBox.size.height);
    float usableHUDWidth=(.86*HUDSprite.boundingBox.size.width);
    
    CharacterSprite *targetSpriteCopy;
#if HALLOWEEN
    targetSpriteCopy=[CharacterSprite spriteWithTexture:_targetCharacter.texture rect:_targetCharacter.textureRect];
#elif SMART
    if(_targetCharacter.isShape){
        targetSpriteCopy=[CharacterSprite spriteWithTexture:_targetCharacter.texture rect:_targetCharacter.textureRect];
//        targetSpriteCopy.color=_targetCharacter.color;
        targetSpriteCopy.isShape=YES;
    }else{
        targetSpriteCopy=[[[CharacterSprite alloc] initWithString:_targetCharacter.characterString] autorelease];
        CCSprite *targetChild=(CCSprite *)[_targetCharacter.children objectAtIndex:0];
        targetSpriteCopy.color=targetChild.color;
    }
#endif
    
    
//    [targetSpriteCopy setScale:.25];
    if(!_targetCharacter.isShape){
        if (UI_USER_INTERFACE_IDIOM() != UIUserInterfaceIdiomPad) { 
            float scale = MAX(targetSpriteCopy.boundingBox.size.height/usableHUDHeight, targetSpriteCopy.boundingBox.size.width/usableHUDWidth);
              [targetSpriteCopy setScale:1/scale * 1.4];  
        }else{ 
            float scale = MAX([targetSpriteCopy boundingBox].size.height/usableHUDHeight, [targetSpriteCopy boundingBox].size.width/usableHUDWidth);
            [targetSpriteCopy setScale:1/scale * 1.4];
        }
    }else{
        if (UI_USER_INTERFACE_IDIOM() != UIUserInterfaceIdiomPad) { 
            CCLOG(@"HEIGHT RATIO: %f",targetSpriteCopy.boundingBox.size.height/usableHUDHeight);
            CCLOG(@"WIDTH RATIO: %f",targetSpriteCopy.boundingBox.size.width/usableHUDWidth);
            float scale = MAX(targetSpriteCopy.boundingBox.size.height/usableHUDHeight, targetSpriteCopy.boundingBox.size.width/usableHUDWidth);
            [targetSpriteCopy setScale:1.0f/scale];  
            CCLOG(@"SCALE: %f", targetSpriteCopy.scale);
        }else{ 
            float scale = MAX([targetSpriteCopy boundingBox].size.height/usableHUDHeight, [targetSpriteCopy boundingBox].size.width/usableHUDWidth);
            [targetSpriteCopy setScale:1.0/scale ];
        }        
    }
    targetSpriteCopy.anchorPoint=ccp(0.5,0);
    if(_targetCharacter.isShape){
        targetSpriteCopy.position=ccp(HUDSprite.boundingBox.origin.x + HUDSprite.boundingBox.size.width/2, HUDSprite.boundingBox.origin.y + size.height*0.1);
    }else{
        targetSpriteCopy.position=ccp(HUDSprite.boundingBox.origin.x + HUDSprite.boundingBox.size.width/2, HUDSprite.boundingBox.origin.y + HUDSprite.boundingBox.size.height/1.75);
    }
    targetSpriteCopy.color=_targetCharacter.color;
    [self addChild:targetSpriteCopy z:5 tag:kTAGtargetSprite];
//    NSLog(@"Target Bounding Box: %f, %f, %f, %f", [targetSpriteCopy boundingBox].origin.x, [targetSpriteCopy boundingBox].origin.y, [targetSpriteCopy boundingBox].size.width,[targetSpriteCopy boundingBox].size.height);
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
    if(![self getChildByTag:kTAGtargetSprite])
        [self showTargetLabel];
    gameTimer+=dt;
    _timerLabel.string=[NSString stringWithFormat:@"%i", (int)gameTimer];
//    if(gameTimer>2)
//        [self gameOver];
}

- (void)registerWithTouchDispatcher {
    [[CCTouchDispatcher sharedDispatcher] addTargetedDelegate:self 
                                                     priority:0 swallowsTouches:YES];
}

-(CGRect) getBoundingRectForNode:(CCNode *)selectedNode;
{
    CCNode *parentNode=[selectedNode parent];
    CGPoint newOrigin=[parentNode convertToWorldSpace:selectedNode.position];
	CGSize size = [selectedNode contentSize];
	size.width *= selectedNode.scaleX;
	size.height *= selectedNode.scaleY;
	return CGRectMake(newOrigin.x - size.width * selectedNode.anchorPoint.x, 
					  newOrigin.y - size.height * selectedNode.anchorPoint.y, 
					  size.width, size.height);
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
    float cocosAngle = -1 * (angleDegrees+50);

    if(cocosAngle>=-25.0 && cocosAngle<=25.0){
        _henryHead.rotation=cocosAngle;
//        CCLOG(@"Rotating TO: %f", cocosAngle);
    }
        
    
    [_headLampLight setVisible:YES];
    [[self getChildByTag:kTAGnight] setVisible:NO];
    
    [self removeChildByTag:kTAGfireWorks cleanup:YES];
    
#ifdef SMART
    CCNode *node;
    CCARRAY_FOREACH([_targetCharacter children], node)
    {
        if (CGRectContainsPoint([node boundingBox], location))
        {
            CCLOG(@"Contains Point!");
            [self signalWin];
        }
    }
#elif HALLOWEEN
    if(CGRectContainsPoint([_targetCharacter boundingBox], location)){
        CCLOG(@"Contains Point!");
        [self signalWin];
    }
#endif

    
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
    float cocosAngle = -1 * (angleDegrees+50);
    
    if(cocosAngle>=-25.0  && cocosAngle<=25.0){
//        CCLOG(@"Rotating TO: %f", cocosAngle);
        _henryHead.rotation=cocosAngle;
    }


    
//    location=[self convertTouchToNodeSpace:touch];
//#ifdef SMART
//    CCNode *node;
//    CCARRAY_FOREACH([_targetCharacter children], node)
//    {
////        NSLog(@"BOUNDING BOX: %f,%f %fx%f",[node boundingBox].origin.x,[node boundingBox].origin.y,[node boundingBox].size.width,[node boundingBox].size.height);
////        CGRect newBoundingBox=[self getBoundingRectForNode:node];
//        CGRect newBoundingBox=[_targetCharacter getChildRect];
//        NSLog(@"BOUNDING BOX: %f,%f %fx%f",newBoundingBox.origin.x,newBoundingBox.origin.y,newBoundingBox.size.width,newBoundingBox.size.height);
//        CCLOG(@"TOUCH LOCATION: %f,%f", location.x,location.y);
//        if (CGRectContainsPoint(newBoundingBox, location))
//        {
//            NSLog(@"Contains Point!");
//            [self signalWin];
//        }
//    }
//#elif HALLOWEEN
    if(CGRectContainsPoint([_targetCharacter boundingBox], location)){
        CCLOG(@"Contains Point!");
        [self signalWin];
    }
//#endif
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
