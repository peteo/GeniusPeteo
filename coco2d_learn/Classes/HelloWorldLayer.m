//
//  HelloWorldLayer.m
//  coco2d_learn
//
//  Created by Peteo on 11-8-14.
//  Copyright __MyCompanyName__ 2011. All rights reserved.
//


// Import the interfaces
#import "HelloWorldLayer.h"

#import "MenuLayer.h"

// HelloWorldLayer implementation
@implementation HelloWorldLayer

+(CCScene *) scene
{
	// 'scene' is an autorelease object.
	CCScene *scene = [CCScene node];
	
	// 'layer' is an autorelease object.
	HelloWorldLayer *layer = [HelloWorldLayer node];
	
	// add layer as a child to scene
	[scene addChild: layer];
	
	// return the scene
	return scene;
}

-(void) room1: (id) sender
{	
	[item1 setString:@"ROOM1(2)"];
	
	[[CCDirector sharedDirector] replaceScene:[MenuLayer scene]];
}

-(void) room2: (id) sender
{	
	[item1 setString:@"ROOM1(2)"];
}

-(void) room3: (id) sender
{	
	[item1 setString:@"ROOM1(2)"];
}

-(void) room4: (id) sender
{	
	[item1 setString:@"ROOM1(2)"];
	
	CCMoveTo* move = [CCMoveTo actionWithDuration:3 position:CGPointMake(0.0f, 100.0f)]; 
	[item1 runAction:move];
	
	
}

// on "init" you need to initialize your instance
-(id) init
{
	// always call "super" init
	// Apple recommends to re-assign "self" with the "super" return value
	if( (self=[super init])) 
	{
		// ask director the the window size
		//CGSize size = [[CCDirector sharedDirector] winSize];
		
		CCSprite *bg = [CCSprite spriteWithFile:@"bg.png"];
		bg.anchorPoint = ccp(0.0f,0.0f);	
		[self addChild:bg z:0];
		
		/*
		
		// create and initialize a Label
		CCLabelTTF *label = [CCLabelTTF labelWithString:@"Hello World" fontName:@"Marker Felt" fontSize:64];

		// position the label on the center of the screen
		label.position =  ccp( size.width /2 , size.height/2 );
		
		label.tag = 13;
		
		// add the label as a child to this Layer
		[self addChild: label];
		 
		*/
		
		// 如果你想收到触摸事件的话,你必须在这里启用它! 
		self.isTouchEnabled = YES;
		
		self.isAccelerometerEnabled = YES;
		
		//4个房间的Item
		/*
		CCMenuItemImage *vm1 = [CCMenuItemImage itemFromNormalImage:@"room.png" selectedImage:@"room_s.png" target:self selector:@selector(room1:)];
		CCLabelTTF *label1 = [CCLabelTTF labelWithString:@"ROOM1(0)" fontName:@"Marker Felt" fontSize:26];
		item1 = [CCMenuItemLabel itemWithLabel:label1];
		CCMenu *vmm1 = [CCMenu menuWithItems: vm1,item1,nil];
		vmm1.position = ccp(size.width / 3, 2 * size.height / 3);
		[self addChild:vmm1 z:1];
		
		
		CCMenuItemImage *vm2 = [CCMenuItemImage itemFromNormalImage:@"room.png" selectedImage:@"room_s.png" target:self selector:@selector(room2:)];
		CCLabelTTF *label2 = [CCLabelTTF labelWithString:@"ROOM2(0)" fontName:@"Marker Felt" fontSize:26];
		item2 = [CCMenuItemLabel itemWithLabel:label2];
		CCMenu *vmm2 = [CCMenu menuWithItems: vm2,item2,nil];
		vmm2.position = ccp(2 * size.width / 3, 2 * size.height / 3);
		[self addChild:vmm2 z:1];
		
		CCMenuItemImage *vm3 = [CCMenuItemImage itemFromNormalImage:@"room.png" selectedImage:@"room_s.png" target:self selector:@selector(room3:)];
		CCLabelTTF *label3 = [CCLabelTTF labelWithString:@"ROOM3(0)" fontName:@"Marker Felt" fontSize:26];
		item3 = [CCMenuItemLabel itemWithLabel:label3];
		CCMenu *vmm3 = [CCMenu menuWithItems: vm3,item3,nil];
		vmm3.position = ccp(size.width / 3, size.height / 3);
		[self addChild:vmm3 z:1];
		
		CCMenuItemImage *vm4 = [CCMenuItemImage itemFromNormalImage:@"room.png" selectedImage:@"room_s.png" target:self selector:@selector(room4:)];
		CCLabelTTF *label4 = [CCLabelTTF labelWithString:@"ROOM4(0)" fontName:@"Marker Felt" fontSize:26];
		item4 = [CCMenuItemLabel itemWithLabel:label4];
		CCMenu *vmm4 = [CCMenu menuWithItems: vm4,item4,nil];
		vmm4.position = ccp(2 * size.width / 3, size.height / 3);
		[self addChild:vmm4 z:1];
		
		*/
		
		
		
		//[self unschedule:_cmd];
		
		
		/*
		CCProgressTimer* timer = [CCProgressTimer progressWithFile:@"Icon.png"];
		timer.position = ccp(100,100);
		timer.type = kCCProgressTimerTypeHorizontalBarLR; 
		timer.percentage = 0; 
		[self addChild:timer z:1 tag:111];
		// 进度条需要预约的更新方法来更新自身的状态 
		[self scheduleUpdate];
		*/
		
		
		/*
		CCMotionStreak* streak = [CCMotionStreak streakWithFade:0.7f 
														 minSeg:10
														  image:@"Icon.png"
														  width:32 
														 length:32 
														  color:ccc4(0, 0, 0, 0)];
		
		[self addChild:streak z:5 tag:11];
		*/
		
		
		
	}
	return self;
}

