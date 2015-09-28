//
//  PlayerAid
//

#import <XRSA/XRSA.h>
#import "RSAEncoder.h"
#import "EnvironmentSettings.h"

@implementation RSAEncoder

- (nonnull NSData *)encodeString:(nonnull NSString *)string
{
  AssertTrueOrReturnNil(string.length);
  
  NSString *certificatePath = [[EnvironmentSettings new] serverRSACertificatePath];
  AssertTrueOrReturnNil(certificatePath.length);
  
  XRSA *xRsaEncryptor = [[XRSA alloc] initWithPublicKey:certificatePath];
  
  NSData *encryptedData = [xRsaEncryptor encryptWithString:string];
  AssertTrueOrReturnNil(encryptedData.length);
  return encryptedData;
}

@end
