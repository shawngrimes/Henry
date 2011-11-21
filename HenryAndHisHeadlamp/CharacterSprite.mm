//
//  CharacterSprite.m
//  HenryAndHisHeadlamp
//
//  Created by Shawn Grimes on 9/8/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "CharacterSprite.h"
#import "CCSpriteExtension.h"
#import "SimpleAudioEngine.h"
#import "CDAudioManager.h"

@implementation CharacterSprite
@synthesize description=_description;
@synthesize isTarget=_isTarget;
@synthesize isShape=_isShape;
@synthesize characterString;
@synthesize shapeColor;
@synthesize shape;
@synthesize originalScale;

- (BOOL)isEqual:(id)anObject{
    CharacterSprite *compareObject=(CharacterSprite *)anObject;
    if(self.isShape!=compareObject.isShape){
        return NO;
    }
//    CCLOG(@"Self is shape: %i", self.isShape);
//    CCLOG(@"CompareObject is shape: %i", self.isShape);
    if(!self.isShape){
//        CCLOG(@"Self is characterString: %@", self.characterString);
//        CCLOG(@"CompareObject is characterString: %@", self.characterString);
        if(![self.characterString isEqualToString:compareObject.characterString]){
            return NO;
        }else{
            return YES;
        }
    }
    
    if(self.color.r!=compareObject.color.r || self.color.g!=compareObject.color.g || self.color.b!=compareObject.color.b){
        return NO;
    }
    return YES;
}

-(NSString *)descriptorFile{
    unichar aChar=[self.characterString characterAtIndex:0];
    NSCharacterSet* theCaps = [NSCharacterSet uppercaseLetterCharacterSet];
    if([theCaps characterIsMember:aChar]){
        return @"Henry_Uppercase.caf";
    }
    
    NSCharacterSet *theLower=[NSCharacterSet lowercaseLetterCharacterSet];
    if([theLower characterIsMember:aChar]){
        return @"Henry_Lowercase.caf";
    }
    
    NSCharacterSet *theNumbers=[NSCharacterSet decimalDigitCharacterSet];
    if([theNumbers characterIsMember:aChar]){
        return @"Henry_Number.caf";
    }
    return @"";
}

-(NSString *)speakString{
    
    NSString *effectString=[NSString stringWithFormat:@"Henry_%@.caf",[self.characterString uppercaseString]];
    return effectString;
    
}

-(NSString *)speakColor{
    NSString *effectString=[NSString stringWithFormat:@"Henry_%@.caf",self.shapeColor];
    return effectString;
}

-(NSString *)speakShape{
    NSString *effectString=[NSString stringWithFormat:@"Henry_%@.caf",self.shape];
    return effectString;
}

-(id) initWithString:(NSString *)selectedCharacter{
    if(self=[super init]){
        
        CCLabelBMFont *characterLabel=[CCLabelBMFont labelWithString:selectedCharacter fntFile:@"SmartHenry.fnt"];
//        characterLabel.anchorPoint=CGPointZero;
        characterLabel.position=CGPointZero;
//        characterLabel.color=ccc3(118, 188, 241);
        [self addChild:characterLabel];
        CCLOG(@"Bounding Box: %f, %f, %f, %f", [characterLabel boundingBox].origin.x, [characterLabel boundingBox].origin.y, [characterLabel boundingBox].size.width,[characterLabel boundingBox].size.height);
        self.characterString=selectedCharacter;
        self.isShape=NO;
        if (UI_USER_INTERFACE_IDIOM() != UIUserInterfaceIdiomPad) { 
            CGSize size = [[CCDirector sharedDirector] winSizeInPixels];
            self.scale=size.width/1024.0f;
            self.originalScale=self.scale;
        }
        self.originalScale=self.scale;
    }
    return self;
}

-(id) initWithSpriteFrameName:(NSString *)spriteFrameName{
    
    CCSpriteFrameCache *frameCache=[CCSpriteFrameCache sharedSpriteFrameCache];
#ifdef HALLOWEEN
    [frameCache addSpriteFramesWithFile:@"halloweenSpritesFile.plist"];
#elif SMART
    if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad) { 
        [frameCache addSpriteFramesWithFile:@"ShapeTextures-hd.plist"];
    }else{
        [frameCache addSpriteFramesWithFile:@"ShapeTextures.plist"];
    }
