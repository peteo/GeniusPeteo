//
//  Serialize.m
//  Example For SpaceManager
//
//  Created by Rob Blackwood on 5/30/10.
//

#import "Game.h"
#import "Ninja.h"

#define SLING_POSITION			ccp(60,157)
#define SLING_BOMB_POSITION		ccpAdd(SLING_POSITION, ccp(0,9))
#define SLING_MAX_ANGLE			245
#define SLING_MIN_ANGLE			110
#define SLING_TOUCH_RADIUS		25
#define SLING_LAUNCH_RADIUS		25
#define SERIALIZED_FILE			@"GrenadeGameT1.xml"

@interface Game (PrivateMethods)

//menu
- (void) restart:(id)sender;

//setup
- (void) setupShapes;
- (void) setupEnemies;
- (void) setupBackground;
- (void) setupBombs;
- (void) setupNextBomb;
- (void) setupRestart;

//creation
- (CCNode<cpCCNodeProtocol>*) createTriangleAt:(cpVect)pt size:(int)size mass:(int)mass;
- (CCNode<cpCCNodeProtocol>*) createBlockAt:(cpVect)pt width:(int)w height:(int)h mass:(int)mass;
- (void) createTriPillarsAt:(cpVect)pos width:(int)w height:(int)h;

//collisions
-(BOOL) handleNinjaCollision:(CollisionMoment)moment arbiter:(cpArbiter*)arb space:(cpSpace*)space;
-(BOOL) handleBombCollision:(CollisionMoment)moment arbiter:(cpArbiter*)arb space:(cpSpace*)space;
@end

@implementation Game

@synthesize spaceManager = smgr;

+(id) scene
{
	CCScene *scene = [CCScene node];
	[scene addChild:[Game node] z:0 tag:GAME_TAG];
	return scene;
}

- (id) init
{
	return [self initWithSaved:YES];
}

- (id) initWithSaved:(BOOL)loadIt
{
	[super init];
	
	[[CCTouchDispatcher sharedDispatcher] addTargetedDelegate:self priority:0 swallowsTouches:NO];
	
	_bombs = [[NSMutableArray array] retain];
	
	//allocate our space manager
	smgr = [[SpaceManagerCocos2d alloc] init];
	smgr.constantDt = 1.0/55.0f;
		
	[smgr addCollisionCallbackBetweenType:kNinjaCollisionType 
								otherType:kGroundCollisionType 
								   target:self 
								 selector:@selector(handleNinjaCollision:arbiter:space:)
								  moments:COLLISION_POSTSOLVE,nil];
	[smgr addCollisionCallbackBetweenType:kNinjaCollisionType 
								otherType:kBlockCollisionType 
								   target:self 
								 selector:@selector(handleNinjaCollision:arbiter:space:)
								  moments:COLLISION_POSTSOLVE,nil];
	[smgr addCollisionCallbackBetweenType:kNinjaCollisionType 
								otherType:kBombCollisionType 
								   target:self 
								 selector:@selector(handleNinjaCollision:arbiter:space:)
								  moments:COLLISION_POSTSOLVE,nil];
	[smgr addCollisionCallbackBetweenType:kBombCollisionType 
								otherType:kGroundCollisionType 
								   target:self 
								 selector:@selector(handleBombCollision:arbiter:space:)
								  moments:COLLISION_POSTSOLVE,nil];
	[smgr addCollisionCallbackBetweenType:kBombCollisionType 
								otherType:kBlockCollisionType 
								   target:self 
								 selector:@selector(handleBombCollision:arbiter:space:)
								  moments:COLLISION_POSTSOLVE,nil];
	
	[self setupBackground];
	[self setupRestart];
	
	//Try to load it from file, if not create from scratch
	if (!(loadIt && [smgr loadSpaceFromUserDocs:SERIALIZED_FILE delegate:self]))
	{
		[self setupBombs];
		[self setupEnemies];
		[self setupShapes];
	}
	
	[self setupNextBomb];
		
	//[self addChild:[smgr createDebugLayer]];
	
	//start the manager!
	[smgr start]; 	

	return self;
}