// on "dealloc" you need to release all your retained objects
- (void) dealloc
{
	// in case you have something to dealloc, do it in this method
	// in this particular example nothing needs to be released.
	// cocos2d will automatically release all the children (Label)
	
	// don't forget to call "super dealloc"
	[super dealloc];
}

-(void) ccTouchesBegan:(NSSet*)touches withEvent:(UIEvent*)event; 
{
	/*
	CCLabelTTF * label = (CCLabelTTF*)[self getChildByTag:13];
	label.scale = CCRANDOM_0_1();
	*/
	
	/*
	UITouch *touch = [touches anyObject];
	
	CGPoint location = [touch locationInView:[touch view]];
	
	
	CCMotionStreak* streak = (CCMotionStreak*)[self getChildByTag:11];
	[streak.ribbon addPointAt:location width:32];
	*/
	
}

-(void) ccTouchesMoved:(NSSet*)touches withEvent:(UIEvent*)event; 
{
	/*
	 CCLabelTTF * label = (CCLabelTTF*)[self getChildByTag:13];
	 label.scale = CCRANDOM_0_1();
	 */
	
	/*
	UITouch *touch = [touches anyObject];
	
	CGPoint location = [touch locationInView:[touch view]];
	
	
	CCMotionStreak* streak = (CCMotionStreak*)[self getChildByTag:11];
	[streak.ribbon addPointAt:location width:32];
	*/
	
}

-(void) accelerometer:(UIAccelerometer *)accelerometer didAccelerate:(UIAcceleration *)acceleration 
{
	CCLOG(@"acceleration: x:%f / y:%f / z:%f", acceleration.x, acceleration.y, acceleration.z);
}


-(void)update:(ccTime)delta
{
	// 更新进度条的时间显示
	/*
	CCNode* node = [self getChildByTag:111];
	
	CCProgressTimer* timer = (CCProgressTimer*)node;
	timer.percentage += delta * 10;
	if (timer.percentage >= 100) 
	{
		timer.percentage = 0;
	}
	*/
	
}


@end
