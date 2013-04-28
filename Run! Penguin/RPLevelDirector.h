//
//  RPLevelDirector.h
//  Run! Penguin
//
//  Created by Sean on 13-4-15.
//  RPLevelDirector is a singleton, which is in charge of level loading progress and
//  transition, sound effects, game music, touch dispatches, collision handling, game
//  objects' animations
//

#import <Foundation/Foundation.h>
#import "cocos2d.h"
#import "LevelHelperLoader.h"
#import "RPLevelTemplate.h"

@interface RPLevelDirector : NSObject <RPLeveLoadingProgress>
{
    //Level state
    BOOL _isLevelStatePausedManually;
    BOOL _isLevelStateSceneTransition;
    NSOperationQueue *_initNewSceneQueue;
    float _levelLoadingPercentage;
    NSMutableArray *_backgroundMusicList;
    NSMutableArray *_soundEffectList;
    BOOL _isGameSoundEnabled;
    BOOL _isGameMusicEnabled;
    CCScene *_currentScene;
    CCLayer *_currentLayer;
    LevelHelperLoader *_currentLHLoader;
}
@property (assign,nonatomic,readwrite) BOOL isLevelStatePausedManually;
@property (assign,nonatomic,readwrite) BOOL isLevelStateSceneTransition;
@property (retain,nonatomic,readwrite) NSOperationQueue *initNewSceneQueue;
@property (assign,nonatomic,readwrite) float levelLoadingPercentage;
@property (retain,nonatomic) NSMutableArray *backgroundMusicList;
@property (retain,nonatomic) NSMutableArray *soundEffectList;
@property (assign,nonatomic,readwrite) BOOL isGameSoundEnabled;
@property (assign,nonatomic,readwrite) BOOL isGameMusicEnabled;
@property (assign, nonatomic,readwrite) CCScene *currentScene;
@property (assign, nonatomic,readwrite) CCLayer *currentLayer;
@property (assign, nonatomic,readwrite) LevelHelperLoader *currentLoader;
+ (RPLevelDirector *)sharedLevelDirector;
//Init map level
- (void)initMapLevel:(NSString *)levelName;
//Replace scene
- (void)replaceScene:(CCScene *)newScene;
//RPLevelLoadingProgress Protocol method
- (void)loadingProgress:(NSNumber *)progress;
//Sounds
- (void)preloadSoundEffects;
//File name without extention suffix
- (void)preloadBackgroundMusic:(NSString *)fileName;
- (void)randomlyPlayLevelBackgroundMusic;
- (void)playBackgroundMusic:(NSString *)fileName repeat:(BOOL)repeat;
- (void)stopBackgroundMusic;
- (void)pauseBackgroundMusic;
- (void)resumeBackgroundMusic;
- (void)playSoundEffect:(NSString *)fileName;
- (void)setBackgroundMusicListener:(id)listener selector:(SEL)selector;
//Prepare animations
- (void)prepareAnimations;
- (void)prepareAnimation:(NSString *)animationName
              fromSHFile:(NSString *)SHFileName
               forSprite:(LHSprite *)sprite;
- (void)playAnimation:(NSString *)animationName
           fromSHFile:(NSString *)SHFileName
            forSprite:(LHSprite *)sprite;
@end
