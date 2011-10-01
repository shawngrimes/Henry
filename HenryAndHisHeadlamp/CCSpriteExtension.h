//
//  CCSpriteExtension.h
//

#import "cocos2d.h"

/** extends CCSprite via Category */
@interface CCSprite (extensions)

/** (CCSprite extension) returns the sprite's bounding rect which is:
 position & contentSize multiplied with anchorPoint and scaling */
-(CGRect) getBoundingRect;

@end
