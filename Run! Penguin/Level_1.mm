//
//  HelloWorldLayer.mm
//  Run! Penguin
//
//  Created by Sean on 13-4-11.
//  Copyright __MyCompanyName__ 2013年. All rights reserved.
//
///////////////////////////////////////////////////////////////////////
// Import the interfaces
#import "Level_1.h"
#import "RPGameManager.h"
#import "RPGameManager.h"
#import "RPLevelDirector.h"
/////////////////////////////////////////////////////////////////////////
#pragma mark - Extention
@interface Level_1 (Private)
- (void)initProperties;
@end
//Level_1 implementation
@implementation Level_1

///////////////////////////////////////////////////////////////////////
#pragma mark - Memory management
+(CCScene *) scene
{
    //New scene is initializing, post notification
    [[NSNotificationCenter defaultCenter] postNotificationName:RPNewSceneIsInitializing object:nil];
	// 'scene' is an autorelease object.
	CCScene *scene = [CCScene node];
	
	// 'layer' is an autorelease object.
	Level_1 *layer = [Level_1 node];
	
	// add layer as a child to scene
	[scene addChild: layer];
	
	// return the scene
	return scene;
}
///////////////////////////////////////////////////////////////////////
// on "dealloc" you need to release all your retained objects
- (void) dealloc
{
	// in case you have something to dealloc, do it in this method
	delete world;
	world = NULL;
	
	delete m_debugDraw;
    
    [_loader release], _loader = nil;
	// don't forget to call "super dealloc"
	[super dealloc];
}
///////////////////////////////////////////////////////////////////////
// on "init" you need to initialize your instance
-(id) init
{
	// always call "super" init
	// Apple recommends to re-assign "self" with the "super" return value
	if( (self=[super init]))
    {
		// enable touches
		self.isTouchEnabled = YES;
		
		// enable accelerometer
		self.isAccelerometerEnabled = YES;
		
		// Define the gravity vector.
		b2Vec2 gravity;
		gravity.Set(0.0f, 0.0f);
		
		// Do we want to let bodies sleep?
		// This will speed up the physics simulation
		bool doSleep = true;
		
		// Construct a world object, which will hold and simulate the rigid bodies.
		world = new b2World(gravity, doSleep);
		
		world->SetContinuousPhysics(true);
		
		// Debug Draw functions
		m_debugDraw = new GLESDebugDraw( PTM_RATIO );
		world->SetDebugDraw(m_debugDraw);
		
		uint32 flags = 0;
		flags += b2DebugDraw::e_shapeBit;
//		flags += b2DebugDraw::e_jointBit;
//		flags += b2DebugDraw::e_aabbBit;
//		flags += b2DebugDraw::e_pairBit;
//		flags += b2DebugDraw::e_centerOfMassBit;
		m_debugDraw->SetFlags(flags);
        ///////////////////////////////////////////////////////////////////////
        //create a LevelHelperLoader object that has the data of the specified level
        _loader = [[LevelHelperLoader alloc] initWithContentOfFile:@"level_1"];
        
        //create all objects from the level file and adds them to the cocos2d layer (self)
        [_loader addObjectsToWorld:world cocos2dLayer:self];
        ///////////////////////////////////////////////////////////////////////
        //Init properties
        [self initProperties];
		///////////////////////////////////////////////////////////////////////
        //necessary or else collision in LevelHelper will not be performed
        [_loader useLevelHelperCollisionHandling];
        //Register collision listener
        [_loader registerBeginOrEndCollisionCallbackBetweenTagA:KID andTagB:SEAL idListener:_levelDirector selListener:@selector(beginEndCollisionHandler:)];
        
        //checks if the level has physics boundaries
        if([_loader hasPhysicBoundaries])
        {
            //if it does, it will create the physic boundaries
            [_loader createPhysicBoundaries:world];
        }
        ///////////////////////////////////////////////////////////////////////
        //Make the camera follow Player_1
        CGRect gameWorldRect = [_loader gameWorldSize]; //the size of the game world
        LHLayer *mainLayer = [_loader layerWithUniqueName:@"MAIN_LAYER"];
        LHParallaxNode *parallax_Level_1 = [_loader parallaxNodeWithUniqueName:@"Parallax_Level_1"];
        CCFollow *followActionMainLayer = [CCFollow actionWithTarget:_player_1 worldBoundary:gameWorldRect];
        CCFollow *followActionParallaxNode = [CCFollow actionWithTarget:_player_1 worldBoundary:gameWorldRect];
        [mainLayer runAction:followActionMainLayer];
        [parallax_Level_1 runAction:followActionParallaxNode];
        ///////////////////////////////////////////////////////////////////////
		[self schedule: @selector(tick:)];
	}
	return self;
}
///////////////////////////////////////////////////////////////////////
#pragma mark - Debug Draw
-(void) draw
{
	// Default GL states: GL_TEXTURE_2D, GL_VERTEX_ARRAY, GL_COLOR_ARRAY, GL_TEXTURE_COORD_ARRAY
	// Needed states:  GL_VERTEX_ARRAY, 
	// Unneeded states: GL_TEXTURE_2D, GL_COLOR_ARRAY, GL_TEXTURE_COORD_ARRAY
	glDisable(GL_TEXTURE_2D);
	glDisableClientState(GL_COLOR_ARRAY);
	glDisableClientState(GL_TEXTURE_COORD_ARRAY);
	
	world->DrawDebugData();
	
	// restore default GL states
	glEnable(GL_TEXTURE_2D);
	glEnableClientState(GL_COLOR_ARRAY);
	glEnableClientState(GL_TEXTURE_COORD_ARRAY);

}
///////////////////////////////////////////////////////////////////////
#pragma mark - Scheduled update
-(void) tick: (ccTime) dt
{
	//It is recommended that a fixed time step is used with Box2D for stability
	//of the simulation, however, we are using a variable time step here.
	//You need to make an informed choice, the following URL is useful
	//http://gafferongames.com/game-physics/fix-your-timestep/
	
	int32 velocityIterations = 8;
	int32 positionIterations = 1;
	
	// Instruct the world to perform a single step of simulation. It is
	// generally best to keep the time step and iterations fixed.
	world->Step(dt, velocityIterations, positionIterations);

	//Iterate over the bodies in the physics world
	for (b2Body* b = world->GetBodyList(); b; b = b->GetNext())
	{
		if (b->GetUserData() != NULL) {
			//Synchronize the AtlasSprites position and rotation with the corresponding body
			CCSprite *myActor = (CCSprite*)b->GetUserData();
			myActor.position = CGPointMake( b->GetPosition().x * PTM_RATIO, b->GetPosition().y * PTM_RATIO);
			myActor.rotation = -1 * CC_RADIANS_TO_DEGREES(b->GetAngle());
		}	
	}
}
///////////////////////////////////////////////////////////////////////
#pragma mark - Accelerometer
- (void)accelerometer:(UIAccelerometer*)accelerometer didAccelerate:(UIAcceleration*)acceleration
{
    //When device orientation is landscapeleft upright, the G direction is X+, the
    //back side of device is Z-, home button is Y-
	static float previousX=0, previousY=0, previousZ=0;
    b2Body *playerBody = [_player_1 body];
    //float positionX = _player_1.position.x;
    //float positionY = _player_1.position.y;
    //float velocityX = playerBody->GetLinearVelocity().x;
    //float velocityY = playerBody->GetLinearVelocity().y;
	
    //Player velocity acceleration
	float accelerationX = (float) acceleration.x * kFilterFactor + (1- kFilterFactor)*previousX;
	float accelerationY = (float) acceleration.y * kFilterFactor + (1- kFilterFactor)*previousY;
	float accelerationZ = (float) acceleration.z * kFilterFactor + (1 - kFilterFactor)*previousZ;
    
    //Player position transitions
    float transitionX = 0;
    float transitionY = 0;
    
    //Player transform
    if (acceleration.x > 0.6f)
    {
        //Player should move down
        transitionY = - kPlayerVelocity;
    }
    if (acceleration.x < 0.6f && acceleration.x > - 0.4f)
    {
        //Player should move up
        transitionY = kPlayerVelocity;
    }
    if (acceleration.y > 0)
    {
        //Player should speed up
        transitionX = kPlayerVelocity;
    }
    if (acceleration.y < 0)
    {
        //Player should slow down
        transitionX = MIN(0, kPlayerVelocity);
    }
    if (acceleration.z < 0.4f)
    {
        //It is the same status as X > 0.6f
    }
    b2Vec2 transitionVelocity = b2Vec2(transitionX, transitionY);
    //playerBody->SetTransform(transitionPos, 0);
    playerBody->SetLinearVelocity(transitionVelocity);
    
	previousX = accelerationX;
	previousY = accelerationY;
	previousZ = accelerationZ;
//	// accelerometer values are in "Portrait" mode. Change them to Landscape left
//	// multiply the gravity by 10
//	b2Vec2 gravity( -accelY * 10, accelX * 10);
//	
//	world->SetGravity( gravity );
}
///////////////////////////////////////////////////////////////////////
#pragma mark - Collision handling
-(void)beginEndCollisionBetweenKidAndSeal:(LHContactInfo*)contact
{
	if([contact contactType])
    	NSLog(@"Kid ... Seal begin contact");
    else
	    NSLog(@"Kid ... Seal end contact");
}
///////////////////////////////////////////////////////////////////////
#pragma mark - Private methods
- (void)initProperties
{
    //Level director
    _levelDirector = [RPLevelDirector sharedLevelDirector];
    _gameManager = [RPGameManager sharedGameManager];
    _playerCountInMultiplayerMode = 2;
    _player_1 = [_loader spriteWithUniqueName:@"penguin_kid"];
    //Multiplayer mode players init
    if ([_gameManager isGameModeMultiplayer])
    {
        //Do something interesting here
    }
}
///////////////////////////////////////////////////////////////////////
@end
