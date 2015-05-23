
#import "User.h"
#import <KZAsserts.h>
#import <KZPropertyMapper.h>
#import <UIImageView+AFNetworking.h>
#import "Tutorial.h"
#import "TutorialsHelper.h"


static NSString *const kServerIDJSONAttributeName = @"id";
static NSString *const kServerIDKey = @"serverID";


@implementation User

- (void)configureFromDictionary:(NSDictionary *)dictionary
{
  AssertTrueOrReturn(dictionary.count);
  NSSet *oldCreatedTutorialsIDs = [self.createdTutorialsStoredOnServerSet valueForKey:kServerIDKey];
  
  NSMutableDictionary *mapping = [NSMutableDictionary dictionaryWithDictionary:@{
                            kServerIDJSONAttributeName : KZProperty(serverID),
                            @"name" : KZProperty(name),
                            @"pictureUri" : KZProperty(pictureURL),
                            @"description" : KZProperty(userDescription)
                           }];
  
  BOOL tutorialsChanged = NO;
  
  if (dictionary[@"tutorials"]) {
    [mapping addEntriesFromDictionary:@{
                                        @"tutorials" : KZCall(setOfOwnTutorialsFromDictionariesArray:, createdTutorial),
                                      }];
    tutorialsChanged = YES;
  }
  
  if (dictionary[@"likes"]) {
    [mapping addEntriesFromDictionary:@{
                                       @"likes" : KZCall(setOfAnotherUsersTutorialsFromDictionariesArray:, likes)
                                      }];
  }
  
  if (dictionary[@"followers"]) {
    // TODO: not implemented yet
  }
  
  if (dictionary[@"following"]) {
    // TODO: not implemented yet
  }
  
  [KZPropertyMapper mapValuesFrom:dictionary toInstance:self usingMapping:mapping];
  
  if (tutorialsChanged) {
    [self removeDeletedTutorialsWithOldTutorialIDsSet:oldCreatedTutorialsIDs];
  }
  
  // TODO: if tutorial was liked before but is not liked anymore it might be worth refreshing it (by making an additional request) - it might have been deleted
}

- (NSSet *)createdTutorialsStoredOnServerSet
{
  NSPredicate *predicate = [NSPredicate predicateWithFormat:@"storedOnServer == YES"];
  return [self.createdTutorialSet filteredSetUsingPredicate:predicate];
}

- (void)removeDeletedTutorialsWithOldTutorialIDsSet:(NSSet *)oldTutorialIDsSet
{
  if (oldTutorialIDsSet.count == 0) {
    return;
  }
  
  // Removing tutorials that used to belong to the user but don't anymore (meaning they have been deleted server-side)
  NSSet *currentTutorialIDs = [self.createdTutorialSet valueForKey:kServerIDKey];
  NSSet *tutorialIDsToRemove = [oldTutorialIDsSet tw_setByRemovingObjectsInSet:currentTutorialIDs];
  if (tutorialIDsToRemove.count) {
    [self deleteTutorialsWithIDs:tutorialIDsToRemove.allObjects inContext:self.managedObjectContext];
  }
}

- (void)deleteTutorialsWithIDs:(NSArray *)tutorialIDs inContext:(NSManagedObjectContext *)context
{
  AssertTrueOrReturn(tutorialIDs.count);
  AssertTrueOrReturn(context);
  NSPredicate *predicate = [NSPredicate predicateWithFormat:@"%K in %@", kServerIDKey, tutorialIDs];
  NSArray *tutorialsToRemove = [Tutorial MR_findAllWithPredicate:predicate inContext:context];
  [tutorialsToRemove makeObjectsPerformSelector:@selector(MR_deleteInContext:) withObject:context];
}

+ (NSString *)serverIDFromUserDictionary:(NSDictionary *)dictionary
{
  AssertTrueOrReturnNil(dictionary);
  NSString *serverID = dictionary[kServerIDJSONAttributeName];
  AssertTrueOrReturnNil(serverID);
  return serverID;
}

#pragma mark - Styling

- (void)placeAvatarInImageView:(UIImageView *)imageView
{
  AssertTrueOrReturn(imageView);
  AssertTrueOrReturn(self.pictureURL);
  
  [imageView setImageWithURL:[NSURL URLWithString:self.pictureURL]];
}

#pragma mark - Data extraction methods

- (NSSet *)setOfAnotherUsersTutorialsFromDictionariesArray:(id)dictionariesArray
{
  NSSet *result = [self setOfTutorialsFromDictionariesArray:dictionariesArray parseAuthors:YES];
  return result;
}

- (NSSet *)setOfOwnTutorialsFromDictionariesArray:(id)dictionariesArray
{
  return [self setOfTutorialsFromDictionariesArray:dictionariesArray parseAuthors:NO];
}

- (NSSet *)setOfTutorialsFromDictionariesArray:(id)dictionariesArray parseAuthors:(BOOL)parseAuthors
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
    [tutorial configureFromDictionary:dictionary includeAuthor:parseAuthors];
    
    AssertTrueOrReturn(tutorial);
    [tutorialsArray addObject:tutorial];
  }];
  
  return [NSSet setWithArray:tutorialsArray];
}

@end
