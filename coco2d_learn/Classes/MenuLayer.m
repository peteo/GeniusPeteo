//
//  MenuLayer.m
//  coco2d_learn
//
//  Created by Peteo on 11-8-15.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "MenuLayer.h"
#import "SimpleAudioEngine.h"

@implementation MenuLayer

+(CCScene *) scene
{
	// 'scene' is an autorelease object.
	CCScene *scene = [CCScene node];
	
	// 'layer' is an autorelease object.
	MenuLayer * layer = [MenuLayer node];
	
	// add layer as a child to scene
	[scene addChild: layer];
	
	// return the scene
	return scene;
}

-(void) menuItem1Touched: (id) sender
{	
	[[SimpleAudioEngine sharedEngine] playEffect:@"card.caf"];
}

-(void) menuItem2Touched: (id) sender
{	
	[[SimpleAudioEngine sharedEngine] playEffect:@"tip.caf"];
}

-(void) menuItem3Touched: (id) sender
{	
	
}

-(id) init
{
	// always call "super" init
	// Apple recommends to re-assign "self" with the "super" return value
	if( (self=[super init])) 
	{
		// ask director the the window size
		CGSize size = [[CCDirector sharedDirector] winSize];
		
		CCSprite *bg = [CCSprite spriteWithFile:@"bg.png"];
		bg.anchorPoint = ccp(0.0f,0.0f);	
		[self addChild:bg z:0];
		
		// 设置CCMenuItemFont的默认属性 
		[CCMenuItemFont setFontName:@"Helvetica-BoldOblique"];
		[CCMenuItemFont setFontSize:26];
		
		// 生成几个文字标签并指定它们的选择器 
		CCMenuItemFont * item1 = [CCMenuItemFont itemFromString:@"Go Back!" target:self selector:@selector(menuItem1Touched:)];
		
		// 使用已有的精灵生成一个菜单项 
		CCSprite* normal = [CCSprite spriteWithFile:@"Icon.png"];
		normal.color = ccRED; 
		CCSprite* selected = [CCSprite spriteWithFile:@"Icon.png"]; 
		selected.color = ccGREEN; 
		
		CCMenuItemSprite* item2 = [CCMenuItemSprite itemFromNormalSprite:normal
	selectedSprite:selected target:self selector:@selector(menuItem2Touched:)];
		// 用其它两个菜单项生成一个切换菜单(图片也可以用于切换)
		
		[CCMenuItemFont setFontName:@"STHeitiJ-Light"];
		[CCMenuItemFont setFontSize:18]; 
		CCMenuItemFont* toggleOn  = [CCMenuItemFont itemFromString:@"I'm ON!"];
		CCMenuItemFont* toggleOff = [CCMenuItemFont itemFromString:@"I'm OFF!"]; 
		CCMenuItemToggle* item3 = [CCMenuItemToggle itemWithTarget:self selector:@selector(menuItem3Touched:) items:toggleOn, toggleOff, nil];
		
		// 用菜单项生成菜单 
		CCMenu* menu = [CCMenu menuWithItems:item1, item2, item3, nil]; 
		menu.position = CGPointMake(size.width / 2, size.height / 2); 
		[self addChild:menu];
		
		// 排列对齐很重要,这样的话菜单项才不会叠加在同一个位置 
		
		[menu alignItemsVerticallyWithPadding:40];
		
	}
	return self;
}

- (void) dealloc
{

	[super dealloc];
}

@end
