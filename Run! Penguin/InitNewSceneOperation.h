//
//  InitNewSceneOperation.h
//  CrazyShopping
//
//  Created by Sean on 13-3-28.
//
//

#import <Foundation/Foundation.h>

@interface InitNewSceneOperation : NSOperation
{
    NSString *_newSceneClassString;
}

- (id)initWithString:(NSString *)newSceneClassString;

@end
