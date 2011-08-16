//
//  GameScene.h
//  coco2d_learn
//
//  Created by Peteo on 11-8-15.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "cocos2d.h"

@interface GameScene : CCLayer 
{
	CCSprite * player;
	CGPoint    playerVelocity;
	
	CCArray  * spiders;
	
	float      spiderMoveDuration;
	int        numSpidersMoved;
	
	CCLabelTTF * scoreLabel;
	
	ccTime  totalTime;
	int     score;
	
}

+(id) scene;

-(void) resetSpiders;

@end