- (void) restart:(id)sender
{
	CCScene *scene = [CCScene node];
	[scene addChild:[[[Game alloc] initWithSaved:NO] autorelease] z:0 tag:GAME_TAG];
	[[CCDirector sharedDirector] replaceScene:[CCTransitionFade transitionWithDuration:.7 
																				 scene:scene 
																			 withColor:ccBLACK]];
}

- (void) onExit
{
	[[CCTouchDispatcher sharedDispatcher] removeDelegate:self];
	
	[smgr stop];
	[self save];
	[super onExit];
}

-(void)save
{
	[smgr saveSpaceToUserDocs:SERIALIZED_FILE delegate:self];
}

- (void) dealloc
{	
	//do this before [smgr release] so autoFreeShape works
	[self removeAllChildrenWithCleanup:YES];
	
	[_bombs release];
	[smgr release];
	[super dealloc];
}

-(BOOL) aboutToReadShape:(cpShape*)shape shapeId:(long)id
{
	if (shape->collision_type == kBombCollisionType)
	{
		Bomb *bomb = [Bomb bombWithGame:self shape:shape];
		[self addChild:bomb z:5];
		
		if (cpBodyGetMass(shape->body) == STATIC_MASS)
			[_bombs addObject:bomb];
	}
	else if (shape->collision_type == kNinjaCollisionType)
	{
		Ninja *ninja = [Ninja ninjaWithGame:self shape:shape];
		[self addChild:ninja z:5];
	}
	else if (shape->collision_type == kBlockCollisionType)
	{
		cpShapeNode *node = [cpShapeNode nodeWithShape:shape];
		node.color = ccc3(56+rand()%200, 56+rand()%200, 56+rand()%200);
		[self addChild:node z:5];
	}
	
	//This just means accept the reading of this shape
	return YES;
}

-(BOOL) ccTouchBegan:(UITouch*)touch withEvent:(UIEvent *)event
{	
	CGPoint pt = [self convertTouchToNodeSpace:touch];	
	float radiusSQ = SLING_TOUCH_RADIUS*SLING_TOUCH_RADIUS;
	
	//Get the vector of the touch
	CGPoint vector = ccpSub(SLING_POSITION, pt);
	
	//Are we close enough to the slingshot?
	if (ccpLengthSQ(vector) < radiusSQ)
		return YES;
	else
		return NO;
}

-(void) ccTouchMoved:(UITouch*)touch withEvent:(UIEvent *)event
{
	CGPoint pt = [self convertTouchToNodeSpace:touch];
	
	//Get the vector, angle, length, and normal vector of the touch
	CGPoint vector = ccpSub(pt, SLING_BOMB_POSITION);
	CGPoint normalVector = ccpNormalize(vector);
	float angleRads = ccpToAngle(normalVector);
	int angleDegs = (int)CC_RADIANS_TO_DEGREES(angleRads) % 360;
	float length = ccpLength(vector);
	
	//Correct the Angle; we want a positive one
	while (angleDegs < 0)
		angleDegs += 360;
	
	//Limit the length
	if (length > SLING_LAUNCH_RADIUS)
		length = SLING_LAUNCH_RADIUS;
	
	//Limit the angle
	if (angleDegs > SLING_MAX_ANGLE)
		normalVector = ccpForAngle(CC_DEGREES_TO_RADIANS(SLING_MAX_ANGLE));
	else if (angleDegs < SLING_MIN_ANGLE)
		normalVector = ccpForAngle(CC_DEGREES_TO_RADIANS(SLING_MIN_ANGLE));
	
	//Set the position
	_curBomb.position = ccpAdd(SLING_BOMB_POSITION, ccpMult(normalVector, length));
}

