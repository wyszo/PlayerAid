//
//  PlayerAid
//

#import <Foundation/Foundation.h>

@class AuthenticationRequestData;

// A wrapper to network requests to our server
@interface ServerCommunicationController : NSObject

+ (void)requestAPITokenWithAuthenticationRequestData:(AuthenticationRequestData *)data completion:(void (^)(NSHTTPURLResponse *response, NSError *error))completion;

@end


// Helper class to deliver request parameters
@interface AuthenticationRequestData : NSObject

@property (nonatomic, copy) NSString *facebookAuthenticationToken;
@property (nonatomic, copy) NSString *email;

@end