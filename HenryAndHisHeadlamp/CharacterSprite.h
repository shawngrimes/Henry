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
#else
typedef enum {
    kCharacterTypeOval=1,
    kCharacterTypeSquare,
    kCharacterTypeTriangle,
    kCharacterTypeCircle,
    kCharacterTypeMAX
} CharacterType;
#endif

typedef enum {
    kCharacterColorRed=1,
    kCharacterColorGreen,
    kCharacterColorBlue,
    kCharacterColorMAX
} CharacterColor;

@interface CharacterSprite : CCSprite {
    NSString *_description;
    BOOL _isTarget;
}

@property (nonatomic, retain) NSString *description;
@property (nonatomic) BOOL isTarget;

+(CharacterSprite *) characterOfType:(int)typeOfCharacter;
+(CharacterSprite *) characterOfType:(CharacterType)typeOfCharacter withColor:(CharacterColor)colorOfCharacter;
-(void)setRandomPosition:(CGSize) playableArea;

-(void)setRandomPosition:(CGSize) playableArea checkOtherSprites:(NSArray *) aryOtherSprites;

@end
