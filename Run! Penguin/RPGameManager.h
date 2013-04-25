//
//  RPGameManager.h
//  Run! Penguin
//
//  Created by Sean on 13-4-15.
//  RPGameManager is a singleton, which is in charge of game state change in both of
//  single player mode and multiplayer mode, Game Center related events
//

#import <Foundation/Foundation.h>
#import <GameKit/GameKit.h>
#import "RPGameHelper.h"

//RPGameState
typedef enum
{
    kRPGameStateUnavailable = 0,
    kRPGameStateWaitingForMatch,
    kRPGameStateWaitingForRandomNumber,
    kRPGameStateWaitingForStart,
    kRPGameStateActive,
    kRPGameStateDone
} RPGameState;
//RPGameMode
typedef enum
{
    KRPGameModeInvalid = 0,
    kRPGameModeSingle,
    kRPGameModeMultiple,
} RPGameMode;
//RPGameManager
@interface RPGameManager : NSObject <GKLeaderboardViewControllerDelegate,GKMatchmakerViewControllerDelegate, GKMatchDelegate>
{
    //RootViewController
    UIViewController *_rootViewController;
    //GKMatch
    GKMatch *_match;
    //Players to invite
    NSMutableArray *_playersToInvite;
    //Game state identifier
    RPGameState _gameState;
    //Game mode identifier
    RPGameMode _gameMode;
    //GKMath
    
}
@property (retain,nonatomic,readwrite) GKMatch *match;
@property (assign,nonatomic,readwrite) RPGameState gameState;
@property (assign,nonatomic,readwrite) RPGameMode gameMode;

+ (RPGameManager *)sharedGameManager;

//Game center handler
+ (BOOL)isGameCenterAvailable;
- (void)authenticateLocalPlayer;
- (void)uploadLeaderBoard;
- (void)reportAchievementIdentifier: (NSString*) identifier percentComplete:
(float) percent;
- (void)completeMultipleAchievements;
- (void)loadAchievements;
- (void)showVIPLeaderBoard;
//Match handler
- (void)chooseBestServer;
- (void)initMatchWithRequest:(GKMatchRequest *)request;
- (void)disconnectFromMatch;
@end
