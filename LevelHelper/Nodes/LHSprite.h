//  This file was generated by LevelHelper
//  http://www.levelhelper.org
//
//  LevelHelperLoader.h
//  Created by Bogdan Vladu
//  Copyright 2011 Bogdan Vladu. All rights reserved.
//
////////////////////////////////////////////////////////////////////////////////
//
//  This software is provided 'as-is', without any express or implied
//  warranty.  In no event will the authors be held liable for any damages
//  arising from the use of this software.
//  Permission is granted to anyone to use this software for any purpose,
//  including commercial applications, and to alter it and redistribute it
//  freely, subject to the following restrictions:
//  The origin of this software must not be misrepresented; you must not
//  claim that you wrote the original software. If you use this software
//  in a product, an acknowledgment in the product documentation would be
//  appreciated but is not required.
//  Altered source versions must be plainly marked as such, and must not be
//  misrepresented as being the original software.
//  This notice may not be removed or altered from any source distribution.
//  By "software" the author refers to this code file and not the application 
//  that was used to generate this file.
//
////////////////////////////////////////////////////////////////////////////////

#import <Foundation/Foundation.h>
#import "cocos2d.h"

#import "lhConfig.h"
#ifdef LH_USE_BOX2D
#include "Box2D.h"
#endif
#import "LHPathNode.h"

#ifdef __CC_PLATFORM_IOS
#import <UIKit/UIKit.h>					// Needed for UIAccelerometerDelegate
#import "CCTouchDelegateProtocol.h"

#elif defined __CC_PLATFORM_MAC

#import "CCEventDispatcher.h"

#endif


@class LHBatch;
@class LHAnimationNode;
@class LevelHelperLoader;
@class LHParallaxNode;
@class LHBezier;
@class LHObserverPair;
@class LHJoint;
@class LHFixture;
//------------------------------------------------------------------------------
//------------------------------------------------------------------------------

#ifdef __IPHONE_OS_VERSION_MAX_ALLOWED


#if COCOS2D_VERSION >= 0x00020100
@interface LHSprite : CCSprite <CCTouchAllAtOnceDelegate, CCTouchOneByOneDelegate>
#else
@interface LHSprite : CCSprite <CCStandardTouchDelegate, CCTargetedTouchDelegate>
#endif

