//
//  PlayerAid
//

#import <FacebookSDK.h>


@interface DataExtractionHelper : NSObject

+ (NSString *)emailFromFBGraphUser:(id<FBGraphUser>)user;

@end
