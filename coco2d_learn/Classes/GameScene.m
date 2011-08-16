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

-(void) checkForCollision
{
	// 假设:主角精灵和蜘蛛精灵使用的图片都是正方形的
	float playerImageSize = [player texture].contentSize.width;
	float spiderImageSize = [[spiders lastObject] texture].contentSize.width;
	
	float playerCollisionRadius = playerImageSize * 0.4f; 
	float spiderCollisionRadius = spiderImageSize * 0.4f;
	
	// 这里的碰撞距离和图片形状大约一致 
	float maxCollisionDistance = playerCollisionRadius + spiderCollisionRadius;
	
	int numSpiders = [spiders count]; 
	for (int i = 0; i < numSpiders; i++) 
	{
		CCSprite* spider = [spiders objectAtIndex:i];
		
		if ([spider numberOfRunningActions] == 0)
		{
			// 这只蜘蛛没有移动,所以我们可以跳过对它的碰撞测试
			continue;
		}
		
		// 得到主角精灵和蜘蛛精灵之间的距离
		float actualDistance = ccpDistance(player.position, spider.position);
		
		
		// 检查是否两个物体已经碰撞 
		if (actualDistance < maxCollisionDistance) 
		{
			// 游戏没有被结束掉,这里只是重新设定了蜘蛛的位置 
			[self resetSpiders];
		}
		
	}
	
}


-(void) spiderBelowScreen:(id)sender 
{
	// 确保传进来的sender参数是我们需要的类
	
	NSAssert([sender isKindOfClass:[CCSprite class]], @"sender is not a CCSprite!"); 
	CCSprite* spider = (CCSprite*)sender;
	
	// 将蜘蛛移到刚好超出屏幕顶部的位置 
	
	CGPoint pos = spider.position; 
	CGSize screenSize = [[CCDirector sharedDirector] winSize]; 
	pos.y = screenSize.height + [spider texture].contentSize.height; 
	spider.position = pos;
}





-(void) runSpiderMoveSequence:(CCSprite*)spider
{
	// 随着时间慢慢增加蜘蛛的移动速度 
	numSpidersMoved ++ ;
	
	if (numSpidersMoved % 8 == 0 && spiderMoveDuration > 2.0f)
	{
		spiderMoveDuration -= 0.1f;
	}
	
	// 用于控制蜘蛛移动的动作序列 
	CGPoint belowScreenPosition = CGPointMake(spider.position.x, -[spider texture].contentSize.height);
	
	CCMoveTo    * move = [CCMoveTo actionWithDuration:spiderMoveDuration position:belowScreenPosition];
	CCCallFuncN * call = [CCCallFuncN actionWithTarget:self selector:@selector(spiderBelowScreen:)];
	CCSequence  * sequence = [CCSequence actions:move, call, nil];
	[spider runAction:sequence];
	
}

-(void) spidersUpdate:(ccTime)delta 
{
	// 尝试着寻找一个目前闲置不动的蜘蛛
	
	for (int i = 0; i < 10; i++)
	{
		int randomSpiderIndex = CCRANDOM_0_1() * [spiders count]; 
		CCSprite* spider = [spiders objectAtIndex:randomSpiderIndex];
		
		// 如果蜘蛛不动的话,应该没有任何正在运行的动作 
		if ([spider numberOfRunningActions] == 0) 
		{
			// 以下是控制蜘蛛运动的动作序列 
			[self runSpiderMoveSequence:spider];
			// 每次只能有一只蜘蛛会开始移动 
			break;
		}
	}
}

-(void) resetSpiders
{
	CGSize screenSize = [[CCDirector sharedDirector] winSize];
	
	// 生成一个临时蜘蛛对象,得到它的图片宽度 
	
	CCSprite * tempSpider = [spiders lastObject];
	CGSize size = [tempSpider texture].contentSize;
	
	int numSpiders = [spiders count];
	
	for (int i = 0; i < numSpiders; i++) 
	{
		// 将生成的蜘蛛放在屏幕外制定的位置 
		CCSprite* spider = [spiders objectAtIndex:i]; 
		spider.position = CGPointMake(size.width * i + size.width * 0.5f, screenSize.height - size.height); 
		
		[spider stopAllActions];
	}
	
	// 将预约的方法取消掉。如果没有方法之前没有被预约过的话,这行代码不会产生任何作用 
	[self unschedule:@selector(spidersUpdate:)];
	
	// 预约蜘蛛的更新方法,用指定的时间间隔进行调用 
	[self schedule:@selector(spidersUpdate:) interval:0.7f];
	
	numSpidersMoved = 0;
	spiderMoveDuration = 4.0f;
	
}

-(void) initSpiders 
{
	CGSize screenSize = [[CCDirector sharedDirector] winSize];
	
	// 利用一个临时的蜘蛛精灵以得到蜘蛛图片的大小
	CCSprite * tempSpider = [CCSprite spriteWithFile:@"Icon.png"];
	float imageWidth = [tempSpider texture].contentSize.width;
	
	// 计算可以在同一行的水平方向上同时显示的蜘蛛个数
	int numSpiders = screenSize.width / imageWidth;
	// 用alloc初始化蜘蛛数组
	spiders = [[CCArray alloc] initWithCapacity:numSpiders]; 
	
	for (int i = 0; i < numSpiders; i++)
	{
		CCSprite* spider = [CCSprite spriteWithFile:@"Icon.png"];
		[self addChild:spider z:1 tag:2];
		// 将蜘蛛精灵添加到数组
		[spiders addObject:spider];
	}
	// 调用方法以排列蜘蛛
	[self resetSpiders];
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
		
		[self initSpiders];
		
		scoreLabel = [CCLabelTTF labelWithString:@"0" fontName:@"Arial" fontSize:48]; 
		scoreLabel.position = CGPointMake(screenSize.width / 2, screenSize.height);
		// 调整标签的定位点(anchorPoint)的Y轴位置,让其与屏幕顶部对齐 
		scoreLabel.anchorPoint = CGPointMake(0.5f, 1.0f);
		// 将标签的z值设定为-1,这样它就会显示在所有其它物体的下面一层 
		[self addChild:scoreLabel z:3];
		
		[self scheduleUpdate];
		
		SimpleAudioEngine
		
	}
	
	return self;
}


-(void) dealloc 
{
	CCLOG(@"%@: %@", NSStringFromSelector(_cmd), self); 
	
	[spiders release];
	spiders = nil;
	
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
	
	[self checkForCollision];
	
	
	
	// 每秒更新一次得分标签
	totalTime += delta;
	int currentTime = (int)totalTime;
	if (score < currentTime)
	{
		score = currentTime;
		[scoreLabel setString:[NSString stringWithFormat:@"%i", score]];
	}
}



@end