#elif defined(__MAC_OS_X_VERSION_MAX_ALLOWED)
@interface LHSprite : CCSprite <CCMouseEventDelegate>
#endif
{
#ifdef LH_USE_BOX2D
    b2World* box2dWorld;
	b2Body* body; //week ptr
    
    bool bDefaultFixRotation;
    float bDefaultGravityScale;
    bool bDefaultCanSleep;
    bool bDefaultIsBullet;
    b2Vec2 bDefaultLinearVelocity;
    float bDefaultAngularVelocity;
    float bDefaultLinearDamping;
    float bDefaultAngularDamping;
#endif
    
    NSMutableArray* fixturesObj;
    NSArray* fixturesInfo; //in case we want a different scale
    
    NSMutableString* uniqueName;
    
    NSString* shSceneName;
    NSString* shSheetName;
    NSString* shSpriteName;
        
    NSString* imageFile;
    CGRect originalRect;
    CGPoint originalTextureOffset;
    
    NSMutableArray* preloadedAnimations;
    __strong LHAnimationNode* animation;
    id animEndedObserver;//week ptr
    id animChangedFrameObserver;
    id animEndedAllRepObserver;
    bool animPauseStateOnLevelPause;
    bool animAtStart;
    bool prepareAnimInProgress; //we use this in order to stop onExit event to remove the touch handling
    
    bool pathPauseStateOnLevelPause;
    LHPathNode* pathNode;
    id pathEndedObserver;
    id pathChangedPointObserver;
    bool pathDefaultFlipX;
    bool pathDefaultFlipY;
    bool pathDefaultIsCyclic;
    bool pathDefaultRelativeMove;
    NSString* pathDefaultName;
    int pathDefaultOrientation;
    bool pathDefaultRestartOtherEnd;
    float pathDefaultSpeed;
    bool pathStartAtLaunch;
    int pathDefaultStartPoint;
    
    CGSize realScale; //used for the joints in case you create a level with SD graphics using ipad template
    
    __unsafe_unretained LHParallaxNode* parallaxFollowingThisSprite;
    __unsafe_unretained LHParallaxNode* spriteIsInParallax;
    
    //this also serves as left mouse events on mac
    LHObserverPair* touchBeginObserver;
    LHObserverPair* touchMovedObserver;
    LHObserverPair* touchEndedObserver;
    
    
    
    LHObserverPair* tagTouchBeginObserver;
    LHObserverPair* tagTouchMovedObserver;
    LHObserverPair* tagTouchEndedObserver;
    
    bool swallowTouches;
    bool touchesDisabled;
    int touchPriority;
    
#ifdef __MAC_OS_X_VERSION_MAX_ALLOWED
    LHObserverPair* rightMouseDownObserver;
    LHObserverPair* rightMouseDraggedObserver;
    LHObserverPair* rightMouseUpObserver;
    
    LHObserverPair* tagRightMouseDownObserver;
    LHObserverPair* tagRightMouseDraggedObserver;
    LHObserverPair* tagRightMouseUpObserver;
    bool mouseDownStarted;//keeps track if mouse down was started on the sprite
    bool r_mouseDownStarted;
#endif
    
    bool usesOverloadedTransformations; //false uses native Cocos2d setPosition setRotation - true uses LH (may cause problems in certain game logics)
    
    bool usePhysicsForTouches;
    id  userCustomInfo;
    
    bool usesUVTransformation;
}
@property (readonly) bool usesUVTransformation; //used internally by supporting code to figure out if a sh document was created using "No resampling or not"
@property (readwrite) CGSize realScale;
@property (readwrite) bool swallowTouches;
@property (readwrite) bool touchesDisabled;
@property (readwrite) int touchPriority;

-(void)update:(ccTime)dt;//subclassers should call [super update:dt];
////////////////////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////
//CONSTRUCTORS USED BY LEVELHELPER
//Autorelease constructors - user should almost always use this
+(id)batchSpriteWithDictionary:(NSDictionary*)dictionary batch:(LHBatch*)batch;//render by batch node
+(id)spriteWithDictionary:(NSDictionary*)dictionary;//self render

-(id)initBatchSpriteWithDictionary:(NSDictionary*)dictionary batch:(LHBatch*)batch;
-(id)initWithDictionary:(NSDictionary*)dictionary;

-(void)postInit;
//the top methods should be overloaded when overloading this class

//CONSTRUCTORS FOR THE USER
+(id)spriteWithName:(NSString*)spriteName 
          fromSheet:(NSString*)sheetName 
             SHFile:(NSString*)spriteHelperFile;

+(id)batchSpriteWithName:(NSString*)spriteName 
                   batch:(LHBatch*)batch; //necessary info is taking from the LHBatch instance



-(void)removeSelf; //use this to completely remove a sprite from the game


-(LevelHelperLoader*) parentLoader;
////////////////////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////
//INFO METHODS
//------------------------------------------------------------------------------
-(void) setUniqueName:(NSString*)name;
-(NSString*)uniqueName;

#ifdef LH_USE_BOX2D
-(void) setBody:(b2Body*)body;
-(b2Body*)body;
-(bool) removeBodyFromWorld;
#endif

-(NSString*)imageFile;
-(void)setImageFile:(NSString*)img;

-(CGRect)originalRect;
-(void)setOriginalRect:(CGRect)rect;

-(CGPoint)originalTextureOffset;

@property (readonly) NSString* shSceneName;
@property (readonly) NSString* shSheetName;
@property (readonly) NSString* shSpriteName;
////////////////////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////
//TRANSFORMATION METHODS
//------------------------------------------------------------------------------
//The following method will transform the physic body also - if any
@property (readwrite) bool usesOverloadedTransformations; //use this to activate CCActions with physical sprites

-(void) transformPosition:(CGPoint)pos;
-(void) transformRotation:(float)rot;

