//
//  PlayerAid
//

@import FBSDKCoreKit;

@interface DataExtractionHelper : NSObject

+ (NSString *)emailFromFBGraphUser:(id<FBGraphUser>)user;

@end
