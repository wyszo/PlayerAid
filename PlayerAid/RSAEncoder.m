//
//  PlayerAid
//

#import <XRSA/XRSA.h>
#import "RSAEncoder.h"
#import "EnvironmentSettings.h"

@interface RSAEncoder ()
@property (nonatomic, strong) XRSA *xRsaEncryptor;
@end

@implementation RSAEncoder

- (instancetype)init
{
  self = [super init];
  if (self) {
    NSString *certificatePath = [self serverRSACertificatePath];
    _xRsaEncryptor = [[XRSA alloc] initWithPublicKey:certificatePath];
  }
  return self;
}

- (nonnull NSData *)encodeWithString:(nonnull NSString *)string
{
  AssertTrueOrReturnNil(string.length);
  AssertTrueOrReturnNil(self.xRsaEncryptor);
  
  NSData *encryptedData = [self.xRsaEncryptor encryptWithString:string];
  AssertTrueOrReturnNil(encryptedData.length);
  return encryptedData;
}

- (nonnull NSString *)encodeToString:(nonnull NSString *)string
{
  AssertTrueOrReturnNil(string.length);
  AssertTrueOrReturnNil(self.xRsaEncryptor);
  
  NSString *encryptedString = [self.xRsaEncryptor encryptToString:string];
  AssertTrueOrReturnNil(encryptedString.length);
  return encryptedString;
}

#pragma mark - Auxiliary methods

- (NSString *)serverRSACertificatePath
{
  NSString *certificatePath = [[EnvironmentSettings new] serverRSACertificatePath];
  AssertTrueOrReturnNil(certificatePath.length);
  return certificatePath;
}

@end