-(void) transformScale:(float)scale;
-(void) transformScaleX:(float)scaleX;
-(void) transformScaleY:(float)scaleY;

////////////////////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////
//ANIMATION METHODS
//------------------------------------------------------------------------------
//if you want the animation switching to be faster you need to preload an animation
//using the "Preloaded Animations" property inside LH App
-(void) prepareAnimationNamed:(NSString*)animName fromSHScene:(NSString*)shScene;
-(void) playAnimation;


//use this methods when you want to get notification about animation on a per sprite basis
-(void) setAnimationHasEndedObserver:(id)observer selector:(SEL)selector;
-(void) setAnimationHasChangedFrameObserver:(id)observer selector:(SEL)selector;
-(void) setAnimationHasEndedAllRepetitionsObserver:(id)observer selector:(SEL)selector;
-(void) removeAnimationHasEndedObserver;
-(void) removeAnimationHasChangedFrameObserver;
-(void) removeAnimationHasEndedAllRepetitionsObserver;

//use this methods when you want to get notification about animations for all sprites
+(void) setGlobalAnimationHasEndedObserver:(id)observer selector:(SEL)selector;
+(void) setGlobalAnimationHasChangedFrameObserver:(id)observer selector:(SEL)selector;
+(void) setGlobalAnimationHasEndedAllRepertitionsObserver:(id)observer selector:(SEL)selector;
+(void) removeGlobalAnimationHasEndedObserver:(id)observer;
+(void) removeGlobalAnimationHasChangedFrameObserver:(id)observer;
+(void) removeGlobalAnimationHasEndedAllRepetitionsObserver:(id)observer;

-(void) pauseAnimation;
-(void) restartAnimation;
-(void) stopAnimation; //removes the animation entirely
-(void) stopAnimationAndRestoreOriginalFrame:(BOOL)restore;

-(bool) isAnimationPaused;

-(NSString*) animationName;
-(NSString*) animationSHScene;
-(int) numberOfFrames;
-(int) currentFrame;

-(float) animationDelayPerUnit;
-(void) setAnimationDelayPerUnit:(float)d;

-(float)animationDuration;//return how much time will take for a loop to complete

-(void)setFrame:(int)frmNo;
-(void) nextFrame;
-(void) prevFrame;

-(void) nextFrameAndRepeat; //will loop when it reaches end
-(void) prevFrameAndRepeat; //will loop when it reaches start

-(bool) isAtLastFrame;
////////////////////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////
//USER CUSTOM INFO - based on the custom class template
//------------------------------------------------------------------------------
-(NSString*)userInfoClassName;
//this will return an instance of the class defined in LH under Custom Class Properties
//check for nil to see if you have any info
//use the class properties to read all your info 
//e.g id myInfo = [sprite userInfo];  if(myInfo){ int life = myInfo.life); } 

//use the class properties to set new (other then the one set in LH) values
//e.g id myInfo = [sprite userInfo]; if(myInfo){ myInfo.life = 40; } )
-(id)userInfo; 
////////////////////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////
//JOINTS LIST
//------------------------------------------------------------------------------
//returns the LHJoint* objects attached to the body of this sprite
//from the LHJoint you can take back the box2d joint
#ifdef LH_USE_BOX2D
-(NSArray*) jointList; //array contains LHJoint* objects
-(LHJoint*) jointWithUniqueName:(NSString*)name;

//remove all joints attached to this sprite
-(bool) removeAllAttachedJoints;
-(bool) removeJoint:(LHJoint*)jt;
#endif
////////////////////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////

//PATH METHODS
//------------------------------------------------------------------------------
-(void) prepareMovementOnPathWithUniqueName:(NSString*)pathName;

-(NSString*) pathUniqueName;

//use this methods when you want to get notification about path movement on a per sprite basis
-(void) setPathMovementHasEndedObserver:(id)observer selector:(SEL)selector;
-(void) setPathMovementHasChangedPointObserver:(id)observer selector:(SEL)selector;
-(void) removePathMovementHasEndedObserver;
-(void) removePathMovementHasChangedPointObserver;

