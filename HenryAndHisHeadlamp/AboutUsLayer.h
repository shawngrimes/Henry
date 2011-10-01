//
//  AboutUsLayer.h
//  HenryAndHisHeadlamp
//
//  Created by Shawn Grimes on 9/29/11.
//  Copyright 2011 Shawn's Bits, LLC. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "cocos2d.h"
#import "TestFlight.h"
#import "FlurryAnalytics.h"
#import "StartUpScreenLayer.h"

@interface AboutUsLayer : CCLayer {
    
}
+(CCScene *) scene;

-(void)transitionToStartUpScreen;
-(void) transitionToRateApp;
-(void) transitionToMoreApps;

@end
