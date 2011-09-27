//
//  Ninja.m
//  GrenadeGame
//
//  Created by Robert Blackwood on 1/20/11.
//  Copyright 2011 Mobile Bros. All rights reserved.
//

#import "Ninja.h"
#import "Game.h"

@implementation Ninja

+(id) ninjaWithGame:(Game*)game
{
	return [[[self alloc] initWithGame:game] autorelease];
}

+(id) ninjaWithGame:(Game*)game shape:(cpShape*)shape
{
	return [[[self alloc] initWithGame:game shape:shape] autorelease];	
}

-(id) initWithGame:(Game*)game
{
	cpShape *shape = [game.spaceManager addCircleAt:cpvzero mass:50 radius:9];
	return [self initWithGame:game shape:shape];
}

-(id) initWithGame:(Game*)game shape:(cpShape*)shape;
{
	[super initWithShape:shape file:@"elephant.png"];
	
	_game = game;
	
	//Free the shape when we are released
	self.spaceManager = game.spaceManager;
	self.autoFreeShape = YES;
	
	//Handle collisions
	shape->collision_type = kNinjaCollisionType;
	
	return self;
}

-(void) addDamage:(int)damage
{
	_damage += damage;
	
	if (_damage > 2)
	{
		[_game enemyKilled];
		
		CCSprite *poof = [CCSprite spriteWithFile:@"poof.png"];
		[_game addChild:poof z:10];
		poof.scale = .1;
		poof.position = self.position;
		id s = [CCEaseBounceOut actionWithAction:[CCScaleTo actionWithDuration:1 scale:1]];
		id d = [CCDelayTime actionWithDuration:.3];
		id f = [CCFadeOut actionWithDuration:.7];
		
		[poof runAction:[CCSequence actions:s,d,f,nil]];
		[_game removeChild:self cleanup:YES];
	}
}

@end
