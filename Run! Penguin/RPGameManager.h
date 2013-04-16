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

@interface RPGameManager : NSObject <GKLeaderboardViewControllerDelegate>
{
    BOOL _isGamePausedManually;
    BOOL _isGameStateSceneTransition;
}
@property (assign,nonatomic,readwrite) BOOL isGamePausedManually;
@property (assign,nonatomic,readwrite) BOOL isGameStateSceneTransition;

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

@end
