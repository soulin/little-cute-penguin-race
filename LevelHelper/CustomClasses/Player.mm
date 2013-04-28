//This source file was generated automatically by LevelHelper
//based on the class template defined by the user.
//For more info please visit: www.levelhelper.org


#import "Player.h"

@implementation Player


@synthesize index;
@synthesize isReadyToGo;


-(void) dealloc{
#if __has_feature(objc_arc) && __clang_major__ >= 3

#else


[super dealloc];

#endif // __has_feature(objc_arc)
}

+(Player*) customClassInstance{
#if __has_feature(objc_arc) && __clang_major__ >= 3
return [[Player alloc] init];
#else
return [[[Player alloc] init] autorelease];
#endif
}

-(NSString*) className{
return NSStringFromClass([self class]);
}
-(void) setPropertiesFromDictionary:(NSDictionary*)dictionary
{

	if([dictionary objectForKey:@"index"])
		[self setIndex:[[dictionary objectForKey:@"index"] floatValue]];

	if([dictionary objectForKey:@"isReadyToGo"])
		[self setIsReadyToGo:[[dictionary objectForKey:@"isReadyToGo"] boolValue]];

}

@end
