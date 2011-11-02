//
//  AppDelegate.h
//  HenryAndHisHeadlamp
//
//  Created by Shawn Grimes on 10/17/11.
//  Copyright Shawn's Bits, LLC. 2011. All rights reserved.
//

#import <UIKit/UIKit.h>

@class RootViewController;

@interface AppDelegate : NSObject <UIApplicationDelegate> {
	UIWindow			*window;
	RootViewController	*viewController;
}

@property (nonatomic, retain) UIWindow *window;

@end
