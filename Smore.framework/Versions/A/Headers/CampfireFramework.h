//
//  CampfireFramework.h
//  CampfireFramework
//
//  Created by Shawn Grimes on 10/10/11.
//  Copyright (c) 2011 Shawn's Bits, LLC. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>
//#import "CFChildObject.h"

@class CFChildObject;
@class CFParentObject;

@interface CampfireFramework : NSObject{
    NSMutableArray *_sessions;
}

@property (retain, nonatomic) CFChildObject *childPlayer;
@property (readonly, nonatomic) CFParentObject *parentObject;
@property (retain, nonatomic) NSArray *children;

@property (readonly, retain, nonatomic) NSManagedObjectContext *managedObjectContext;
@property (readonly, retain, nonatomic) NSManagedObjectModel *managedObjectModel;
@property (readonly, retain, nonatomic) NSPersistentStoreCoordinator *persistentStoreCoordinator;


+(CampfireFramework *)sharedManager;

- (void)saveContext;
- (NSURL *)applicationDocumentsDirectory;
-(void)loadChildrenOnline;

-(void)showLogin;
-(CFParentObject *)getParent;
-(void)startActivty:(NSString *) activity ForChild:(CFChildObject *)child;
-(void)stopActiveSessions;
-(void)addChildWithIconNumber:(NSNumber *)iconNumber;
-(void)removeAllChildren;

-(BOOL) isReachable;

@end
