//
//  Bomb.h
//  GrenadeGame
//
//  Created by Robert Blackwood on 1/20/11.
//  Copyright 2011 Mobile Bros. All rights reserved.
//

#import "SpaceManagerCocos2d.h"

@class Game;

@interface Bomb : cpCCSprite 
{
	Game *_game;
	BOOL _countDown;
}

+(id) bombWithGame:(Game*)game;
+(id) bombWithGame:(Game*)game shape:(cpShape*)shape;;
-(id) initWithGame:(Game*)game;
-(id) initWithGame:(Game*)game shape:(cpShape*)shape;

-(void) startCountDown;
-(void) blowup;

@end
