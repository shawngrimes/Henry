//
//  StartUpScreenLayer.m
//  HenryAndHisHeadlamp
//
//  Created by Shawn Grimes on 9/29/11.
//  Copyright 2011 Shawn's Bits, LLC. All rights reserved.
//

#import "StartUpScreenLayer.h"
#import "GB2ShapeCache.h"
#import "PrizeSelectionScene.h"
#import "SimpleAudioEngine.h"
#import "UserSelectionLayer.h"
//#import "GLES-Render.h"
#import "Box2DHelper.h"

enum {
	kTagBatchNode = 1,
};

@implementation StartUpScreenLayer

#define PTM 32.0

-(float) pixelsToMeterRatio
{
    if(UI_USER_INTERFACE_IDIOM()==UIUserInterfaceIdiomPad){
        return 32.0f;
    }else{
        return (CC_CONTENT_SCALE_FACTOR() * 16.0f);
//        return 16.0f;
    }
}

-(float) pixelsToMeterMouse{
    if(UI_USER_INTERFACE_IDIOM()==UIUserInterfaceIdiomPad){
        return 32.0f;
    }else{
        return 16.0f;
//        return (CC_CONTENT_SCALE_FACTOR() * 16.0f);
        //        return 16.0f;
    }
}

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
        self.isAccelerometerEnabled = YES;
        [CCTexture2D PVRImagesHavePremultipliedAlpha:YES];
        
        [[SimpleAudioEngine sharedEngine] playBackgroundMusic:@"backgroundMusic.aifc" loop:YES];
        [[SimpleAudioEngine sharedEngine] preloadEffect:@"Speech1.aifc"];
        [[SimpleAudioEngine sharedEngine] preloadEffect:@"Speech2.aifc"];
        
        CGSize size = [[CCDirector sharedDirector] winSize];
        CCSprite *backgroundSprite;
#ifdef HALLOWEEN
        //Stuff for Lite version
        [[CCSpriteFrameCache sharedSpriteFrameCache] addSpriteFramesWithFile:@"buttonsAndResources-Halloween.plist"];
        backgroundSprite=[CCSprite spriteWithFile:@"Henry_Spooky_Title_Screen.png"];
        if (UI_USER_INTERFACE_IDIOM() != UIUserInterfaceIdiomPad) { 
            [backgroundSprite setScaleX:size.width/1024.0f];
            [backgroundSprite setScaleY:size.height/768.0f];
        }
#elif WINTER
        if(UI_USER_INTERFACE_IDIOM()==UIUserInterfaceIdiomPad){
            [[CCSpriteFrameCache sharedSpriteFrameCache] addSpriteFramesWithFile:@"Buttons-hd.plist"];
            backgroundSprite=[CCSprite spriteWithFile:@"TitleScreen-ipad.png"];
        }else{
            [[CCSpriteFrameCache sharedSpriteFrameCache] addSpriteFramesWithFile:@"Buttons.plist"];
            backgroundSprite=[CCSprite spriteWithFile:@"TitleScreen.png"];
        }
        if(UI_USER_INTERFACE_IDIOM()==UIUserInterfaceIdiomPad){
            batchNode = [CCSpriteBatchNode batchNodeWithFile:@"Snowflake-hd.png"];
        }else{
            batchNode = [CCSpriteBatchNode batchNodeWithFile:@"Snowflake.png"];
        }
//        batchNode=[CCSpriteBatchNode batchNodeWithFile:@"Snowflake.png"];
        [self addChild:batchNode z:3 tag:kTagBatchNode];
        [[GB2ShapeCache sharedShapeCache]  
         addShapesWithFile:@"SnowflakePhysics.plist"];
        
        CGSize winSize = [[CCDirector sharedDirector] winSizeInPixels];
        // Create a world
        b2Vec2 gravity = b2Vec2(0.0f, -30.0f);
        bool doSleep = true;
        _world = new b2World(gravity, doSleep);
        
