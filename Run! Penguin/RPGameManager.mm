//
//  RPGameManager.m
//  Run! Penguin
//
//  Created by Sean on 13-4-15.
//
//

#import "RPGameManager.h"

@implementation RPGameManager
@synthesize isGamePausedManually = _isGamePausedManually;
@synthesize isGameStateSceneTransition = _isGameStateSceneTransition;

#pragma mark - Sigleton initialization methods
+ (RPGameManager *)sharedGameManager
{
    static RPGameManager *gameManager = nil;
    if (gameManager == nil)
    {
        gameManager = [[RPGameManager alloc] init];
    }
    return gameManager;
}
///////////////////////////////////////////////////////////////////
- (id)init
{
    self = [super init];
    //Listen to the notification to handle player change event
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(authenticationDidChanged:) name:RPGameCenterLocalPlayerAuthenticationChanged object:nil];
    return self;
}
#pragma mark - GameCenter methods
+ (BOOL) isGameCenterAvailable
{
	// check for presence of GKLocalPlayer API
	Class gcClass = (NSClassFromString(@"GKLocalPlayer"));
	
	// check if the device is running iOS 4.1 or later
	NSString *reqSysVer = @"4.1";
	NSString *currSysVer = [[UIDevice currentDevice] systemVersion];
	BOOL osVersionSupported = ([currSysVer compare:reqSysVer options:NSNumericSearch] != NSOrderedAscending);
	
	return (gcClass && osVersionSupported);
}
///////////////////////////////////////////////////////////////////
- (void) authenticateLocalPlayer
{
    if ([RPGameManager isGameCenterAvailable])
    {
        GKLocalPlayer *localPlayer = [GKLocalPlayer localPlayer];
        UIViewController *rootViewController = [UIApplication sharedApplication].delegate.window.rootViewController;
        localPlayer.authenticateHandler = ^(UIViewController *viewController, NSError *error)
        {
            if (viewController != nil)
            {
                //Present GameCenter User Login Interface
                NSLog(@"%@:Presenting GameCenter User Interface", SELECTOR_STRING);
                [rootViewController presentViewController:viewController animated:YES completion:NULL];
            }
            else if (localPlayer.isAuthenticated)
            {
                //Local player is authenticated
            }
            else
            {
                //No game center interface and no authenticated local player 
            }
        };
    }
    else
    {
        NSLog(@"Game Center is unavailable on this device");
    }
}
///////////////////////////////////////////////////////////////////
//Leader board delegate method
- (void)leaderboardViewControllerDidFinish:(GKLeaderboardViewController
                                            *)viewController
{
    UIViewController *rootViewController = [[[[UIApplication sharedApplication] delegate] window] rootViewController];
    [rootViewController dismissViewControllerAnimated:YES completion:nil];
}
///////////////////////////////////////////////////////////////////
- (void)reportScore:(int64_t)score forLeaderboardID:(NSString*)category
{
    GKScore *scoreReporter = [[GKScore alloc] initWithCategory:category];
    scoreReporter.value = score;
    scoreReporter.context = 0;
    [scoreReporter reportScoreWithCompletionHandler:^(NSError *error){
        // Do something interesting here.
        NSLog(@"Score has been uploaded to %@", category);
    }];
}
///////////////////////////////////////////////////////////////////
- (void) showLeaderboard: (NSString*) leaderboardID
{
    UIViewController *rootViewController = [[[[UIApplication sharedApplication] delegate] window] rootViewController];
    GKLeaderboardViewController *leaderboardController =
    [[GKLeaderboardViewController alloc] init];
    if (leaderboardController != nil)
    {
        leaderboardController.leaderboardDelegate = self;
        leaderboardController.timeScope = GKLeaderboardTimeScopeToday;
        leaderboardController.category = leaderboardID;
        [rootViewController presentViewController: leaderboardController animated: YES
                                       completion:nil];
    }
}
///////////////////////////////////////////////////////////////////
//Upload
- (void)uploadLeaderBoard
{
//    CSCustomer *currentCustomer = [[CSShopManager sharedShopManager] currentCustomer];
//    if (currentCustomer)
//    {
//        int64_t gemCount = (int64_t)[currentCustomer gemGained];
//        int64_t goodsCount = (int64_t)[currentCustomer goodsGained];
//        NSString *gemCategory = @"Level_1_GemCount";
//        NSString *goodsCategory = @"Level_1_GoodsCount";
//        [self reportScore:gemCount forLeaderboardID:gemCategory];
//        [self reportScore:goodsCount forLeaderboardID:goodsCategory];
//    }
//    else
//    {
//        NSLog(@"Can not upload to leader board, current customer is unvailid");
//    }
}
///////////////////////////////////////////////////////////////////
//Show VIP leader board
- (void)showVIPLeaderBoard
{
//    if ([[CSShopManager sharedShopManager] currentCustomer])
//    {
//        NSString *category = @"Level_1_GoodsCount";
//        [self showLeaderboard:category];
//    }
//    else
//    {
//        NSLog(@"Can not show VIP leader board, current customer is unvailid");
//    }
}
///////////////////////////////////////////////////////////////////
- (void) reportAchievementIdentifier: (NSString*) identifier percentComplete:
(float) percent
{
//    GKAchievement *achievement = [[GKAchievement alloc] initWithIdentifier:
//                                  identifier];
//    if (achievement)
//    {
//        achievement.percentComplete = percent;
//        //Show banner
//        achievement.showsCompletionBanner = YES;
//        [achievement reportAchievementWithCompletionHandler:^(NSError *error)
//         {
//             if (error == nil)
//             {
//                 [[CSShopManager sharedShopManager] playSoundEffect:@"achievement_unlock"];
//                 NSLog(@"%@Report Achievement %@ success!",SELECTOR_STRING,identifier);
//             }
//             else
//             {
//                 NSLog(@"Error in reporting achievements: %@", error);
//             }
//         }];
//    }
}
///////////////////////////////////////////////////////////////////
- (void)completeMultipleAchievements
{
    GKAchievement *achievement1 = [[GKAchievement alloc] initWithIdentifier:
                                   @"DefeatedFinalBoss"];
    GKAchievement *achievement2 = [[GKAchievement alloc] initWithIdentifier:
                                   @"FinishedTheGame"];
    GKAchievement *achievement3 = [[GKAchievement alloc] initWithIdentifier:
                                   @"PlayerIsAwesome"];
    achievement1.percentComplete = 100.0;
    achievement2.percentComplete = 100.0;
    achievement3.percentComplete = 100.0;
    NSArray *achievementsToComplete = [NSArray
                                       arrayWithObjects:achievement1,achievement2,achievement3, nil];
    [GKAchievement reportAchievements: achievementsToComplete
                withCompletionHandler:^(NSError *error)
     {
         if (error != nil)
         {
             NSLog(@"Error in reporting achievements: %@", error);
         }
     }];
}
///////////////////////////////////////////////////////////////////
- (void)loadAchievements
{
    [GKAchievement loadAchievementsWithCompletionHandler:^(NSArray *achievements,
                                                           NSError *error)
     {
         if (error != nil)
         {
             // Handle the error.
         }
         if (achievements != nil)
         {
             // Process the array of achievements.
         }
     }];
}
///////////////////////////////////////////////////////////////////
#pragma mark - Notification observer
- (void)authenticationDidChanged:(NSNotification *)notification
{
    NSLog(@"Received CSGameCenterLocalPlayerAuthenticationChanged notification");
    [self authenticateLocalPlayer];
}
@end
