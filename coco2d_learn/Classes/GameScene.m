//
//  GameScene.m
//  coco2d_learn
//
//  Created by Peteo on 11-8-15.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "GameScene.h"


@implementation GameScene

+(id) scene 
{
	CCScene * scene = [CCScene node]; 
	CCLayer * layer = [GameScene node];
	[scene addChild:layer]; 
	return scene;
}

-(id)init
{
	if ((self = [super init])) 
	{
		CCLOG(@"%@: %@", NSStringFromSelector(_cmd), self);
		
		self.isAccelerometerEnabled = YES;
		player = [CCSprite spriteWithFile:@"Icon.png"];
		[self addChild:player z:0 tag:1];
		CGSize screenSize = [[CCDirector sharedDirector] winSize];
		float imageHeight = [player texture].contentSize.height;
		player.position = CGPointMake(screenSize.width / 2, imageHeight / 2);
		
		[self scheduleUpdate];
		
	}
	
	return self;
}


-(void) dealloc 
{
	CCLOG(@"%@: %@", NSStringFromSelector(_cmd), self); 
	// 不要忘记调用 
	[super dealloc];
}

-(void) accelerometer:(UIAccelerometer *)accelerometer didAccelerate:(UIAcceleration *)acceleration 
{
	//CGPoint pos = player.position; 
	//pos.x += acceleration.x * 10; 
	//player.position = pos;
	
	// 控制减速的速率(值越低=可以更快的改变方向) 
	float deceleration = 0.4f; 
	
	//加速计敏感度的值越大,主角精灵对加速计的输入就越敏感 
	float sensitivity = 6.0f;
	
	// 最大速度值 
	float maxVelocity = 100;
	
	// 基于当前加速计的加速度调整速度
	playerVelocity.x = playerVelocity.x * deceleration + acceleration.x * sensitivity;
	// 我们必须在两个方向上都限制主角精灵的最大速度值 

	if (playerVelocity.x > maxVelocity) 
	{
		playerVelocity.x = maxVelocity;
	} 
	else if (playerVelocity.x < - maxVelocity) 
	{
		playerVelocity.x = - maxVelocity;
	}
	
}

-(void) update:(ccTime)delta
{
	// 用playerVelocity持续增加主角精灵的位置信息 
	CGPoint pos = player.position;
	pos.x += playerVelocity.x;
	// 如果主角精灵移动到了屏幕以外的话,它应该被停止 
	CGSize screenSize = [[CCDirector sharedDirector] winSize]; 
	float imageWidthHalved = [player texture].contentSize.width * 0.5f; 
	float leftBorderLimit = imageWidthHalved; 
	float rightBorderLimit = screenSize.width - imageWidthHalved;
	// 以防主角精灵移动到屏幕以外 
	if (pos.x < leftBorderLimit)
	{
		pos.x = leftBorderLimit; 
		playerVelocity = CGPointZero;
	}
	else if (pos.x > rightBorderLimit) 
	{
		pos.x = rightBorderLimit; 
		playerVelocity = CGPointZero;
	}
	
	// 将更新过的位置信息赋值给主角精灵 
	
	player.position = pos;
		
}



@end