//        GLESDebugDraw *m_debugDraw = new GLESDebugDraw( [self pixelsToMeterRatio] );
//		_world->SetDebugDraw(m_debugDraw);
//		
//		uint32 flags = 0;
//		flags += b2DebugDraw::e_shapeBit;
//        		flags += b2DebugDraw::e_jointBit;
//        //		flags += b2DebugDraw::e_aabbBit;
//        //		flags += b2DebugDraw::e_pairBit;
//        		flags += b2DebugDraw::e_centerOfMassBit;
//		m_debugDraw->SetFlags(flags);		
        
        // Create edges around the entire screen
        b2BodyDef groundBodyDef;
        groundBodyDef.position.Set(0,0);
        _groundBody = _world->CreateBody(&groundBodyDef);
        b2PolygonShape groundBox;
        b2FixtureDef boxShapeDef;
        boxShapeDef.shape = &groundBox;
        groundBox.SetAsEdge(b2Vec2(0,0), 
                            b2Vec2(winSize.width/[self pixelsToMeterRatio], 0));
        _groundBody->CreateFixture(&boxShapeDef);
        groundBox.SetAsEdge(b2Vec2(0,0), 
                            b2Vec2(0, winSize.height/[self pixelsToMeterRatio]));
        _groundBody->CreateFixture(&boxShapeDef);
        groundBox.SetAsEdge(b2Vec2(0, winSize.height/[self pixelsToMeterRatio]), 
                            b2Vec2(winSize.width/[self pixelsToMeterRatio], 
                                   winSize.height/[self pixelsToMeterRatio]));
        _groundBody->CreateFixture(&boxShapeDef);
        groundBox.SetAsEdge(b2Vec2(winSize.width/[self pixelsToMeterRatio], 
                                   winSize.height/[self pixelsToMeterRatio]), 
                            b2Vec2(winSize.width/[self pixelsToMeterRatio], 0));
        _groundBody->CreateFixture(&boxShapeDef);
        CGPoint bodyStart=ccp(winSize.width * .5, 0);
        for (int x=1; x<10; x++) {
            CCSprite *sprite;
            if(UI_USER_INTERFACE_IDIOM()==UIUserInterfaceIdiomPad){
                sprite = [CCSprite spriteWithFile:@"Snowflake-hd.png"];
            }else{
                sprite = [CCSprite spriteWithFile:@"Snowflake.png"];
            }
            [batchNode addChild:sprite];
            int randomHeight=arc4random() % 200;
            bodyStart=ccp(winSize.width * .1 * x, size.height-(sprite.contentSize.height + 10 + randomHeight));

            b2BodyDef bodyDef;
            bodyDef.type = b2_dynamicBody;
            //            b2Vec2 bodyStartPixels=[Box2DHelper toMeters:bodyStart];
            bodyDef.position.Set(bodyStart.x/[self pixelsToMeterRatio], bodyStart.y/[self pixelsToMeterRatio]);
            bodyDef.userData = sprite;
            b2Body *body = _world->CreateBody(&bodyDef);
            [[GB2ShapeCache sharedShapeCache] addFixturesToBody:body forShapeName:@"Snowflake"];
            
            [sprite setAnchorPoint:[[GB2ShapeCache sharedShapeCache] anchorPointForShape:@"Snowflake"]];
            
        }
        [self schedule:@selector(tick:)];

        

#elif SMART
        //Stuff for Full version
        [[CCSpriteFrameCache sharedSpriteFrameCache] addSpriteFramesWithFile:@"buttonsAndResources-Smart.plist"];
         buttonBatchNode=[CCSpriteBatchNode batchNodeWithFile:@"buttonsAndResources-Smart.pvr.ccz"];
        
        if(UI_USER_INTERFACE_IDIOM()!=UIUserInterfaceIdiomPad){
            [[CCSpriteFrameCache sharedSpriteFrameCache] addSpriteFramesWithFile:@"TitleScreenObjects.plist"];
             batchNode = [CCSpriteBatchNode batchNodeWithFile:@"TitleScreenObjects.png"];
            
        }else{
            [[CCSpriteFrameCache sharedSpriteFrameCache] addSpriteFramesWithFile:@"TitleScreenObjects-hd.plist"];
             batchNode = [CCSpriteBatchNode batchNodeWithFile:@"TitleScreenObjects-hd.png"];
//            buttonBatchNode=[CCSpriteBatchNode batchNodeWithFile:@"ButtonTextures-hd.pvr.gz"];
        }
        [self addChild:batchNode z:3 tag:kTagBatchNode];
    
        
        [[GB2ShapeCache sharedShapeCache]  
         addShapesWithFile:@"TitleScreenPhysics.plist"];
		
		CGSize winSize = [[CCDirector sharedDirector] winSizeInPixels];
        // Create a world
        b2Vec2 gravity = b2Vec2(0.0f, -30.0f);
        bool doSleep = true;
        _world = new b2World(gravity, doSleep);
        
