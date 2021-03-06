//
//  RPGameManager.m
//  Run! Penguin
//
//  Created by Sean on 13-4-15.
//
//

#import "RPGameManager.h"
#import "RPLevelDirector.h"

@interface RPGameManager (Private)
//Set up client playerSprite dictionary
- (void)setupClientPlayerSprite;
//Game logic methods
- (void)chooseBestServer;
- (void)disconnectFromMatch;
- (void)beginGame;
- (void)endGame;
@end
@implementation RPGameManager
@synthesize match = _match;
@synthesize matchRequest = _matchRequest;
@synthesize gameState = _gameState;
@synthesize gameMode = _gameMode;

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
    _rootViewController = [[[[UIApplication sharedApplication] delegate] window] rootViewController];
    _levelDirector = [RPLevelDirector sharedLevelDirector];
    _match = nil;
    _matchRequest = nil;
    self.gameState = kRPGameStateWaitingForMatch;
    self.gameMode = kRPGameModeSingle;
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
                //Installing an invitation handler
                [GKMatchmaker sharedMatchmaker].inviteHandler = ^(GKInvite *acceptedInvite, NSArray *playersToInvite)
                {
                    // Insert game-specific code here to clean up any game in progress.
                    if (acceptedInvite)
                    {
                        GKMatchmakerViewController *mmvc = [[GKMatchmakerViewController alloc] initWithInvite:acceptedInvite];
                        mmvc.matchmakerDelegate = self;
                        if (_rootViewController)
                        {
                            [_rootViewController presentViewController:mmvc animated:YES completion:nil];
                        }
                    }
                    else if (playersToInvite)
                    {
                        GKMatchRequest *request = [[GKMatchRequest alloc] init];
                        request.minPlayers = kMinPlayerCountModeMultiple;
                        request.maxPlayers = kMaxPlayerCountModeMultiple;
                        request.playersToInvite = playersToInvite;
                        GKMatchmakerViewController *mmvc = [[GKMatchmakerViewController alloc] initWithMatchRequest:request];
                        mmvc.matchmakerDelegate = self;
                        if (_rootViewController)
                        {
                            [_rootViewController presentViewController:mmvc animated:YES completion:nil];
                        }
                    }
                };
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
#pragma mark - Private methods
- (void)setupClientPlayerSprite
{
    //Set up client playerSprite here
    //Through 2 enumeration blocks
    [[_levelDirector currentLayer] setPlayerSprite:nil];
    __block NSMutableDictionary *playerSpriteTemp = [NSMutableDictionary dictionaryWithCapacity:4];
    [[[_levelDirector currentLayer] spritesArray] enumerateObjectsUsingBlock:^(LHSprite *sprite, NSUInteger idx, BOOL *stop1)
     {
         __block Player *player = [sprite userInfo];
         [[[_levelDirector currentLayer] playerSpriteIndex] enumerateKeysAndObjectsUsingBlock:^(NSString *playerID, NSNumber *index, BOOL *stop2)
          {
              if ((int)[player index] == [index intValue])
              {
                  [playerSpriteTemp setObject:sprite forKey:playerID];
                  *stop2 = YES;
              }
          }];
     }];
    [[_levelDirector currentLayer] setPlayerSprite:(NSDictionary *)playerSpriteTemp];
}
///////////////////////////////////////////////////////////////////
- (void)chooseBestServer
{
    [self.match chooseBestHostPlayerWithCompletionHandler:^(NSString *playerID)
    {
        if (playerID)
        {
            //Choose the best server here
            if (_bestServer)
            {
                _bestServer = nil;
            }
            _bestServer = [playerID copy];
            [self setGameState:kRPGameStateWaitingForStart];
            [self beginGame];
        }
    }];
}
///////////////////////////////////////////////////////////////////
- (BOOL)amIBestServer
{
    GKLocalPlayer *localPlayer = [GKLocalPlayer localPlayer];
    //If I am the best server
    if ([[localPlayer playerID] isEqualToString:_bestServer])
    {
        return YES;
    }
    return NO;
}
///////////////////////////////////////////////////////////////////
- (void)initMatchWithRequest:(GKMatchRequest *)request
{
    if ([self gameMode] != kRPGameModeMultiple)
    {
        NSLog(@"%@MultiPlayer mode is not supported", SELECTOR_STRING);
        return;
    }
    //Set game state to kRPGameStateWaitingForMatch
    self.gameState = kRPGameStateWaitingForMatch;
    GKMatchmakerViewController *mmvc = [[GKMatchmakerViewController alloc]
                                        initWithMatchRequest:request];
    mmvc.matchmakerDelegate = self;
    [_rootViewController presentViewController:mmvc animated:YES completion:nil];
    //Add players to existing match if we have one
    if ([self match])
    {
        [mmvc addPlayersToMatch:self.match];
    }
}
///////////////////////////////////////////////////////////////////
- (void)sendMessage:(RPGameMessage)message toPlayers:(NSArray *)players
{
    if ([self match])
    {
        NSData *data = [NSData dataWithBytes:&message length:sizeof(message)];
        NSError *error;
        [[self match] sendData:data toPlayers:players withDataMode:GKMatchSendDataReliable error:&error];
    }
}
///////////////////////////////////////////////////////////////////
- (void)disconnectFromMatch
{
    if (!self.match)
    {
        return;
    }
    [[self match] disconnect];
}
//Begin
- (void)beginGame
{
    if ([self gameState] == kRPGameStateWaitingForStart)
    {
        RPGameMessage message;
        message.messageType = kRPGameMessageTypeGameBegin;
        message.shouldBegin.begin = YES;
        NSArray *server = [NSArray arrayWithObject:_bestServer];
        //If I am the best server
        if ([self amIBestServer])
        {
            //Notify the other players to start game
            [self sendMessage:message toPlayers:self.match.playerIDs];
        }
        else
        {
            //Notify the server I am ready to start
            [self sendMessage:message toPlayers:server];
        }
    }
}
///////////////////////////////////////////////////////////////////
- (void)endGame
{
    //Disconnect
    [self disconnectFromMatch];
    //Clear cache
    self.match = nil;
    _bestServer = nil;
    //Set game state to kRPGameStateDone
    [self setGameState:kRPGameStateDone];
}
///////////////////////////////////////////////////////////////////
#pragma mark - SetGameState
- (void)setGameState:(RPGameState)gameState
{
    switch (gameState)
    {
        case kRPGameStateWaitingForMatch:
        {
            _gameState = kRPGameStateWaitingForMatch;
            NSLog(@"Game state is: Waiting for match");
        }
            break;
        case kRPGameStateWaitingForBestServer:
        {
            _gameState = kRPGameStateWaitingForBestServer;
            NSLog(@"Game state is: Waiting for best server");
        }
            break;
        case kRPGameStateWaitingForDesignatedSprite:
        {
            _gameState = kRPGameStateWaitingForDesignatedSprite;
            NSLog(@"Game state is: Waiting for designated sprite");
        }
            break;
        case kRPGameStateActive:
        {
            _gameState = kRPGameStateActive;
            NSLog(@"Game state is: Active");
        }
            break;
        case kRPGameStateDone:
        {
            _gameState = kRPGameStateDone;
            NSLog(@"Game state is: Done");
        }
            break;
        default:
            break;
    }
}
///////////////////////////////////////////////////////////////////
#pragma mark - Notification observer
- (void)authenticationDidChanged:(NSNotification *)notification
{
    NSLog(@"Received CSGameCenterLocalPlayerAuthenticationChanged notification");
    [self authenticateLocalPlayer];
}
///////////////////////////////////////////////////////////////////
#pragma mark - GKMatchmakerViewControllerDelegate
//User cancel match finding
- (void)matchmakerViewControllerWasCancelled:(GKMatchmakerViewController *)viewController
{
    if (_rootViewController)
    {
        [_rootViewController dismissViewControllerAnimated:YES completion:nil];
    }
}
///////////////////////////////////////////////////////////////////
//Match finding failed
- (void)matchmakerViewController:(GKMatchmakerViewController *)viewController didFailWithError:(NSError *)error
{
    if (_rootViewController)
    {
        [_rootViewController dismissViewControllerAnimated:YES completion:nil];
    }
    NSLog(@"%@Error finding match: %@", SELECTOR_STRING, error.localizedDescription);
}
///////////////////////////////////////////////////////////////////
//Called when a peer-to-peer match is found
- (void)matchmakerViewController:(GKMatchmakerViewController *)viewController didFindMatch:(GKMatch *)match
{
    if (_rootViewController)
    {
        [_rootViewController dismissViewControllerAnimated:YES completion:nil];
    }
    self.match = match;
    match.delegate = self;
    if (self.gameState == kRPGameStateWaitingForMatch && match.expectedPlayerCount == 0)
    {
        [self setGameState:kRPGameStateWaitingForBestServer];
        [self chooseBestServer];
    }
}
///////////////////////////////////////////////////////////////////
#pragma mark GKMatchDelegate 
// The match received data sent from the player
- (void)match:(GKMatch *)match didReceiveData:(NSData *)data fromPlayer:(NSString                                                                         *)playerID
{
    if (self.match != match)
    {
        return;
    }
    //Handle the data here
    RPGameMessage *message = (RPGameMessage *)[data bytes];
    ///////////////////////////////////////////////////////////////////
    switch (message->messageType)
    {
        ///////////////////////////////////////////////////////////////////
        case kRPGameMessageTypeGameBegin:
        {
            if (![self amIBestServer] && ![playerID isEqualToString:_bestServer])
            {
                NSLog(@"%@Invalid message source", SELECTOR_STRING);
                return;
            }
            //Handle game start here
            if ([self gameState] == kRPGameStateWaitingForStart)
            {
                [self setGameState:kRPGameStateWaitingForRandomMap];
                //Server should init a random map
                if ([self amIBestServer])
                {
                    [self setGameState:kRPGameStateWaitingForRandomMap];
                    NSString *randomMap = [_levelDirector initRandomMapLevelForMulitplayerMode];
                    RPGameMessage message;
                    message.messageType = kRPGameMessageTypeRandomMap;
                    message.map.mapName = randomMap;
                    [self sendMessage:message toPlayers:self.match.playerIDs];
                    //Set game state to kRPGameStateActive
                    [self setGameState:kRPGameStateActive];
                }
            }
        }
            break;
        ///////////////////////////////////////////////////////////////////    
        case kRPGameMessageTypeRandomMap:
        {
            if (![self amIBestServer])
            {
                [_levelDirector initMapLevel:message->map.mapName];
                [self setGameState:kRPGameStateActive];
            }
        }
            break;
        ///////////////////////////////////////////////////////////////////    
        case kRPGameMessageTypeDispatchSprite:
        {
            if (![playerID isEqualToString:_bestServer])
            {
                NSLog(@"%@Only server can dispatch sprite for the other players",SELECTOR_STRING);
                return;
            }
            if ([self gameState] == kRPGameStateWaitingForRandomMap || [self gameState] == kRPGameStateWaitingForDesignatedSprite)
            {
                [self setGameState:kRPGameStateActive];
            }
            //Handle the message here
            //Only client should receive random map
            if (![self amIBestServer])
            {
                [[_levelDirector currentLayer] setPlayerSpriteIndex:message->designatedSprite.playerSpriteIndex];
                [self setupClientPlayerSprite];
                [_levelDirector setLocalPlayerReady:YES];
            }
        }
            break;
        ///////////////////////////////////////////////////////////////////    
        case kRPGameMessageTypePlayerMove:
        {
            //Handle player moving here
        }
            break;
        ///////////////////////////////////////////////////////////////////    
        case kRPGameMessageTypeGameOver:
        {
            //Handle game over here
            [self endGame];
        }
            break;
        ///////////////////////////////////////////////////////////////////    
        default :
        {
            NSLog(@"%@Message type is invalid", SELECTOR_STRING);
        }
            break;
        ///////////////////////////////////////////////////////////////////    
    }
    ///////////////////////////////////////////////////////////////////
}
///////////////////////////////////////////////////////////////////
//Player state changed
- (void)match:(GKMatch *)match player:(NSString *)playerID
didChangeState:(GKPlayerConnectionState)state
{
    switch (state)
    {
        case GKPlayerStateConnected:
            // Handle a new player connection.
            break;
        case GKPlayerStateDisconnected:
            // A player just disconnected.
            break;
    }
    if ([self gameState] == kRPGameStateWaitingForStart && match.expectedPlayerCount == 0)
    {
        // Handle initial match negotiation.
    }
}
///////////////////////////////////////////////////////////////////
@end
