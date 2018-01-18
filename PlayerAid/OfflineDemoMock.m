//
//  OfflineDemoMock.m
//  PlayerAid
//
//  Created by PlayerAid on 14/01/2018.
//

#import "OfflineDemoMock.h"

@implementation OfflineDemoMock

SHARED_INSTANCE_GENERATE_IMPLEMENTATION

- (NSDictionary *)mockUser {
  return [self JSONFromFile:@"user"];
}

- (NSArray *)mockGuideDictionaries {
  // perhaps this won't even be necessary, let's try with mocking guide steps in user object first
  // return @[[self JSONFromFile:@"guide"]];
  return @[];
}

- (NSDictionary *)JSONFromFile:(NSString *)filename
{
  NSString *path = [[NSBundle mainBundle] pathForResource:filename ofType:@"json"];
  NSData *data = [NSData dataWithContentsOfFile:path];
  return [NSJSONSerialization JSONObjectWithData:data options:kNilOptions error:nil];
}

@end
