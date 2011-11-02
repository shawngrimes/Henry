//
//  UserSelectionLayer.h
//  HenryAndHisHeadlamp
//
//  Created by Shawn Grimes on 10/20/11.
//  Copyright 2011 Shawn's Bits, LLC. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "cocos2d.h"

@class AppDelegate;
@class FlurryAnalytics;

typedef enum {
    kTAGuserSelectionMenu=70,
} UserSelectionSceneTags; 

@interface UserSelectionLayer : CCLayer {
    CCSpriteBatchNode *batchNode;
    
}
+(CCScene *) scene;

@end
