//
//  RPGameHelper.h
//  Run! Penguin
//
//  Created by Sean on 13-4-15.
//
//

#ifndef Run__Penguin_RPGameHelper_h
////////////////////////////////////////////////////////////////////////////
#define Run__Penguin_RPGameHelper_h
#define SELECTOR_STRING [NSString stringWithFormat:@"[%@ %@]: ",NSStringFromClass([self class]), NSStringFromSelector(_cmd)]
#define RPGameCenterLocalPlayerAuthenticationChanged @"RPGameCenterLocalPlayerAuthenticationChanged"
#define RPLevelLoadingProgressPercentageChanged @"RPLevelLoadingProgressPercentageChanged"
#define RPNewSceneIsInitializing @"RPNewSceneIsInitializing"
#define RPNewSceneHasBecomeCurrentScene @"RPNewSceneHasBecomeCurrentScene"
#define RPCustomerGainedGemsCountDidChanged @"RPCustomerGainedGemsCountDidChanged"
#define RPCustomerGainedGoodsCountDidChanged @"RPCustomerGainedGoodsCountDidChanged"
////////////////////////////////////////////////////////////////////////////
#endif
