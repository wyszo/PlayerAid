//
//  PlayerAid
//

@import Foundation;

typedef void (^ProfileRequestCompletionBlock)(FBSDKProfile * _Nullable profile, NSString * _Nullable email, NSError * _Nullable error);


@interface FBGraphApiRequest : NSObject

- (void)makeGraphApiProfileRequestWithCompletion:(nullable ProfileRequestCompletionBlock)completionBlock;

@end
