//
//  Player.h
//  HenryAndHisHeadlamp
//
//  Created by Shawn Grimes on 11/1/11.
//  Copyright (c) 2011 Shawn's Bits, LLC. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class Prize;

@interface Player : NSManagedObject

@property (nonatomic, retain) NSNumber * iconNumber;
@property (nonatomic, retain) NSSet *prizes;
@end

@interface Player (CoreDataGeneratedAccessors)

- (void)addPrizesObject:(Prize *)value;
- (void)removePrizesObject:(Prize *)value;
- (void)addPrizes:(NSSet *)values;
- (void)removePrizes:(NSSet *)values;
@end
