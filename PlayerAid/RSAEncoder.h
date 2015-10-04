//
//  PlayerAid
//

@import Foundation;

@interface RSAEncoder : NSObject

- (nonnull NSData *)encodeWithString:(nonnull NSString *)string;
- (nonnull NSString *)encodeToString:(nonnull NSString *)string;

@end
