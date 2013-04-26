//
//  RPLevelTemplate.h
//  Run!Penguin
//
//  Created by Sean on 13-3-12.
//  Copyright 2013年 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "cocos2d.h"
#import "LevelHelperLoader.h"
//Loading progress protocol
@protocol RPLeveLoadingProgress <NSObject>
-(void)loadingProgress:(NSNumber*)progress;
@end

@interface RPLevelTemplate : CCLayer
{
    LevelHelperLoader *_loader;
    id<RPLeveLoadingProgress> _loadingDelegate;
    //The maximum counts of players in multiplayer mode, 0 means not available for
    //multiplayer mode
    int _playerCountInMultiplayerMode;    
}
@property (assign,nonatomic,readwrite) LevelHelperLoader *loader;
@property (assign,nonatomic,readwrite) id<RPLeveLoadingProgress> loadingDelegate;
@property (assign,nonatomic,readwrite) int playerCountInMultiplayerMode;


//Subclass should implement these methods
- (void) handlePanFrom:(UIPanGestureRecognizer *)recognizer;
- (void)touchBegan:(LHTouchInfo *)info onTag:(int)tag;
- (void)touchEnded:(LHTouchInfo *)info onTag:(int)tag;

- (void)updateNewSceneProgress;
@end
