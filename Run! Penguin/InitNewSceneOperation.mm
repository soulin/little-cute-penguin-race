//
//  InitNewSceneOperation.m
//  CrazyShopping
//
//  Created by Sean on 13-3-28.
//
//
/////////////////////////////////////////////////////////////////////////////
#import "InitNewSceneOperation.h"
#import "AppDelegate.h"
#import "RPGameManager.h"
#import "RPLevelDirector.h"
#import "cocos2d.h"
#import "Level_1.h"
/////////////////////////////////////////////////////////////////////////////
#pragma mark - Macro
#define SELECTOR_STRING [NSString stringWithFormat:@"[%@ %@]: ",NSStringFromClass([self class]), NSStringFromSelector(_cmd)]
/////////////////////////////////////////////////////////////////////////////
#pragma mark - Private
@interface InitNewSceneOperation (Private)
+ (CCScene *)scene;
@end
/////////////////////////////////////////////////////////////////////////////
#pragma mark - Implemetation
@implementation InitNewSceneOperation
/////////////////////////////////////////////////////////////////////////////
#pragma mark - Memory management
- (id)initWithString:(NSString *)newSceneClassString
{
    if (self = [super init])
    {
        _newSceneClassString = [newSceneClassString copy];
    }
    return self;
}
/////////////////////////////////////////////////////////////////////////////
- (void)dealloc
{
    [_newSceneClassString release], _newSceneClassString = nil;
    [super dealloc];
}
/////////////////////////////////////////////////////////////////////////////
- (void)main
{
    if (_newSceneClassString)
    {
        NSAutoreleasePool *autoreleasepool = [[NSAutoreleasePool alloc] init];
        //Create a shared opengl context so this texture can be shared with main context
        EAGLContext *k_context = [[[EAGLContext alloc]
                                   initWithAPI:kEAGLRenderingAPIOpenGLES1
                                   sharegroup:[[[[CCDirector sharedDirector] openGLView] context] sharegroup]] autorelease];
        [EAGLContext setCurrentContext:k_context];
        NSLog(@"New scene is %@", _newSceneClassString);
        //Disable touch event befor init new scene
        [[CCTouchDispatcher sharedDispatcher] setDispatchEvents:NO];
        CCScene *newScene = [NSClassFromString(_newSceneClassString) scene];
        if (newScene)
        {
            [[RPLevelDirector sharedLevelDirector] performSelectorOnMainThread:@selector(replaceScene:) withObject:newScene waitUntilDone:YES];
        }
        /////////////////////////////////////////////////////////////////////////////
        else
        {
            NSLog(@"%@invailid newScene", SELECTOR_STRING);
        }
        [autoreleasepool release];
    }
    else
    {
        NSLog(@"%@invailid _newSceneClassString", SELECTOR_STRING);
    }
}
/////////////////////////////////////////////////////////////////////////////
@end
