
@import KZAsserts;
@import KZPropertyMapper;
@import MagicalRecord;
@import AFNetworking;
@import TWCommonLib;
#import "User.h"
#import "Tutorial.h"
#import "TutorialsHelper.h"
#import "UsersHelper.h"
#import "NSError+PlayerAidErrors.h"
#import "DebugSettings.h"
#import "NSObject+SafeCasting.h"

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
                            @"name" : KZCall(nonemptyStringFromName:, name),
                            @"pictureUri" : KZProperty(pictureURL),
                            @"description" : KZProperty(userDescription)
                           }];
  
  BOOL tutorialsChanged = NO;
  
  if (dictionary[kTutorialsKey]) {
    [mapping addEntriesFromDictionary:@{ kTutorialsKey : KZCall(setOfOwnTutorialsFromPagedDictionary:, createdTutorial) }];
    tutorialsChanged = YES;
  }
  if (dictionary[kLikesKey]) {
    [mapping addEntriesFromDictionary:@{ kLikesKey : KZCall(setOfAnotherUsersTutorialsFromPagedDictionary:, likes) }];
  }
  if (dictionary[kFollowersKey]) {
    [mapping addEntriesFromDictionary:@{ kFollowersKey : KZCall(setOfOtherUsersFromPagedDictionary:, isFollowedBy) }];
  }
  if (dictionary[kFollowingKey]) {
    [mapping addEntriesFromDictionary:@{ kFollowingKey : KZCall(setOfOtherUsersFromPagedDictionary:, follows) }];
  }
  
  [KZPropertyMapper mapValuesFrom:dictionary toInstance:self usingMapping:mapping];
  
  if (tutorialsChanged) {
    [self removeDeletedTutorialsWithOldTutorialIDsSet:oldCreatedTutorialsIDs];
    [self.createdTutorialSet addObjectsFromArray:locallyStoredTutorials.allObjects]; // draft tutorials don't come from server, we have to add them separately
  }
  
  // TODO: if tutorial was liked before but is not liked anymore it might be worth refreshing it (by making an additional request) - it might have been deleted
}

- (NSString *)nonemptyStringFromName:(nullable NSString *)name
{
  NSString *safeName = @"";
  if (name) {
    safeName = name;
  }
  return safeName;
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
  [tutorialsToRemove makeObjectsPerformSelector:@selector(MR_deleteEntityInContext:) withObject:context];
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
  if (self.pictureURL) { // users creaded using email/signup flow don't need to have a picture
    NSURLRequest *request = [NSURLRequest requestWithURL:[NSURL URLWithString:self.pictureURL]];
    [imageView setImageWithURLRequest:request placeholderImage:nil success:nil failure:^(NSURLRequest *request, NSHTTPURLResponse *response, NSError *error) {
      if ([error isURLRequestErrorUserCancelled]) {
        // all good - request cancelled, because we didn't care about the outcome anymore
        // TODO: in this case we probably want to queue it, high chance we'll request that data later
        return;
      }
      else {
        NSLog(@"Avatar image loading error: %@", error);
        if (!DEBUG_OFFLINE_MODE) {
          AssertTrueOrReturn(!error);
        }
      }
    }];
  }
}

- (void)placeAvatarInImageViewOrDisplayPlaceholder:(nonnull UIImageView *)imageView placeholderSize:(AvatarPlaceholderSize)placeholderSize;
{
  if (self.pictureURL) {
    [self placeAvatarInImageView:imageView];
  } else {
    [imageView setImage:[[UsersHelper new] avatarPlaceholderImageForPlaceholderSize:placeholderSize]];
  }
}

- (NSURL *)avatarURL {
    return [NSURL URLWithString:self.pictureURL];
}

#pragma mark - Tutorials data extraction methods

- (NSSet *)setOfAnotherUsersTutorialsFromPagedDictionary:(id)pagedDictionary
{
  return [self setOfTutorialsFromPagedDictionary:pagedDictionary parseAuthors:YES];
}

- (NSSet *)setOfOwnTutorialsFromPagedDictionary:(id)pagedDictionary
{
  return [self setOfTutorialsFromPagedDictionary:pagedDictionary parseAuthors:NO];
}

- (NSSet *)setOfTutorialsFromPagedDictionary:(id)pagedDictionary parseAuthors:(BOOL)parseAuthors
{
  NSArray *dictionariesArray = [self dataArrayFromPagedDictionary:pagedDictionary];
  return [TutorialsHelper setOfTutorialsFromDictionariesArray:dictionariesArray parseAuthors:parseAuthors inContext:self.managedObjectContext];
}

#pragma mark - Users data extraction methods

- (NSSet *)setOfOtherUsersFromPagedDictionary:(id)pagedDictionary
{
  NSArray *dictionariesArray = [self dataArrayFromPagedDictionary:pagedDictionary];
  return [[UsersHelper new] setOfOtherUsersFromDictionariesArray:dictionariesArray inContext:self.managedObjectContext];
}

#pragma mark - Auxiliary methods

- (NSArray *)dataArrayFromPagedDictionary:(id)pagedDictionary {
    return [[pagedDictionary safeCastToDictionary][@"data"] safeCastToArray];
}

@end
