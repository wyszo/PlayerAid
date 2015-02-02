//
//  PlayerAid
//

#import <Foundation/Foundation.h>
#import <FacebookSDK.h>

@interface DataExtractionHelper : NSObject

+ (NSString *)emailFromUser:(id<FBGraphUser>)user;

@end
