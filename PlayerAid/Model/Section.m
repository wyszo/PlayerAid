#import "Section.h"
#import "SectionsDataSource.h"

@interface Section ()
@end

@implementation Section

- (NSString *)displayName
{
  NSDictionary *displayNameMapping = @{
                            kServerSectionNameGameKnowledge : @"Game Knowledge"
                          };
  NSString *displayName = displayNameMapping[self.name];
  if (!displayName.length) {
    displayName = self.name;
  }
  return displayName;
}

@end
