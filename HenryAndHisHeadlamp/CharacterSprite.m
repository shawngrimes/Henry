//
//  CharacterSprite.m
//  HenryAndHisHeadlamp
//
//  Created by Shawn Grimes on 9/8/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "CharacterSprite.h"


@implementation CharacterSprite
@synthesize description=_description;
@synthesize isTarget=_isTarget;

-(id) initWithSpriteFrameName:(NSString *)spriteFrameName{
    
    CCSpriteFrameCache *frameCache=[CCSpriteFrameCache sharedSpriteFrameCache];
#ifdef HALLOWEEN
    [frameCache addSpriteFramesWithFile:@"halloweenSpritesFile.plist"];
#else
    [frameCache addSpriteFramesWithFile:@"characterTextures.plist"];
#endif
    
    NSLog(@"FrameName: %@", spriteFrameName);
    
    if((self=[super initWithSpriteFrameName:spriteFrameName]))
    {
    }
    
    return self;
}

+(CharacterSprite *) characterOfType:(int)typeOfCharacter{
//    NSString *frameName;
    
    CharacterSprite *newCharacter=[[[CharacterSprite alloc] initWithSpriteFrameName:[NSString stringWithFormat:@"%i.png",typeOfCharacter]] autorelease];
//    newCharacter.color=spriteColor;
//    newCharacter.description=[NSString stringWithFormat:@"%@", frameName];
    
    if (UI_USER_INTERFACE_IDIOM() != UIUserInterfaceIdiomPad) { 
        CGSize size = [[CCDirector sharedDirector] winSize];
        [newCharacter setScaleX:size.width/1024.0f];
        [newCharacter setScaleY:size.height/768.0f];
    }
    return newCharacter;
}

+(CharacterSprite *) characterOfType:(CharacterType)typeOfCharacter withColor:(CharacterColor)colorOfCharacter{
    
    
    NSString *frameName;
    NSString *characterColor;
    ccColor3B spriteColor;
#ifdef HALLOWEEN
#else
    switch (typeOfCharacter) {
        case kCharacterTypeOval:
            frameName=@"oval";
            break;
        case kCharacterTypeSquare:
            frameName=@"square";
            break;
        case kCharacterTypeTriangle:
            frameName=@"triangle";
            break;
        case kCharacterTypeCircle:
            frameName=@"circle";
            break;
        default:
            return nil;
            break;
    }
#endif
    switch (colorOfCharacter) {
        case kCharacterColorRed:
            characterColor=@"RED";
            spriteColor=ccRED;
            break;
        case kCharacterColorBlue:
            characterColor=@"BLUE";
            spriteColor=ccBLUE;
            break;
        case kCharacterColorGreen:
            characterColor=@"GREEN";
            spriteColor=ccGREEN;
            break;
        default:
            break;
    }

    
    CharacterSprite *newCharacter=[[[CharacterSprite alloc] initWithSpriteFrameName:[NSString stringWithFormat:@"%@.png",frameName]] autorelease];
    newCharacter.color=spriteColor;
    newCharacter.description=[NSString stringWithFormat:@"%@ %@", characterColor, frameName];
    
    return newCharacter;
}

-(void)setRandomPosition:(CGSize) playableArea{
    CGSize size = [[CCDirector sharedDirector] winSize];
    
    playableArea.width-=self.boundingBox.size.width;
//    NSLog(@"playable Area Width: %f", playableArea.width);
    playableArea.height-=self.boundingBox.size.height;
//    NSLog(@"playable Area Height: %f", playableArea.height);    
    
    int xCoord=arc4random()%(int)playableArea.width;
    int yCoord=size.height-arc4random()%(int)playableArea.height;
    
//    while (xCoord<playableArea.width/1.5 && xCoord>playableArea.width/2.5) {
//        xCoord=playableArea.width-arc4random()%(int)playableArea.width;
//    }
    
    CGPoint newLocation=ccp((xCoord+self.boundingBox.size.width/2), (yCoord-self.boundingBox.size.height/2));
    self.position=newLocation;
    
//    NSLog(@"New Location: %f,%f", newLocation.x,newLocation.y);
//    if(self.position.x>0){
//        NSLog(@"New Location: %f,%f", newLocation.x,newLocation.y);
//        NSLog(@"Position: %f,%f", self.position.x,self.position.y);  
////        [self stopAllActions];
////        [self runAction:[CCMoveTo actionWithDuration:1.0 position:newLocation]];  
//        self.position=newLocation;
//    }else{
//      self.position=newLocation;
//    }
//    [self runAction:[CCMoveTo actionWithDuration:1.0 position:newLocation]];
    
}

-(void)setRandomPosition:(CGSize) playableArea checkOtherSprites:(NSArray *) aryOtherSprites{
    [self setRandomPosition:playableArea];
    NSEnumerator *objectEnum=[aryOtherSprites objectEnumerator];
    CharacterSprite *checkSprite;
    while(checkSprite=[objectEnum nextObject]){
        if(self!=checkSprite){
            while (CGRectIntersectsRect(self.boundingBox, checkSprite.boundingBox)) {
//                CCLOG(@"Conflicts with: %@", checkSprite.description);
                 [self setRandomPosition:playableArea checkOtherSprites:aryOtherSprites];   
            }
        }
    }
}


@end
