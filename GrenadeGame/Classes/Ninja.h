//
//  Ninja.h
//  GrenadeGame
//
//  Created by Robert Blackwood on 1/20/11.
//  Copyright 2011 Mobile Bros. All rights reserved.
//

#import "SpaceManagerCocos2d.h"

@class Game;

@interface Ninja : cpCCSprite 
{
	Game *_game;
	int _damage;
}

+(id) ninjaWithGame:(Game*)game;
+(id) ninjaWithGame:(Game*)game shape:(cpShape*)shape;
-(id) initWithGame:(Game*)game;
-(id) initWithGame:(Game*)game shape:(cpShape*)shape;

-(void) addDamage:(int)damage;

@end
