//
//  CCSpriteExtension.m
//

#import "CCSpriteExtension.h"


@implementation CCSprite (extensions)

-(CGRect) getBoundingRect
{
	CGSize size = [self contentSize];
	size.width *= scaleX_;
	size.height *= scaleY_;
	return CGRectMake(position_.x - size.width * anchorPoint_.x, 
					  position_.y - size.height * anchorPoint_.y, 
					  size.width, size.height);
}

@end