#endif
    
    CCLOG(@"FrameName: %@", spriteFrameName);
    
    if((self=[super initWithSpriteFrameName:spriteFrameName]))
    {
        self.isShape=YES;

//        self.anchorPoint=ccp(0.5,0);
    }
    
    return self;
}

-(CGRect) getBoundingRectForNode:(CCNode *)selectedNode
{
    CCNode *parentNode=[selectedNode parent];
    CGPoint newOrigin=[parentNode convertToWorldSpace:selectedNode.position];
	CGSize size = [selectedNode contentSize];
	size.width *= selectedNode.scaleX;
	size.height *= selectedNode.scaleY;
	return CGRectMake(newOrigin.x - size.width * selectedNode.anchorPoint.x, 
					  newOrigin.y - size.height * selectedNode.anchorPoint.y, 
					  size.width, size.height);
}

-(CGRect) getChildRect{
    CCNode *node;
    CGRect totalBoundingRect;
    CCARRAY_FOREACH([self children], node)
    {
        totalBoundingRect=[self getBoundingRectForNode:node];
//        totalBoundingRect=[node boundingBox];
    }
//    CCLOG(@"totalBoundRect for Child: %f,%f %fx%f", totalBoundingRect.origin.x,totalBoundingRect.origin.y,totalBoundingRect.size.width,totalBoundingRect.size.height);
    return totalBoundingRect;
}

-(CGRect) boundingBox{
    if([self.children count]>0){
        CCLabelBMFont *labelBox=[self.children objectAtIndex:0];
//        CCNode *letter=[labelBox.children objectAtIndex:0];
        CGPoint newOrigin=[self convertToWorldSpace:labelBox.boundingBox.origin];
        CGSize letterSize=[labelBox contentSize];
        letterSize.width*=self.scaleX;
        letterSize.height*=self.scaleY;
        
        return CGRectMake(newOrigin.x, newOrigin.y, letterSize.width, letterSize.height);
    }else{
        CCLOG(@"Getting bounding rect");
        return [super boundingBox];
    }
}




+(CharacterSprite *) characterOfType:(int)typeOfCharacter{
//    NSString *frameName;
    
    CharacterSprite *newCharacter=[[[CharacterSprite alloc] initWithSpriteFrameName:[NSString stringWithFormat:@"%i.png",typeOfCharacter]] autorelease];
//    newCharacter.color=spriteColor;
//    newCharacter.description=[NSString stringWithFormat:@"%@", frameName];
    
    if (UI_USER_INTERFACE_IDIOM() != UIUserInterfaceIdiomPad) { 
        CGSize size = [[CCDirector sharedDirector] winSize];
        [newCharacter setScale:size.width/1024.0f];
        //        [newCharacter setScaleY:size.height/768.0f];
    }
    newCharacter.originalScale=newCharacter.scale;
    CCLOG(@"Original Scale in Sprite: %f", newCharacter.originalScale);
    
    return newCharacter;
}

+(CharacterSprite *) characterOfType:(int)typeOfCharacter withColor:(int)colorOfCharacter{
    
    
    NSString *shapeName;
    NSString *frameName;
    NSString *characterColor;
    ccColor3B spriteColor;
#ifdef HALLOWEEN
#elif SMART
    frameName=[NSString stringWithFormat:@"SmartHenry_Shape_%i.png",typeOfCharacter+1];
    switch (typeOfCharacter) {
        case kCharacterTypeCircle:
            shapeName=@"Circle";
            break;
        case kCharacterTypeHexagon:
            shapeName=@"Hexagon";
            break;
        case kCharacterTypeOval:
            shapeName=@"Oval";
            break;
        case kCharacterTypeRectangle:
            shapeName=@"Rectangle";
            break;
        case kCharacterTypeRhombus:
            shapeName=@"Rhombus";
            break;
        case kCharacterTypeSquare:
            shapeName=@"Square";
            break;
        case kCharacterTypeStar:
            shapeName=@"Star";
            break;
        case kCharacterTypeTrapezoid:
            shapeName=@"Trapezoid";
            break;
        case kCharacterTypeTriangle:
            shapeName=@"Triangle";
            break;

        default:
            break;
    }
    
    
#endif
    switch (colorOfCharacter) {
        case kCharacterColorYellow:
            characterColor=@"Yellow";
            spriteColor=ccc3(255, 234, 0);
            break;
        case kCharacterColorOrange:
            characterColor=@"Orange";
            spriteColor=ccc3(253, 114, 1);
            break;
        case kCharacterColorRed:
            characterColor=@"Red";
            spriteColor=ccc3(252, 1, 1);
            break;
        case kCharacterColorGreen:
            characterColor=@"Green";
            spriteColor=ccc3(67, 93, 4);
            break;
        case kCharacterColorBlue:
            characterColor=@"Blue";
            spriteColor=ccc3(11, 73, 117);
            break;
        case kCharacterColorPurple:
            characterColor=@"Purple";
            spriteColor=ccc3(87, 42, 110);
            break;
        case kCharacterColorPink:
            characterColor=@"Pink";
            spriteColor=ccc3(235, 49, 119);
            break;
        default:
            characterColor=[NSString stringWithFormat:@"Unknown Color: %i", colorOfCharacter];
            break;
    }

    
    CharacterSprite *newCharacter=[[[CharacterSprite alloc] initWithSpriteFrameName:[NSString stringWithFormat:@"%@",frameName]] autorelease];
    newCharacter.color=spriteColor;
    newCharacter.description=[NSString stringWithFormat:@"%@ %@", characterColor, shapeName];
    newCharacter.shapeColor=characterColor;
    newCharacter.shape=shapeName;    
    
    newCharacter.originalScale=newCharacter.scale;
    CCLOG(@"Original Scale in Sprite: %f", newCharacter.originalScale);
    
    return newCharacter;
}

