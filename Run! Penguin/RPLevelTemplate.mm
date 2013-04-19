//
//  RPLevelTemplate.m
//  Run!Penguin
//
//  Created by Sean on 13-3-12.
//  Copyright 2013年 __MyCompanyName__. All rights reserved.
//

#import "RPLevelTemplate.h"

@implementation RPLevelTemplate

@synthesize loader = _loader;
@synthesize loadingDelegate = _loadingDelegate;

#pragma mark - Memory management
-(id) init
{
    self = [super init];
    return self;
}

- (void) handlePanFrom:(UIPanGestureRecognizer *)recognizer
{
    //Subclass should override this method
}
- (void)touchBegan:(LHTouchInfo *)info onTag:(int)tag
{
    //Subclass should override this method
}
- (void)touchEnded:(LHTouchInfo *)info onTag:(int)tag
{
    //Subclass should override this method
}
#pragma mark - Update new scene loading progress
- (void)updateNewSceneProgress
{
    //Subclass should override this method
}
#pragma mark - Invoke Loading progress change
- (void)callLoadingProgressObserverWithValue:(float)val
{
    if (![self loadingDelegate])
    {
        NSLog(@"Loading delegate is invalid");
        return;
    }
    if ([[self loadingDelegate] respondsToSelector:@selector(loadingProgress:)])
    {
        [[self loadingDelegate] performSelector:@selector(loadingProgress:) withObject:[NSNumber numberWithFloat:val]];
    }
    else
    {
        NSLog(@"Loading delegate did not implement the protocol method");
    }
}

@end
