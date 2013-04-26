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
//////////////////////////////////////////////////////////////
//RPGameState
typedef enum
{
    kRPGameStateUnavailable = 0,
    kRPGameStateWaitingForMatch,
    kRPGameStateWaitingForBestServer,
    kRPGameStateWaitingForStart,
    kRPGameStateActive,
    kRPGameStateDone
} RPGameState;
//////////////////////////////////////////////////////////////
//RPGameMode
typedef enum
{
    KRPGameModeInvalid = 0,
    kRPGameModeSingle,
    kRPGameModeMultiple,
} RPGameMode;
//////////////////////////////////////////////////////////////
//RPGameMessageType
typedef enum
{
    kRPGameMessageTypeInvalid = 0,
    kRPGameMessageTypeBestServer,
    kRPGameMessageTypeGameBegin,
    kRPGameMessageTypePlayerMove,
    kRPGameMessageTypeGameOver
} RPGameMessageType;
//////////////////////////////////////////////////////////////
//Message type structure
typedef struct
{
    NSString *playerID;
} RPGameMessageBestServer;
typedef struct
{
    //Dictionary of key : value like playerID : positionMoveTo
    NSDictionary *playerPositions;
} RPGameMessagePlayerMove;
typedef struct
{
    BOOL begin;
} RPGameMessageGameBegin;
typedef struct
{
    BOOL gameOver;
    NSString *winnerPlayerID;
} RPGameMessageGameOver;
//////////////////////////////////////////////////////////////
//Message
typedef struct
{
    RPGameMessageType messageType;
    RPGameMessageBestServer bestServer;
    RPGameMessageGameBegin shouldBegin;
    RPGameMessagePlayerMove moveTo;
    RPGameMessageGameOver shouldEnd;
} RPGameMessage;
//////////////////////////////////////////////////////////////
//RPGameManager
@interface RPGameManager : NSObject <GKLeaderboardViewControllerDelegate,GKMatchmakerViewControllerDelegate, GKMatchDelegate>
{
    //RootViewController
    UIViewController *_rootViewController;
    //GKMatch
    GKMatch *_match;
    //Best server
    NSString *_bestServer;
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
- (BOOL)amIBestServer;
- (void)initMatchWithRequest:(GKMatchRequest *)request;
- (void)sendMessage:(RPGameMessage)message toPlayers:(NSArray *)players;
- (void)disconnectFromMatch;
- (void)beginGame;
- (void)endGame;
@end
