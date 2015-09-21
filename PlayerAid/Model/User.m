
#import "User.h"
#import <KZAsserts/KZAsserts.h>
#import <KZPropertyMapper/KZPropertyMapper.h>
#import <AFNetworking/UIImageView+AFNetworking.h>
#import "Tutorial.h"
#import "TutorialsHelper.h"
#import "UsersHelper.h"


NSString *const kUserServerIDJSONAttributeName = @"id";
NSString *const kUserServerIDKey = @"serverID";

static NSString *const kTutorialsKey = @"tutorials";
static NSString *const kLikesKey = @"likes";
static NSString *const kFollowersKey = @"followers";
static NSString *const kFollowingKey = @"following";


@implementation User

- (void)configureFromDictionary:(NSDictionary *)dictionary
{
  AssertTrueOrReturn(dictionary.count);
  NSSet *oldCreatedTutorialsIDs = [self.createdTutorialsStoredOnServerSet valueForKey:kUserServerIDKey];
  NSSet *locallyStoredTutorials = [self tutorialsStoredLocallySet];
  
  NSMutableDictionary *mapping = [NSMutableDictionary dictionaryWithDictionary:@{
                            kUserServerIDJSONAttributeName : KZProperty(serverID),
                            @"name" : KZProperty(name),
                            @"pictureUri" : KZProperty(pictureURL),
                            @"description" : KZProperty(userDescription)
                           }];
  
  BOOL tutorialsChanged = NO;
  
  if (dictionary[kTutorialsKey]) {
    [mapping addEntriesFromDictionary:@{ kTutorialsKey : KZCall(setOfOwnTutorialsFromDictionariesArray:, createdTutorial) }];
    tutorialsChanged = YES;
  }
  if (dictionary[kLikesKey]) {
    [mapping addEntriesFromDictionary:@{ kLikesKey : KZCall(setOfAnotherUsersTutorialsFromDictionariesArray:, likes) }];
  }
  if (dictionary[kFollowersKey]) {
    [mapping addEntriesFromDictionary:@{ kFollowersKey : KZCall(setOfOtherUsersFromDictionariesArray:, isFollowedBy) }];
  }
  if (dictionary[kFollowingKey]) {
    [mapping addEntriesFromDictionary:@{ kFollowingKey : KZCall(setOfOtherUsersFromDictionariesArray:, follows) }];
  }
  
  [KZPropertyMapper mapValuesFrom:dictionary toInstance:self usingMapping:mapping];
  
  if (tutorialsChanged) {
    [self removeDeletedTutorialsWithOldTutorialIDsSet:oldCreatedTutorialsIDs];
    [self.createdTutorialSet addObjectsFromArray:locallyStoredTutorials.allObjects]; // draft and unsaved tutorials don't come from server, we have to add them separately
  }
  
  // TODO: if tutorial was liked before but is not liked anymore it might be worth refreshing it (by making an additional request) - it might have been deleted
}

- (NSSet *)createdTutorialsStoredOnServerSet
{
  NSPredicate *predicate = [NSPredicate predicateWithFormat:@"storedOnServer == YES"];
  return [self.createdTutorialSet filteredSetUsingPredicate:predicate];
}

- (NSSet *)tutorialsStoredLocallySet
{
  NSPredicate *predicate = [NSPredicate predicateWithFormat:@"storedOnServer == NO"];
  return [self.createdTutorialSet filteredSetUsingPredicate:predicate];
}

- (void)removeDeletedTutorialsWithOldTutorialIDsSet:(NSSet *)oldTutorialIDsSet
{
  if (oldTutorialIDsSet.count == 0) {
    return;
  }
  
  // Removing tutorials that used to belong to the user but don't anymore (meaning they have been deleted server-side)
  NSSet *currentTutorialIDs = [self.createdTutorialSet valueForKey:kUserServerIDKey];
  NSSet *tutorialIDsToRemove = [oldTutorialIDsSet tw_setByRemovingObjectsInSet:currentTutorialIDs];
  if (tutorialIDsToRemove.count) {
    [self deleteTutorialsWithIDs:tutorialIDsToRemove.allObjects inContext:self.managedObjectContext];
  }
}

- (void)deleteTutorialsWithIDs:(NSArray *)tutorialIDs inContext:(NSManagedObjectContext *)context
{
  AssertTrueOrReturn(tutorialIDs.count);
  AssertTrueOrReturn(context);
  NSPredicate *predicate = [NSPredicate predicateWithFormat:@"%K in %@", kUserServerIDKey, tutorialIDs];
  NSArray *tutorialsToRemove = [Tutorial MR_findAllWithPredicate:predicate inContext:context];
  [tutorialsToRemove makeObjectsPerformSelector:@selector(MR_deleteInContext:) withObject:context];
}

+ (NSString *)serverIDFromUserDictionary:(NSDictionary *)dictionary
{
  AssertTrueOrReturnNil(dictionary);
  NSString *serverID = dictionary[kUserServerIDJSONAttributeName];
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

#pragma mark - Tutorials data extraction methods

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
  return [TutorialsHelper setOfTutorialsFromDictionariesArray:dictionariesArray parseAuthors:parseAuthors inContext:self.managedObjectContext];
}

#pragma mark - Users data extraction methods

- (NSSet *)setOfOtherUsersFromDictionariesArray:(id)dictionariesArray
{
  return [[UsersHelper new] setOfOtherUsersFromDictionariesArray:dictionariesArray inContext:self.managedObjectContext];
}

@end
