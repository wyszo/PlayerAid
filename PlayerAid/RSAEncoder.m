//
//  PlayerAid
//

@import XRSA;
@import KZAsserts;
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
    _xRsaEncryptor = [[XRSA alloc] initWithPublicKey:certificatePath]; // if this is nil, it means that server certificates expired
    AssertTrueOrReturnNil(_xRsaEncryptor != nil);
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
  AssertTrueOrReturnNil(self.xRsaEncryptor); // na tym sie wywala, to jest puste
  
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
