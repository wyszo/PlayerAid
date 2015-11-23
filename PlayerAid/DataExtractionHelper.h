//
//  PlayerAid
//

@import FBSDKCoreKit;

NS_ASSUME_NONNULL_BEGIN

@interface DataExtractionHelper : NSObject

+ (nullable NSString *)emailFromFBGraphUser:(FBSDKProfile *)user;

@end

NS_ASSUME_NONNULL_END