//        GLESDebugDraw *m_debugDraw = new GLESDebugDraw( [self pixelsToMeterRatio] );
//		_world->SetDebugDraw(m_debugDraw);
//		
//		uint32 flags = 0;
//		flags += b2DebugDraw::e_shapeBit;
//        		flags += b2DebugDraw::e_jointBit;
//        //		flags += b2DebugDraw::e_aabbBit;
//        //		flags += b2DebugDraw::e_pairBit;
//        		flags += b2DebugDraw::e_centerOfMassBit;
//		m_debugDraw->SetFlags(flags);		
        
        // Create edges around the entire screen
        b2BodyDef groundBodyDef;
        groundBodyDef.position.Set(0,0);
        _groundBody = _world->CreateBody(&groundBodyDef);
        b2PolygonShape groundBox;
        b2FixtureDef boxShapeDef;
        boxShapeDef.shape = &groundBox;
        groundBox.SetAsEdge(b2Vec2(0,0), 
                            b2Vec2(winSize.width/[self pixelsToMeterRatio], 0));
        _groundBody->CreateFixture(&boxShapeDef);
        groundBox.SetAsEdge(b2Vec2(0,0), 
                            b2Vec2(0, winSize.height/[self pixelsToMeterRatio]));
        _groundBody->CreateFixture(&boxShapeDef);
        groundBox.SetAsEdge(b2Vec2(0, winSize.height/[self pixelsToMeterRatio]), 
                            b2Vec2(winSize.width/[self pixelsToMeterRatio], 
                                   winSize.height/[self pixelsToMeterRatio]));
        _groundBody->CreateFixture(&boxShapeDef);
        groundBox.SetAsEdge(b2Vec2(winSize.width/[self pixelsToMeterRatio], 
                                   winSize.height/[self pixelsToMeterRatio]), 
                            b2Vec2(winSize.width/[self pixelsToMeterRatio], 0));
        _groundBody->CreateFixture(&boxShapeDef);

//        groundBox.SetAsEdge(b2Vec2(0,0), 
//                            b2Vec2(winSize.width, 0));
//        _groundBody->CreateFixture(&boxShapeDef);
//        groundBox.SetAsEdge(b2Vec2(0,0), 
//                            b2Vec2(0, winSize.height));
//        _groundBody->CreateFixture(&boxShapeDef);
//        groundBox.SetAsEdge(b2Vec2(0, winSize.height), 
//                            b2Vec2(winSize.width, winSize.height));
//        _groundBody->CreateFixture(&boxShapeDef);
//        groundBox.SetAsEdge(b2Vec2(winSize.width, 
//                                   winSize.height), b2Vec2(winSize.width, 0));
//        _groundBody->CreateFixture(&boxShapeDef);

        
        for(int x=1;x<=9;x++){
            NSString *name=[NSString stringWithFormat:@"%i",x];
            CCSprite *sprite = [CCSprite spriteWithSpriteFrameName:[NSString stringWithFormat:@"%i.png",x]];
            [batchNode addChild:sprite];
        
            
        
            // set position
            CGPoint bodyStart=ccp(winSize.width * .75, 0);
            switch (x) {
                case 1:
                    bodyStart=ccp(winSize.width * 952/1024, winSize.height * 220/768);
                    break;
                case 2:
                    bodyStart=ccp(winSize.width * 892/1024,winSize.height * 220/768);
                    break;
                case 3:
                    bodyStart=ccp(winSize.width * 889/1024,winSize.height * 345/768);
                    break;
                case 4:
                    bodyStart=ccp(winSize.width * 955/1024,winSize.height * 70/768);
                    break;
                case 5:
                    bodyStart=ccp(winSize.width * 889/1024,winSize.height * 70/768);
                    break;
                case 6:
                    bodyStart=ccp(winSize.width * 839/1024,winSize.height * 80/768);
                    break;
                case 7:
                    bodyStart=ccp(winSize.width * 840/1024,winSize.height * 220/768);
                    break;
                case 8:
                    bodyStart=ccp(winSize.width * 834/1024,winSize.height * 345/768);
                    break;
                case 9:
                    bodyStart=ccp(winSize.width * 954/1024,winSize.height * 345/768);
                    break;

                default:
                    break;
            }
                       
            b2BodyDef bodyDef;
            bodyDef.type = b2_dynamicBody;
//            b2Vec2 bodyStartPixels=[Box2DHelper toMeters:bodyStart];
            bodyDef.position.Set(bodyStart.x/[self pixelsToMeterRatio], bodyStart.y/[self pixelsToMeterRatio]);
            bodyDef.userData = sprite;
            b2Body *body = _world->CreateBody(&bodyDef);
            [[GB2ShapeCache sharedShapeCache] addFixturesToBody:body forShapeName:name];

            [sprite setAnchorPoint:[[GB2ShapeCache sharedShapeCache] anchorPointForShape:name]];
            
        }
        [self schedule:@selector(tick:)];
        