-(void) ccTouchEnded:(UITouch *)touch withEvent:(UIEvent *)event
{
	CGPoint vector = ccpSub(SLING_BOMB_POSITION, _curBomb.position);

	if (_curBomb)
		[smgr morphShapeToActive:_curBomb.shape mass:30];
	
	[_curBomb applyImpulse:cpvmult(vector, 240)];

	[self setupNextBomb];
}

- (void) setupShapes
{	
	//add four walls to our screen
	[smgr addWindowContainmentWithFriction:1.0 elasticity:1.0 inset:cpvzero];
	
	cpShape *ground;
	ground = [smgr addSegmentAtWorldAnchor:cpv(72,13) toWorldAnchor:cpv(480,13) mass:STATIC_MASS radius:1];
	ground->collision_type = kGroundCollisionType;
	ground = [smgr addSegmentAtWorldAnchor:cpv(72,13) toWorldAnchor:cpv(72,133) mass:STATIC_MASS radius:1];
	ground->collision_type = kGroundCollisionType;
	ground = [smgr addSegmentAtWorldAnchor:cpv(72,133) toWorldAnchor:cpv(0,133) mass:STATIC_MASS radius:1];
	ground->collision_type = kGroundCollisionType;	
	
	[self createTriPillarsAt:cpv(300,13) width:80 height:20];
	[self createTriPillarsAt:cpv(320,33) width:40 height:20];
	[self createTriPillarsAt:cpv(330,53) width:20 height:70];
	
	[self createTriangleAt:cpv(340,135) size:20 mass:40];
	
	[self createTriPillarsAt:cpv(400,13) width:72 height:40];
	[self createTriPillarsAt:cpv(400,53) width:72 height:20];
	[self createTriPillarsAt:cpv(400,73) width:72 height:20];
}

- (void) setupEnemies
{
	Ninja *ninja = [Ninja ninjaWithGame:self];
	ninja.position = ccp(250,23);
	[self addChild:ninja z:5];
	_enemiesLeft++;
	
	ninja = [Ninja ninjaWithGame:self];
	ninja.position = ccp(415,23);
	[self addChild:ninja z:5];
	_enemiesLeft++;

	ninja = [Ninja ninjaWithGame:self];
	ninja.position = ccp(455,23);
	[self addChild:ninja z:5];
	_enemiesLeft++;
	
	ninja = [Ninja ninjaWithGame:self];
	ninja.position = ccp(415,100);
	[self addChild:ninja z:5];
	_enemiesLeft++;
	
	ninja = [Ninja ninjaWithGame:self];
	ninja.position = ccp(455,100);
	[self addChild:ninja z:5];
	_enemiesLeft++;
}

- (void) setupBackground
{
	CCSprite *background = [CCSprite spriteWithFile:@"smgrback.png"];
	background.position = ccp(240,160);
	[self addChild:background z:0];
	
	CCSprite *sling1 = [CCSprite spriteWithFile:@"sling1.png"];
	CCSprite *sling2 = [CCSprite spriteWithFile:@"sling2.png"];
	
	sling1.position = SLING_POSITION;
	sling2.position = ccpAdd(SLING_POSITION, ccp(5,10));
	
	[self addChild:sling1 z:10];
	[self addChild:sling2 z:1];	
}

- (void) setupBombs
{
	for (int i = 0; i < 3; i++)
	{
		Bomb *bomb = [Bomb bombWithGame:self];
		bomb.position = ccp(10+i*16, 143);
		[self addChild:bomb z:5];
		[_bombs addObject:bomb];
	}
}

- (void) setupNextBomb
{
	if ([_bombs count])
	{
		_curBomb = [_bombs lastObject];
		
		//move it into position
		[_curBomb runAction:[CCMoveTo actionWithDuration:.7 position:SLING_BOMB_POSITION]];
	
		[_bombs removeLastObject];
	}
	else
		_curBomb = nil;
}

- (void) setupRestart
{
	CCMenuItem *restart = [CCMenuItemImage itemFromNormalImage:@"restart.png"
												 selectedImage:@"restartsel.png"
														target:self
													  selector:@selector(restart:)];
	restart.position = ccp(-220,-140);
	[self addChild:[CCMenu menuWithItems:restart,nil] z:100];
}	

