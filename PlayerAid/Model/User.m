
#import "User.h"
#import <KZAsserts.h>
#import <KZPropertyMapper.h>
#import <UIImageView+AFNetworking.h>
#import "Tutorial.h"
#import "TutorialsHelper.h"


@implementation User

- (void)configureFromDictionary:(NSDictionary *)dictionary
{
  AssertTrueOrReturn(dictionary.count);
  
  NSDictionary *mapping = @{
                            @"id" : KZProperty(serverID),
                            @"name" : KZProperty(name),
                            @"picture" : KZProperty(pictureURL),
                            @"description" : KZProperty(userDescription),
                            @"tutorials" : KZCall(setOfObjectsFromDictionariesArray:, createdTutorial)
                            
                            // TODO: followers
                            // TODO: following
                            // TODO: likes
                           };
  [KZPropertyMapper mapValuesFrom:dictionary toInstance:self usingMapping:mapping];
  
  [self cleanupTutorialsWithoutParents]; // will delete any tutorial that used to belong to the user but has been removed on another device
}

- (void)cleanupTutorialsWithoutParents
{
  NSArray *tutorialsWithoutParent = [Tutorial MR_findAllWithPredicate:[NSPredicate predicateWithFormat:@"createdBy == nil"] inContext:self.managedObjectContext];
  [tutorialsWithoutParent makeObjectsPerformSelector:@selector(MR_deleteInContext:) withObject:self.managedObjectContext];
}

#pragma mark - Styling

- (void)placeAvatarInImageView:(UIImageView *)imageView
{
  AssertTrueOrReturn(imageView);
  AssertTrueOrReturn(self.pictureURL);
  
  [imageView setImageWithURL:[NSURL URLWithString:self.pictureURL]];
}

#pragma mark - Data extraction methods

- (NSSet *)setOfObjectsFromDictionariesArray:(id)dictionariesArray
{
  AssertTrueOrReturnNil([dictionariesArray isKindOfClass:[NSArray class]]);
  NSMutableArray *tutorialsArray = [NSMutableArray new];
  
  [dictionariesArray enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
    AssertTrueOrReturn([obj isKindOfClass:[NSDictionary class]]);
    NSDictionary *dictionary = (NSDictionary *)obj;
    
    NSString *serverID = [TutorialsHelper serverIDFromTutorialDictionary:dictionary];
    Tutorial *tutorial = [TutorialsHelper tutorialWithServerID:serverID inContext:self.managedObjectContext];
    if (!tutorial) {
      tutorial = [Tutorial MR_createInContext:self.managedObjectContext];
    }
    [tutorial configureFromDictionary:dictionary];
    
    AssertTrueOrReturn(tutorial);
    [tutorialsArray addObject:tutorial];
  }];
  
  return [NSSet setWithArray:tutorialsArray];
}

@end
