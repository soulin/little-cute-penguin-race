//
//  AppDelegate.h
//  Run! Penguin
//
//  Created by Sean on 13-4-11.
//  Copyright __MyCompanyName__ 2013年. All rights reserved.
//

#import <UIKit/UIKit.h>

@class RootViewController;

@interface AppDelegate : NSObject <UIApplicationDelegate> {
	UIWindow			*window;
	RootViewController	*viewController;
    UIPanGestureRecognizer *_appPanGestureRecognizer;
}

@property (nonatomic, retain) UIWindow *window;
@property (readonly,nonatomic) UIPanGestureRecognizer *appPanGestureRecognizer;

@end