- (CCNode<cpCCNodeProtocol>*) createBlockAt:(cpVect)pt 
									  width:(int)w 
									 height:(int)h 
									   mass:(int)mass
{
	cpShape *shape = [smgr addRectAt:pt mass:mass width:w height:h rotation:0];
	shape->collision_type = kBlockCollisionType;
	
	cpShapeNode *node = [cpShapeNode nodeWithShape:shape];
	node.color = ccc3(56+rand()%200, 56+rand()%200, 56+rand()%200);
	
	[self addChild:node z:5];
	
	return node;
}

- (CCNode<cpCCNodeProtocol>*) createTriangleAt:(cpVect)pt 
										  size:(int)size 
										  mass:(int)mass
{
	CGPoint d1 = ccpForAngle(CC_DEGREES_TO_RADIANS(330));
	CGPoint d2 = ccpForAngle(CC_DEGREES_TO_RADIANS(210));
	CGPoint d3 = ccpForAngle(CC_DEGREES_TO_RADIANS(90));
	
	d1 = ccpMult(d1, size);
	d2 = ccpMult(d2, size);
	d3 = ccpMult(d3, size);
	
	cpShape *shape = [smgr addPolyAt:pt mass:mass rotation:0 numPoints:3 points:d1,d2,d3,nil];
	shape->collision_type = kBlockCollisionType;
	
	cpShapeNode *node = [cpShapeNode nodeWithShape:shape];
	node.color = ccc3(100, 20, 40);
	
	[self addChild:node];
	
	return node;
}

- (void) createTriPillarsAt:(cpVect)pos 
					  width:(int)w 
					 height:(int)h
{
	const int W2 = w/2;
	const int H2 = 8;
	const int W1 = 8;
	const int H1 = h-H2;
	const int M = 100;
	
	//pillars 1
	[self createBlockAt:cpvadd(pos, cpv(0,H1/2)) width:W1 height:H1 mass:M];
	[self createBlockAt:cpvadd(pos, cpv(W2,H1/2)) width:W1 height:H1 mass:M];
	[self createBlockAt:cpvadd(pos, cpv(W2*2,H1/2)) width:W1 height:H1 mass:M];
	
	//floor 1
	[self createBlockAt:cpvadd(pos, cpv(W2/2-W1/4,H1+H2/2)) width:W2+W1/2 height:H2 mass:M];
	[self createBlockAt:cpvadd(pos, cpv(W2+W2/2+W1/4,H1+H2/2)) width:W2+W1/2 height:H2 mass:M];
}

-(BOOL) handleNinjaCollision:(CollisionMoment)moment arbiter:(cpArbiter*)arb space:(cpSpace*)space
{
	CP_ARBITER_GET_SHAPES(arb, ninjaShape, otherShape);
	
	//Get a value for "force" generated by collision
	float f = cpvdistsq(ninjaShape->body->v, otherShape->body->v);
	
	if (f > 600)
	{
		[(Ninja*)ninjaShape->data addDamage:f/600];
	}
	
	//moments:COLLISION_BEGIN, COLLISION_PRESOLVE, COLLISION_POSTSOLVE, COLLISION_SEPARATE	
	return YES;
}

-(BOOL) handleBombCollision:(CollisionMoment)moment arbiter:(cpArbiter*)arb space:(cpSpace*)space
{
	CP_ARBITER_GET_SHAPES(arb, bombShape, otherShape);
	
	[(Bomb*)bombShape->data startCountDown];
	return YES;
}

-(void) enemyKilled
{
	_enemiesLeft--;
	if (_enemiesLeft == 0)
	{
		CCLabelTTF *label = [CCLabelTTF labelWithString:@"You Win!" 
											   fontName:@"Marker Felt" 
											   fontSize:36];
		label.position = ccp(240,180);
		[self addChild:label z:100];
	}
}

@end