-(void)setRandomPosition:(CGSize) playableArea{
    CGSize size = [[CCDirector sharedDirector] winSize];
    
    playableArea.width-=[self boundingBox].size.width;
//    NSLog(@"playable Area Width: %f", playableArea.width);
    playableArea.height-=[self boundingBox].size.height;
//    NSLog(@"playable Area Height: %f", playableArea.height);    
    
    int xCoord=arc4random()%(int)playableArea.width;
    int yCoord=size.height-arc4random()%(int)playableArea.height;
    
//    while (xCoord<playableArea.width/1.5 && xCoord>playableArea.width/2.5) {
//        xCoord=playableArea.width-arc4random()%(int)playableArea.width;
//    }
    
    CGPoint newLocation=ccp((xCoord+[self boundingBox].size.width/2), (yCoord-[self boundingBox].size.height/2));
//    CCLOG(@"New Point: %f, %f", newLocation.x, newLocation.y);
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
#if HALLOWEEN
            while (CGRectIntersectsRect(self.boundingBox, checkSprite.boundingBox)) {
#elif WINTER
            while (CGRectIntersectsRect(self.boundingBox, checkSprite.boundingBox)) {
#elif SMART
            while (CGRectIntersectsRect([self boundingBox], [checkSprite boundingBox])) { 
#endif
                CCLOG(@"Conflicts with: %@", checkSprite.characterString);
                 CCLOG(@"Self Box: %f, %f, %f, %f", [self boundingBox].origin.x, [self boundingBox].origin.y, [self boundingBox].size.width,[self boundingBox].size.height);
                 CCLOG(@"Bounding Box: %f, %f, %f, %f", [checkSprite boundingBox].origin.x, [checkSprite boundingBox].origin.y, [checkSprite boundingBox].size.width,[checkSprite boundingBox].size.height);
                 [self setRandomPosition:playableArea checkOtherSprites:aryOtherSprites];   
            }
        }
    }
}


//-(void)setScale:(float)scale{
//    if(self.isShape){
//        [super setScale:scale];
//    }else{
//        CCNode *node;
//        CCARRAY_FOREACH([self children], node)
//        {
//            if([node isKindOfClass:[CCLabelBMFont class]]){
//                CCLabelBMFont *labelToScale=(CCLabelBMFont *)node;
//                CCLOG(@"Current Scale of font: %f", labelToScale.scale);
//                CCLOG(@"Setting Scale of font: %f", scale);
//                CCSprite *char_B = (CCSprite*) [labelToScale getChildByTag:0]; // character 'B'
//                char_B.scale=scale;
////                [labelToScale setScale:2.0];
//            }
//        }
//    }
//}
    
-(void)setColor:(ccColor3B)color{
    CCSprite *node;
    CCARRAY_FOREACH([self children], node)
    {
        //        totalBoundingRect=[self getBoundingRectForNode:node];
        //        totalBoundingRect=[node boundingBox];
        [node setColor:color];
    }
    [super setColor:color];

}


-(void) dealloc{
    self.description=nil;
    self.characterString=nil;
    [super dealloc];
}


@end