//use this methods when you want to get notification about path movement for all sprites
+(void) setGlobalPathMovementHasEndedObserver:(id)observer selector:(SEL)selector;
+(void) setGlobalPathMovementHasChangedPointObserver:(id)observer selector:(SEL)selector;
+(void) removeGlobalPathMovementHasEndedObserver:(id)observer;
+(void) removeGlobalPathMovementHasChangedPointObserver:(id)observer;


-(void) startPathMovement;
-(void) pausePathMovement;
-(bool) isPathPaused;
-(void) restartPathMovement;
-(void) stopPathMovement; //removes the path movement;

-(void) setPathMovementSpeed:(float)value;
-(float)pathMovementSpeed;

-(void) setPathMovementStartPoint:(enum LH_PATH_MOVEMENT_START_POINT)point;
-(enum LH_PATH_MOVEMENT_START_POINT) pathMovementStartPoint;

-(void) setPathMovementIsCyclic:(bool)cyclic;
-(bool) pathMovementIsCyclic;

-(void) setPathMovementRestartsAtOtherEnd:(bool)otherEnd;
-(bool) pathMovementRestartsAtOtherEnd;

-(void) setPathMovementOrientation:(enum LH_PATH_MOVEMENT_ORIENTATION)point;
-(enum LH_PATH_MOVEMENT_ORIENTATION) pathMovementOrientation;

-(void) setPathMovementFlipXAtEnd:(bool)flip;
-(bool) pathMovementFlipXAtEnd;

-(void) setPathMovementFlipYAtEnd:(bool)flip;
-(bool) pathMovementFlipYAtEnd;

-(void) setPathMovementRelative:(bool)rel;
-(bool) pathMovementRelative;

//for notifications please consult the api documentation or LHPathNode.h
//------------------------------------------------------------------------------



//TOUCH METHODS
//------------------------------------------------------------------------------
//If NO_PHYSICS type - touch is detected inside the sprite quad, meaning touch can be
//detected on the non visible part of the sprite also.

//If sprite has physics - touch is detected on the body of the sprite, meaning touch will be detected
//based on the shape of the body - useful when you dont want to detect touch on the non visible part
//of the sprite
-(bool)isTouchedAtPoint:(CGPoint)point;

//if you dont want to use the physic shape to test for touches but only want to use the rect of the sprite
//call this method with false
-(void)setUsePhysicsForTouches:(bool)val;

//Note: in order to make porting from ios to mac easy, left mouse events from mac are equivalent with touch events on ios

//selector needs to have this signature -(void) touchXXX:(LHTouchInfo*)info
//info will have all information regarding the touch (see API Documentation or top of this file)
//for generic touch on sprites with tag use the observers from LevelHelperLoader

//you must set swallow touches before you register for a touch event
//touch begin observer should always be registered
//touch moved and touch ended dont work without touch begin
-(void)registerTouchBeginObserver:(id)observer selector:(SEL)selector DEPRECATED_ATTRIBUTE;

-(void)registerTouchBeganObserver:(id)observer selector:(SEL)selector;
-(void)registerTouchMovedObserver:(id)observer selector:(SEL)selector;
-(void)registerTouchEndedObserver:(id)observer selector:(SEL)selector;
-(void)removeTouchObserver; //once removed it cannot be added back - (error in Cocos2d) - use -(void)setTouchedDisabled:(bool)val;


#ifdef __MAC_OS_X_VERSION_MAX_ALLOWED

//for left mouse events use the touch observers from above 
-(void)registerRightMouseDownObserver:(id)observer selector:(SEL)selector;
-(void)registerRightMouseDraggedObserver:(id)observer selector:(SEL)selector;
-(void)registerRightMouseUpObserver:(id)observer selector:(SEL)selector;
#endif

//CLASS METHODS
//------------------------------------------------------------------------------
#ifdef LH_USE_BOX2D
+(NSString*) uniqueNameForBody:(b2Body*)body;
+(LHSprite*) spriteForBody:(b2Body*)body;
+(int) tagForBody:(b2Body*)body;
#endif
+(bool) isLHSprite:(id)object;

