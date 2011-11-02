//
//  StartUpScreenLayer.h
//  HenryAndHisHeadlamp
//
//  Created by Shawn Grimes on 9/29/11.
//  Copyright 2011 Shawn's Bits, LLC. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "cocos2d.h"
#import "TestFlight.h"
//#import "GameLayer.h"
#import "AboutUsLayer.h"
#import "StoryLevel.h"

//#ifdef __cplusplus
#import "Box2D.h"
//#endif 

@interface StartUpScreenLayer : CCLayer {
    CCSpriteBatchNode *batchNode;
    CCSpriteBatchNode *buttonBatchNode;
    b2World *_world;
    b2Body *_groundBody;
    b2MouseJoint *_mouseJoint;
    
}
+(CCScene *) scene;
-(void) transitionToGamePlay;
-(void) transitionToAboutPage;
-(void) loadGameLayer;


@end
