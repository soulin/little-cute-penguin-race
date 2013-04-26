//
//  RPGameHelper.h
//  Run! Penguin
//
//  Created by Sean on 13-4-15.
//
//

#ifndef Run__Penguin_RPGameHelper_h
#define Run__Penguin_RPGameHelper_h
//Pixel to metres ratio. Box2D uses metres as the unit for measurement.
//This ratio defines how many pixels correspond to 1 Box2D "metre"
//Box2D is optimized for objects of 1x1 metre therefore it makes sense
//to define the ratio so that your most common object type is 1x1 metre.
#define PTM_RATIO 32
////////////////////////////////////////////////////////////////////////////
//Player count
#define kRPModeMultipleMinPlayerCount 2
#define kRPModeMultipleMaxPlayerCount 4
////////////////////////////////////////////////////////////////////////////
//Selector string used in NSLog output
#define SELECTOR_STRING [NSString stringWithFormat:@"[%@ %@]: ",NSStringFromClass([self class]), NSStringFromSelector(_cmd)]
///////////////////////////////////////////////////////////////////////
//WinSize
#define WIN_SIZE [CCDirector sharedDirector].winSize
///////////////////////////////////////////////////////////////////////
//Acceleration filter
//Bigger this value is more gentle the acceleration is
#define kAccelerationFilterFactor 0.7f
///////////////////////////////////////////////////////////////////////
//Player velocity
#define kPlayerVelocity 2.5f
#define kPlayerFlipVelocity 5.0f
///////////////////////////////////////////////////////////////////////
//Local player changed notification
#define RPGameCenterLocalPlayerAuthenticationChanged @"RPGameCenterLocalPlayerAuthenticationChanged"
///////////////////////////////////////////////////////////////////////
//Game state
//Level loading progress changed notification
#define RPLevelLoadingProgressPercentageChanged @"RPLevelLoadingProgressPercentageChanged"
//New level is loading
#define RPNewSceneIsInitializing @"RPNewSceneIsInitializing"
//New scene becomes current scene
#define RPNewSceneHasBecomeCurrentScene @"RPNewSceneHasBecomeCurrentScene"
////////////////////////////////////////////////////////////////////////////
#endif