//        [self scheduleUpdate];       
        
        backgroundSprite=[CCSprite spriteWithFile:@"TitleScreen.png"];
//        CCLOG(@"BackgroundSprite: %@", backgroundSprite.)
        
#endif
        
        
        backgroundSprite.position=ccp(size.width/2, size.height/2);
        [self addChild:backgroundSprite z:-1];
        
    
//        [[CCSpriteFrameCache sharedSpriteFrameCache] addSpriteFramesWithFile:@"buttonsAndResources-Halloween.plist"];
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
//        if (UI_USER_INTERFACE_IDIOM() != UIUserInterfaceIdiomPad) {
//            [playSprite setScale:(size.width/1024.0f)];
////            [playSprite setScaleY:(size.width/768.0f)];
//            
//            [aboutSprite setScale:(size.width/1024.0f)];
////            [aboutSprite setScaleY:(size.width/768.0f)];
//        }

        [mainMenu alignItemsVerticallyWithPadding:0.08*size.height];
//        aboutSprite.position=ccp(.0195*size.width, aboutSprite.position.y);
        
        mainMenu.position=ccp(size.width *.5, size.height/3);

        [self addChild:mainMenu z:8];
//        CCLOG(@"Winsize %fx%f", winSize.width, winSize.height);
//        CCLOG(@"Content Scale Facter: %f",CC_CONTENT_SCALE_FACTOR());
//        CCLOG(@"PTM: %f", [self pixelsToMeterRatio]);

    }
        [TestFlight passCheckpoint:@"RETURNING_SPLASH"];
    
	return self;
    
}

-(void) tick: (ccTime) dt
{
    int32 velocityIterations = 8;
    int32 positionIterations = 1;   
    _world->Step(dt, velocityIterations, positionIterations);
    
    for (b2Body* b = _world->GetBodyList(); b; b = b->GetNext())
    {
        if (b->GetUserData() != NULL) 
        {
            CCSprite *myActor = (CCSprite*)b->GetUserData();
            if(UI_USER_INTERFACE_IDIOM()==UIUserInterfaceIdiomPad){
                myActor.position = ccp(b->GetPosition().x * 32, b->GetPosition().y * 32);
            }else{
                myActor.position = ccp(b->GetPosition().x * 16, b->GetPosition().y * 16);
            }

            myActor.rotation = -1 * CC_RADIANS_TO_DEGREES(b->GetAngle());
        }   
    }
}

- (void)accelerometer:(UIAccelerometer *)accelerometer didAccelerate:(UIAcceleration *)acceleration {
    
    UIDeviceOrientation orientation = [[UIDevice currentDevice] orientation];
	ccDeviceOrientation cor = (ccDeviceOrientation)orientation;
    
	if( cor == UIDeviceOrientationLandscapeLeft)
	{
		b2Vec2 gravity(-acceleration.y * 15, acceleration.x *15);
        _world->SetGravity(gravity);
	}
	else if ( cor == UIDeviceOrientationLandscapeRight )
	{
		b2Vec2 gravity(acceleration.y * 15, -acceleration.x *15);
        _world->SetGravity(gravity);
	}
    
}

-(void) transitionToGamePlay{
    [TestFlight passCheckpoint:@"LOADING_USER_SELECTION_SCENE"];
    [[CCDirector sharedDirector] replaceScene:
     [CCTransitionSlideInR transitionWithDuration:1.0f scene:[UserSelectionLayer scene]]];

//    CCScene *scoreScene=[CCScene node];
//    PrizeSelectionScene *prizeLayer=[[[PrizeSelectionScene alloc] initWithTime:30] autorelease];
//    //    [prizeLayer withTime:gameTimer];
//    [scoreScene addChild:prizeLayer];
    

//    [self loadGameLayer];
    
//    [self schedule:@selector(loadGameLayer) interval:0.5];
}

