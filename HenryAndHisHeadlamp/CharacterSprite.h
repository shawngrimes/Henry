//
//  CharacterSprite.h
//  HenryAndHisHeadlamp
//
//  Created by Shawn Grimes on 9/8/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "cocos2d.h"

#ifdef HALLOWEEN
typedef enum {
    kCharacterTypeApple=1,
    kCharacterTypeBat,
    kCharacterTypeBone,
    kCharacterTypeBroom,
    kCharacterTypeCandle,
    kCharacterTypeCandyCorn,
    kCharacterTypeGreenCandy,
    kCharacterTypeOrangeCandy,
    kCharacterTypeWitchHat,
    kCharacterTypeMAX
} CharacterType;
#elif SMART
typedef enum {
    kCharacterTypeNone=0,
    kCharacterTypeStar,
    kCharacterTypeHexagon,
    kCharacterTypeTrapezoid,
    kCharacterTypeRhombus,
    kCharacterTypeOval,
    kCharacterTypeCircle,
    kCharacterTypeSquare,
    kCharacterTypeTriangle,
    kCharacterTypeRectangle,
    kCharacterTypeMAX
} CharacterType;
#endif

typedef enum {
    kCharacterColorYellow=1,
    kCharacterColorOrange,
    kCharacterColorRed,
    kCharacterColorGreen,
    kCharacterColorBlue,
    kCharacterColorPurple,
    kCharacterColorPink,
    kCharacterColorMAX
} CharacterColor;

@interface CharacterSprite : CCSprite {
    NSString *_description;
    BOOL _isTarget;
    BOOL _isShape;
}

@property (nonatomic, retain) NSString *characterString;
@property (nonatomic, retain) NSString *description;
@property (nonatomic) BOOL isTarget;
@property (nonatomic) BOOL isShape;

+(CharacterSprite *) characterOfType:(int)typeOfCharacter;
+(CharacterSprite *) characterOfType:(int)typeOfCharacter withColor:(int)colorOfCharacter;
-(void)setRandomPosition:(CGSize) playableArea;

-(void)setRandomPosition:(CGSize) playableArea checkOtherSprites:(NSArray *) aryOtherSprites;

-(id) initWithString:(NSString *)characterString;

-(CGRect) getChildRect;
-(CGRect) getBoundingRectForNode:(CCNode *)selectedNode;
- (BOOL)isEqual:(id)anObject;

@end
