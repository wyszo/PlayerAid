//
//  PlayerAid
//

#import <Foundation/Foundation.h>
#import <FacebookSDK.h>

@interface DataExtractionHelper : NSObject

+ (NSString *)emailFromFBGraphUser:(id<FBGraphUser>)user;

@end