-(void) loadGameLayer{
    [[CCDirector sharedDirector] replaceScene:
     [CCTransitionSlideInR transitionWithDuration:1.0f scene:[StoryLevel scene]]];
//    CCScene *scoreScene=[CCScene node];
//    PrizeSelectionScene *prizeLayer=[[[PrizeSelectionScene alloc] initWithTime:30] autorelease];
//    [scoreScene addChild:prizeLayer];
//    
//    [[CCDirector sharedDirector] replaceScene:
//     [CCTransitionRotoZoom transitionWithDuration:2.0f scene:scoreScene]];


}

-(void) transitionToAboutPage{
    [TestFlight passCheckpoint:@"LOADING_ABOUT_SCENE"];
    [[CCDirector sharedDirector] replaceScene:
     [CCTransitionSlideInR transitionWithDuration:1.0f scene:[AboutUsLayer scene]]];
}


- (void) dealloc
{
    delete _world;
    delete _mouseJoint;
    _mouseJoint=NULL;
    _groundBody = NULL;
    _world = NULL;
    [[CCTextureCache sharedTextureCache] removeAllTextures];
    [super dealloc];
}

-(void) onEnter
{
	[super onEnter];
	
	[[UIAccelerometer sharedAccelerometer] setUpdateInterval:(1.0 / 60)];
}

- (void)ccTouchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
    
    if (_mouseJoint != NULL) return;
    
    UITouch *myTouch = [touches anyObject];
    CGPoint location = [myTouch locationInView:[myTouch view]];
    location = [[CCDirector sharedDirector] convertToGL:location];
//    b2Vec2 locationWorld = b2Vec2(location.x/[self pixelsToMeterRatio], location.y/[self pixelsToMeterRatio]);
    b2Vec2 locationWorld = b2Vec2(location.x/[self pixelsToMeterMouse], location.y/[self pixelsToMeterMouse]);
    for(b2Body *b = _world->GetBodyList(); b; b=b->GetNext()) {    
        for(b2Fixture *f = b->GetFixtureList(); f; f=f->GetNext()){
            if(f->TestPoint(locationWorld)){
                b2MouseJointDef md;
                md.bodyA = _groundBody;
                md.bodyB = b;
                md.target = locationWorld;
                md.collideConnected = true;
                md.maxForce = 1000.0f * b->GetMass();
                
                _mouseJoint = (b2MouseJoint *)_world->CreateJoint(&md);
                b->SetAwake(true);
            }
        }
            
    }
}
-(void)ccTouchesMoved:(NSSet *)touches withEvent:(UIEvent *)event {
    
    if (_mouseJoint == NULL) return;
    
    UITouch *myTouch = [touches anyObject];
    CGPoint location = [myTouch locationInView:[myTouch view]];
    location = [[CCDirector sharedDirector] convertToGL:location];
//    b2Vec2 locationWorld = b2Vec2(location.x/[self pixelsToMeterRatio], location.y/[self pixelsToMeterRatio]);
    b2Vec2 locationWorld = b2Vec2(location.x/[self pixelsToMeterMouse], location.y/[self pixelsToMeterMouse]);
    
    _mouseJoint->SetTarget(locationWorld);
    
}

-(void)ccTouchesCancelled:(NSSet *)touches withEvent:(UIEvent *)event {
    
    if (_mouseJoint) {
        _world->DestroyJoint(_mouseJoint);
        _mouseJoint = NULL;
    }
    
}

- (void)ccTouchesEnded:(NSSet *)touches withEvent:(UIEvent *)event {
    if (_mouseJoint) {
        _world->DestroyJoint(_mouseJoint);
        _mouseJoint = NULL;
    }  
}

//-(void) draw
//{
//	// Default GL states: GL_TEXTURE_2D, GL_VERTEX_ARRAY, GL_COLOR_ARRAY, GL_TEXTURE_COORD_ARRAY
//	// Needed states:  GL_VERTEX_ARRAY, 
//	// Unneeded states: GL_TEXTURE_2D, GL_COLOR_ARRAY, GL_TEXTURE_COORD_ARRAY
//	glDisable(GL_TEXTURE_2D);
//	glDisableClientState(GL_COLOR_ARRAY);
//	glDisableClientState(GL_TEXTURE_COORD_ARRAY);
//	
//	_world->DrawDebugData();
//	
//	// restore default GL states
//	glEnable(GL_TEXTURE_2D);
//	glEnableClientState(GL_COLOR_ARRAY);
//	glEnableClientState(GL_TEXTURE_COORD_ARRAY);
//    
//}

@end
