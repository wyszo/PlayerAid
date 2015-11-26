//
//  PlayerAid
//

@import FBSDKCoreKit;

NS_ASSUME_NONNULL_BEGIN

// TODO: rename this class!!
@interface FBSDKProfileFormatter : NSObject

+ (nullable NSString *)formattedEmail:(nullable NSString *)email fromFBSDKProfile:(nonnull FBSDKProfile *)userProfile;

@end

NS_ASSUME_NONNULL_END