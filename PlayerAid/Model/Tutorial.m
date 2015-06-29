#import "Tutorial.h"
#import <KZPropertyMapper.h>
#import "Section.h"
#import "User.h"
#import "TutorialStep.h"
#import "TutorialStepHelper.h"


NSString *const kTutorialStateUnsaved = @"Unsaved";
static NSString *const kTutorialStateDraft = @"Draft";
static NSString *const kTutorialStateInReview = @"Submitted"; // TODO: need to introduce a mapping between server and handset naming, this should be 'In Review' on a hanset (used to display section names in user's tutorials) 
NSString *const kTutorialStatePublished = @"Published";
NSString *const kTutorialDictionaryServerIDPropertyName = @"id";


@implementation Tutorial

#pragma mark - Populating with data

- (void)configureFromDictionary:(NSDictionary *)dictionary includeAuthor:(BOOL)includeAuthor
{
  AssertTrueOrReturn(dictionary.count);
  
  NSMutableDictionary *mapping = [[NSMutableDictionary alloc] initWithDictionary: @{
                            kTutorialDictionaryServerIDPropertyName : KZProperty(serverID),
                            @"title" : KZProperty(title),
                            @"createdOn" : KZBox(DateWithTZD, createdAt),
                            @"status" : KZCall(stateFromString:, state),
                            @"imageUri" : KZProperty(imageURL),
                            @"section" : KZCall(sectionFromString:, section),
                            @"steps" : KZCall(tutorialStepsFromDictionariesArray:, consistsOf)
                          }];
  
  if (includeAuthor) {
    [mapping addEntriesFromDictionary:@{
                                       @"author" : KZCall(authorFromDictionary:, createdBy)
                                       }];
  }
  [KZPropertyMapper mapValuesFrom:dictionary toInstance:self usingMapping:mapping];
  
  AssertTrueOrReturn(self.state.length); // tutorial won't be visible anywhere if state is not set
  AssertTrueOr(self.createdAt, self.createdAt = [NSDate new];);
  AssertTrueOr(self.title.length, self.title = @"";);
}

- (Section *)sectionFromString:(NSString *)sectionName
{
  AssertTrueOrReturnNil(sectionName.length);
  Section *section = [Section MR_findFirstByAttribute:@"name" withValue:sectionName inContext:self.managedObjectContext];
  AssertTrueOrReturnNil(section);
  return section;
}

- (User *)authorFromDictionary:(NSDictionary *)authorDictionary
{
  AssertTrueOrReturnNil(authorDictionary.count);
  NSString *authorID = [User serverIDFromUserDictionary:authorDictionary];
  
  User *author = [User MR_findFirstByAttribute:@"serverID" withValue:authorID inContext:self.managedObjectContext];
  if (!author) {
    author = [User MR_createInContext:self.managedObjectContext];
  }
  [author configureFromDictionary:authorDictionary];
  return author;
}

- (NSOrderedSet *)tutorialStepsFromDictionariesArray:(NSArray *)stepsDictionaries
{
  return [[TutorialStepHelper new] tutorialStepsFromDictionariesArray:stepsDictionaries inContext:self.managedObjectContext];
}

#pragma mark - State

- (NSString *)stateFromString:(NSString *)state
{
  if ([self stateIsValid:state]) {
    return state;
  }
  AssertTrueOr(NO, return kTutorialStateUnsaved;);
  return kTutorialStateUnsaved;
}

- (void)setState:(NSString *)state
{
  if ([self stateIsValid:state]) {
    self.primitiveState = state;
  }
}

- (BOOL)stateIsValid:(NSString *)state
{
  NSArray *allStates = @[
                         kTutorialStateUnsaved,
                         kTutorialStateDraft,
                         kTutorialStateInReview,
                         kTutorialStatePublished
                        ];
  return [allStates containsObject:state];
}

- (BOOL)storedOnServer
{
  NSArray *statesStoredOnServer = @[
                                   // draft and unsaved tutorials are stored locally, never send to server
                                   // inReview tutorials are also stored locally (server doesn't push updates with them) - for now (this will change in the future)
                                   kTutorialStatePublished
                                  ];
  return [statesStoredOnServer containsObject:self.primitiveState];
}

- (void)setStateToDraft
{
  self.primitiveState = kTutorialStateDraft;
}

- (void)setStateToInReview
{
  self.primitiveState = kTutorialStateInReview;
}

- (BOOL)isPublished
{
  return [self.primitiveState isEqualToString:kTutorialStatePublished];
}

#pragma mark - Unsaved

- (NSNumber *)unsaved
{
  return @([self primitiveUnsavedValue]);
}

- (BOOL)primitiveUnsavedValue
{
  return [self.state isEqualToString:kTutorialStateUnsaved];
}

- (void)setUnsavedValue:(BOOL)value_
{
  [self setPrimitiveUnsavedValue:value_];
}

- (void)setPrimitiveUnsavedValue:(BOOL)value
{
  if (value) {
    self.state = kTutorialStateUnsaved;
  }
  else {
    self.state = kTutorialStateDraft;
  }
}

#pragma mark - Draft

- (NSNumber *)draft
{
  return @([self primitiveDraftValue]);
}

- (BOOL)isDraft
{
  return self.primitiveDraftValue;
}

- (BOOL)primitiveDraftValue
{
  return [self.state isEqualToString:kTutorialStateDraft];
}

- (void)setDraftValue:(BOOL)value_
{
  [self setPrimitiveDraftValue:value_];
}

- (void)setPrimitiveDraftValue:(BOOL)value
{
  if (value) {
    self.state = kTutorialStateDraft;
  }
  else {
    self.state = kTutorialStateUnsaved;
  }
}

#pragma mark - In Review

- (NSNumber *)inReview
{
  return @([self primitiveInReviewValue]);
}

- (BOOL)primitiveInReviewValue
{
  return [self.state isEqualToString:kTutorialStateInReview];
}

- (void)setInReview:(NSNumber *)inReview
{
  self.state = kTutorialStateInReview;
}

- (void)setInReviewValue:(BOOL)value_
{
  [self setPrimitiveInReviewValue:value_];
}

- (void)setPrimitiveInReviewValue:(BOOL)value_
{
  if (value_) {
    self.state = kTutorialStateInReview;
  } else {
    self.state = kTutorialStateDraft;
  }
}

@end
