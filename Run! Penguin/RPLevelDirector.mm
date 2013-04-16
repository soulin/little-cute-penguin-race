//
//  RPLevelDirector.m
//  Run! Penguin
//
//  Created by Sean on 13-4-15.
//
//
#pragma mark - Macro
//Volume
#define BACKGROUND_MUSIC_VOLUME 0.4f
///////////////////////////////////////////////////////////////////

#import "RPLevelDirector.h"
#import "SimpleAudioEngine.h"
#import "RPGameHelper.h"
#import "RPGameManager.h"
#import "RPLevelTemplate.h"

@interface RPLevelDirector (Private)
- (void)registerWithLHTouchMgr;
- (void) handlePanFrom:(UIPanGestureRecognizer *)recognizer;
@end

@implementation RPLevelDirector
@synthesize initNewSceneQueue = _initNewSceneQueue;
@synthesize levelLoadingPercentage = _levelLoadingPercentage;
@synthesize backgroundMusicList = _backgroundMusicList;
@synthesize soundEffectList = _soundEffectList;
@synthesize isGameSoundEnabled = _isGameSoundEnabled;
@synthesize isGameMusicEnabled = _isGameMusicEnabled;
@synthesize currentScene = _currentScene;
@synthesize currentLayer = _currentLayer;
@synthesize currentLoader = _currentLHLoader;
#pragma mark - Sigleton initialization methods
+ (RPLevelDirector *)sharedLevelDirector
{
    static RPLevelDirector *levelDirector = nil;
    if (levelDirector == nil)
    {
        levelDirector = [[RPLevelDirector alloc] init];
    }
    return levelDirector;
}
///////////////////////////////////////////////////////////////////
- (id)init
{
    self = [super init];
    self.initNewSceneQueue = [[[NSOperationQueue alloc] init] autorelease];
    [[self initNewSceneQueue] setMaxConcurrentOperationCount:1];
    //Listen to the notification to update loading progress accordingly
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(shouldUpdateNewSceneLoadingProgressPercentage) name:RPLevelLoadingProgressPercentageChanged object:nil];
    //Listen to the notification to change game state
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(newSceneIsInitializing) name:RPNewSceneIsInitializing object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(newSceneDidBecomeCurrentScene:) name:RPNewSceneHasBecomeCurrentScene object:nil];
    _isGameSoundEnabled = YES;
    _isGameMusicEnabled = YES;
    _levelLoadingPercentage = 0;
    [self registerWithLHTouchMgr];
    self.backgroundMusicList = nil;
    self.soundEffectList = nil;
    //Background music listener
    [self setBackgroundMusicListener:self selector:@selector(backgroundMusicDidFinishPlay)];
    [self preloadSoundEffects];
    return self;
}
#pragma mark - Sound effect
- (void)backgroundMusicDidFinishPlay
{
    if ([[RPLevelDirector sharedLevelDirector] isGameMusicEnabled])
    {
        [self performSelector:@selector(randomlyPlayLevelBackgroundMusic) withObject:Nil afterDelay:15];
    }
}
//////////////////////////////////////////////////////////////////////////
- (void)preloadSoundEffects
{
    if ([self soundEffectList] == Nil)
    {
        self.soundEffectList = [NSMutableArray arrayWithObjects:
                                @"button_down.m4a",
                                @"button_up.m4a",
                                @"checkout_done.m4a",
                                @"difficulty_up.m4a",
                                @"pickup_goods.m4a",
                                @"pickup_bonus.m4a",
                                @"achievement_unlock.m4a",
                                @"buzz.m4a",
                                @"level_complete.m4a",
                                @"time_out.m4a",
                                @"tick.m4a",
                                nil];
    }
    for (NSString *fileName in self.soundEffectList)
    {
        if (fileName)
        {
            [[SimpleAudioEngine sharedEngine] preloadEffect:fileName];
        }
        else
        {
            NSLog(@"%@ file name can not be NULL", NSStringFromSelector(_cmd));
        }
    }
}
///////////////////////////////////////////////////////////////////
- (void)preloadBackgroundMusic:(NSString *)fileName
{
    if (fileName)
    {
        NSLog(@"Preloading background music %@", fileName);
        fileName = [fileName stringByAppendingString:@".m4a"];
        [[SimpleAudioEngine sharedEngine] preloadBackgroundMusic:fileName];
        [[SimpleAudioEngine sharedEngine] setBackgroundMusicVolume:BACKGROUND_MUSIC_VOLUME];
    }
    else
    {
        NSLog(@"%@ file name can not be NULL", NSStringFromSelector(_cmd));
    }
}
///////////////////////////////////////////////////////////////////
- (void)randomlyPlayLevelBackgroundMusic
{
    if (![[RPLevelDirector sharedLevelDirector] isGameMusicEnabled])
    {
        return;
    }
    if ([self backgroundMusicList] == Nil)
    {
        self.backgroundMusicList = [NSMutableArray arrayWithObjects:
                                    @"Buddy.m4a",
                                    @"Havana.m4a",
                                    @"Jazzy Downtempo.m4a",
                                    @"Park Bench.m4a",
                                    @"Piano Ballad.m4a",
                                    @"Sunrise.m4a",
                                    @"Bossa Lounger.m4a",
                                    @"Chaise Lounge.m4a",
                                    @"Curtain Call.m4a",
                                    @"Daydream.m4a",
                                    @"Fifth Avenue.m4a",
                                    @"Fireside.m4a",
                                    @"Gleaming.m4a",
                                    @"Greasy Wheels.m4a",
                                    @"Half Dome.m4a",
                                    @"Kickflip.m4a",
                                    @"Motocross.m4a",
                                    @"Offroad.m4a",
                                    @"Peach Cobber.m4a",
                                    @"Red Velvet.m4a",
                                    @"River Walk.m4a",
                                    @"Roadtrip.m4a",
                                    @"Roller Derby.m4a",
                                    @"Street.m4a",
                                    nil];
    }
    int count = [[self backgroundMusicList] count];
    if (count != 0)
    {
        int randomIndex = arc4random() % count;
        NSLog(@"Number %d background music is gonna play", randomIndex);
        [[SimpleAudioEngine sharedEngine] preloadBackgroundMusic:[[self backgroundMusicList] objectAtIndex:randomIndex]];
        [[SimpleAudioEngine sharedEngine] setBackgroundMusicVolume:BACKGROUND_MUSIC_VOLUME];
        [[SimpleAudioEngine sharedEngine] playBackgroundMusic:[[self backgroundMusicList] objectAtIndex:randomIndex] loop:NO];
    }
    else
    {
        if ([self backgroundMusicList] == NULL)
        {
            NSLog(@"Background music list is empty");
        }
    }
}
///////////////////////////////////////////////////////////////////
- (void)playBackgroundMusic:(NSString *)fileName repeat:(BOOL)repeat
{
    if (![[RPLevelDirector sharedLevelDirector] isGameMusicEnabled])
    {
        return;
    }
    if (fileName)
    {
        NSLog(@"Playing background music %@", fileName);
        fileName = [fileName stringByAppendingString:@".m4a"];
        [[SimpleAudioEngine sharedEngine] playBackgroundMusic:fileName loop:repeat];
    }
    else
    {
        if (!fileName)
        {
            NSLog(@"%@ file name can not be NULL", NSStringFromSelector(_cmd));
        }
    }
}
///////////////////////////////////////////////////////////////////
- (void)stopBackgroundMusic
{
    [[SimpleAudioEngine sharedEngine] stopBackgroundMusic];
    NSLog(@"%@ has stopped background music", NSStringFromClass([self class]));
}
///////////////////////////////////////////////////////////////////
- (void)pauseBackgroundMusic
{
    if ([[CDAudioManager sharedManager] isBackgroundMusicPlaying])
    {
        [[CDAudioManager sharedManager] pauseBackgroundMusic];
        NSLog(@"%@ has paused background music", NSStringFromClass([self class]));
    }
    
}
///////////////////////////////////////////////////////////////////
- (void)resumeBackgroundMusic
{
    if (![[RPLevelDirector sharedLevelDirector] isGameMusicEnabled])
    {
        return;
    }
    if (![[CDAudioManager sharedManager] isBackgroundMusicPlaying])
    {
        [[CDAudioManager sharedManager] resumeBackgroundMusic];
        NSLog(@"%@ has resumed background music", NSStringFromClass([self class]));
    }
}
///////////////////////////////////////////////////////////////////
- (void)playSoundEffect:(NSString *)fileName
{
    if (![[RPLevelDirector sharedLevelDirector] isGameSoundEnabled])
    {
        return;
    }
    if (fileName)
    {
        NSLog(@"Playing sound %@",fileName);
        fileName = [fileName stringByAppendingString:@".m4a"];
        [[SimpleAudioEngine sharedEngine] playEffect:fileName];
    }
    else
    {
        NSLog(@"%@ fileName can not be NULL",NSStringFromSelector(_cmd));
    }
}
///////////////////////////////////////////////////////////////////
- (void)setBackgroundMusicListener:(id)listener selector:(SEL)selector
{
    [[CDAudioManager sharedManager] setBackgroundMusicCompletionListener:listener selector:selector];
}
///////////////////////////////////////////////////////////////////
#pragma mark - CSLevelLoadingProgress trigger
-(void)loadingProgress:(NSNumber*)progress
{
	[self setLevelLoadingPercentage:[progress floatValue] * 50] ;
    NSLog(@"Loading %f", [self levelLoadingPercentage]);
    [[NSNotificationCenter defaultCenter] postNotificationName:RPLevelLoadingProgressPercentageChanged object:nil];
}
///////////////////////////////////////////////////////////////////
#pragma mark - Notification observer
- (void)authenticationDidChanged:(NSNotification *)notification
{
    NSLog(@"Received CSGameCenterLocalPlayerAuthenticationChanged notification");
    [[RPGameManager sharedGameManager] authenticateLocalPlayer];
}
- (void)shouldUpdateNewSceneLoadingProgressPercentage
{
    [(RPLevelTemplate *)[self currentLayer] updateNewSceneProgress];
}
///////////////////////////////////////////////////////////////////
- (void)newSceneIsInitializing
{
    [[RPGameManager sharedGameManager] setIsGameStateSceneTransition:YES];
}
///////////////////////////////////////////////////////////////////
- (void)newSceneDidBecomeCurrentScene:(NSNotification *)notification
{
    //Enable touch even after new scene init completely
    [[CCTouchDispatcher sharedDispatcher] setDispatchEvents:YES];
    CCScene *scene = [notification object];
    [[RPGameManager sharedGameManager] setIsGameStateSceneTransition:NO];
    [self setCurrentScene:scene];
    CCLayer *layer = [[scene children] objectAtIndex:0];
    [self setCurrentLayer:layer];
    LevelHelperLoader *loader = [(RPLevelTemplate *)layer loader];
    [self setCurrentLoader:loader];
}
///////////////////////////////////////////////////////////////////
#pragma mark - Scene transitions
- (void)replaceScene:(CCScene *)newScene
{
    CCLayer *currentLevel = [self currentLayer];
    NSLog(@"New scene: %@ initialized completed", [newScene description]);
    [[NSNotificationCenter defaultCenter] removeObserver:currentLevel name:LHAnimationHasEndedNotification object:nil];
    //Resume here can fix new scene transition problem
    [[CCDirector sharedDirector] resume];
    [[CCDirector sharedDirector] replaceScene:newScene];
    //New scene is running, post notification
    [[NSNotificationCenter defaultCenter] postNotificationName:RPNewSceneHasBecomeCurrentScene object:newScene];
}
///////////////////////////////////////////////////////////////////
#pragma mark - Private
- (void)registerWithLHTouchMgr
{
//    LHTouchMgr *touchManager = [LHTouchMgr sharedInstance];
//    [touchManager registerTouchBeganObserver:self
//                                    selector:@selector(touchBegan:)
//                                      forTag:TAG_PRELUDE];
//    [touchManager registerTouchEndedObserver:self
//                                    selector:@selector(touchEnded:)
//                                      forTag:TAG_PRELUDE];
//    [touchManager registerTouchBeganObserver:self
//                                    selector:@selector(touchBegan:)
//                                      forTag:TAG_GOODS];
//    [touchManager registerTouchEndedObserver:self
//                                    selector:@selector(touchEnded:)
//                                      forTag:TAG_GOODS];
//    [touchManager registerTouchBeganObserver:self
//                                    selector:@selector(touchBegan:)
//                                      forTag:TAG_BUTTON];
//    [touchManager registerTouchEndedObserver:self
//                                    selector:@selector(touchEnded:)
//                                      forTag:TAG_BUTTON];
//    [touchManager registerTouchBeganObserver:self
//                                    selector:@selector(touchBegan:)
//                                      forTag:TAG_BONUS];
//    [touchManager registerTouchEndedObserver:self
//                                    selector:@selector(touchEnded:)
//                                      forTag:TAG_BONUS];
//    //////////////////////////////////////////////////////////////////////////////////
//    [touchManager setPriority:1 forTouchesOfTag:TAG_PRELUDE];
//    [touchManager setPriority:2 forTouchesOfTag:TAG_GOODS];
//    [touchManager setPriority:3 forTouchesOfTag:TAG_BONUS];
//    
//    [touchManager swallowTouchesForTag:TAG_PRELUDE];
//    [touchManager swallowTouchesForTag:TAG_GOODS];
//    [touchManager swallowTouchesForTag:TAG_BONUS];
//    //////////////////////////////////////////////////////////////////////////////////
}
//////////////////////////////////////////////////////////////////////////
#pragma mark - Touch handler
- (void)touchBegan:(LHTouchInfo *)info
{
    RPGameManager *gameManager = [RPGameManager sharedGameManager];
    CCLayer *layer = [self currentLayer];
    if (![gameManager isGameStateSceneTransition])
    {
        //Implement touch began logic here
        int tag = info.sprite.tag;
        if ([layer respondsToSelector:@selector(touchBegan:onTag:)])
        {
            [(RPLevelTemplate *)layer touchBegan:info onTag:tag];
        }
        else
        {
            NSLog(@"%@%@ has not implement touch handler methods", SELECTOR_STRING, [layer description]);
        }
    }
    else
    {
        NSLog(@"%@New scene is in transition", SELECTOR_STRING);
    }
}
- (void)touchEnded:(LHTouchInfo *)info
{
    RPGameManager *gameManager = [RPGameManager sharedGameManager];
    CCLayer *layer = [self currentLayer];
    if (![gameManager isGameStateSceneTransition])
    {
        //Implement touch ended logic here
        int tag = info.sprite.tag;
        if ([layer respondsToSelector:@selector(touchEnded:onTag:)])
        {
            [(RPLevelTemplate *)layer touchEnded:info onTag:tag];
        }
        else
        {
            NSLog(@"%@%@ has not implement touch handler methods", SELECTOR_STRING, [layer description]);
        }
    }
    else
    {
        NSLog(@"%@New scene is in transition", SELECTOR_STRING);
    }
}
- (void) handlePanFrom:(UIPanGestureRecognizer *)recognizer
{
    RPGameManager *gameManager = [RPGameManager sharedGameManager];
    CCLayer *layer = [self currentLayer];
    if (![gameManager isGameStateSceneTransition])
    {
        //Implement pan gesture logic here
        if ([layer respondsToSelector:@selector(handlePanFrom:)])
        {
            [(RPLevelTemplate *)layer handlePanFrom:recognizer];
        }
    }
}

@end
