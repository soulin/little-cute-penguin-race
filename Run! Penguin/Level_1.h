//
//  HelloWorldLayer.h
//  Run! Penguin
//
//  Created by Sean on 13-4-11.
//  Copyright __MyCompanyName__ 2013年. All rights reserved.
//


// When you import this file, you import all the cocos2d classes
#import "cocos2d.h"
#import "Box2D.h"
#import "RPLevelTemplate.h"
#import "GLES-Render.h"

@class RPLevelDirector;
@class RPGameManager;
// HelloWorldLayer
@interface Level_1 : RPLevelTemplate
{
	b2World* world;
	GLESDebugDraw *m_debugDraw;
    
    RPLevelDirector *_levelDirector;
    RPGameManager *_gameManager;
    //The maximum counts of players in multiplayer mode, 0 means not available for
    //multiplayer mode
    int _playerCountInMultiplayerMode;
    
    LHLayer *_mainLayer;
    LHSprite *_player_1;
    //Particles
    CCParticleSystem *_particleWindSnow;
}

// returns a CCScene that contains the HelloWorldLayer as the only child
+(CCScene *) scene;

@end
