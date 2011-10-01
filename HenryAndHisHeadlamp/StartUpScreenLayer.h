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
#import "GameLayer.h"
#import "AboutUsLayer.h"
#import "StoryLevel.h"

@interface StartUpScreenLayer : CCLayer {
    float gameTimer;
}
+(CCScene *) scene;
-(void) transitionToGamePlay;
-(void) transitionToAboutPage;
@end