//SORTING
//------------------------------------------------------------------------------
- (NSComparisonResult)sortAscending:(LHSprite *)other;
- (NSComparisonResult)sortDescending:(LHSprite *)other;

//COLLISION FILTERING
//------------------------------------------------------------------------------
#ifdef LH_USE_BOX2D
-(void)setCollisionFilterCategory:(int)category;
-(void)setCollisionFilterMask:(int)mask;
-(void)setCollisionFilterGroup:(int)group;

//TYPE CONVERSION
//------------------------------------------------------------------------------
-(void)makeDynamic;
-(void)makeStatic;
-(void)makeKinematic;
-(void)makeNoPhysics;

-(void)setSensor:(bool)val fixtureWithName:(NSString*)fixName; //makes only the fixture with this name a sensor
-(void)setSensor:(bool)val fixturesWithID:(int)fixID; //makes all the fixtures with the id sensors
-(void)setSensor:(bool)val; //makes the entire body a sensor

-(bool)hasContacts;
//this methods return NULL if no contacts are found
-(NSArray*)contactSprites;//will return only the LHSprites objects with which this sprite is in contact
-(NSArray*)contactBeziers;//will return only the LHBezier objects with which this sprite is in contact
//Note: even if contactSprites and/or contactBeziers return an empty array, the sprite might still be in contact
//with something else, like the physics boundaries or a box2d body created by your own code.
//Use hasContacts to see if the sprite is in contact with anything

//this will return the fixture of the other sprite that is in contact with the current sprite that has the specified tag
//if no fixture with the specified tag is in contact with current sprite it will return NULL
-(LHFixture*)lhFixtureOfContactingSpriteWithTag:(int)otherTag;

//this will return the fixture of the other sprite that is in contact with the current sprite that has the specified name
//if no fixture with the specified name is in contact with current sprite it will return NULL
-(LHFixture*)lhFixtureOfContactingSpriteWithName:(NSString*)name;

//this will return true if another sprite with tag is in contact with the current sprite
//and the fixture id of the other sprite is equal with otherFixtureID
-(bool) isInContactWithOtherSpriteOfTag:(int)otherTag
                        atFixtureWithID:(int)otherFixtureID;

//this will return true if another sprite with tag is in contact with the current sprite
//and the fixture name of the other sprite is equal with otherFixtureName
-(bool) isInContactWithOtherSpriteOfTag:(int)otherTag
                      atFixtureWithName:(NSString*)otherFixtureName;

//this will return true if another sprite with tag is in contact with the current sprite
//and the fixture with id of the other sprite is in contact with the fixture with id (thisFixId) on the current sprite
-(bool) fixtureWithID:(int)thisFixId isInContactWithOtherSpriteOfTag:(int)otherTag
      atFixtureWithID:(int)otherFixtureID;

//this will return true if another sprite with tag is in contact with the current sprite
//and the fixture with name of the other sprite is in contact with the fixture with name (thisFixName) on the current sprite
-(bool) fixtureWithName:(NSString*)thisFixName isInContactWithOtherSpriteOfTag:(int)otherTag
      atFixtureWithName:(NSString*)otherFixtureName;

-(bool)fixtureWithID:(int)thisFixId isInContactWithOtherSpriteOfTag:(int)otherSpriteTag;

-(LHFixture*)lhFixtureInContactWithBezierOfTag:(int)otherBezierTag;

-(LHFixture*)lhFixtureInContactWithSpriteOfTag:(int)otherSpriteTag;

//EXAMPLE PROJECT FOR THIS METHODS AVAILABLE HERE
//http://www.gamedevhelper.com/tutorialsFiles/Cocos2d-CheckIsInContactMethods.zip
//check update function

//for bezier collision we cannot test for a fixture tag on the currect sprite because collisions with chain shapes
//in box2d is done based on aabb and it this will not give realisting simulation.
//you should enable aabb in your debug drawing. Even so - this will return true if the sprite is in the vecinity of the
//bezier (in its aabb) - it may not even touch the bezier - so this method is not to be trusted but added for convenince
-(bool)isInContactWithOtherBezierOfTag:(int)bezierTag;

#endif

@end	
