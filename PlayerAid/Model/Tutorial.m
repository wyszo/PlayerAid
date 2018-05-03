@import KZAsserts;
@import KZPropertyMapper;
@import MagicalRecord;
@import TWCommonLib;
#import "Tutorial.h"
#import "Tutorial_Clone.h"
#import "Section.h"
#import "User.h"
#import "TutorialStep.h"
#import "TutorialStepHelper.h"
#import "TutorialCommentParsingHelper.h"
#import "TutorialComment.h"

NSString *const kTutorialStatePublished = @"Published";
NSString *const kTutorialStateInReview = @"In Review";
NSString *const kTutorialDictionaryServerIDPropertyName = @"id";

static NSString *const kTutorialStateDraft = @"Draft";
static NSString *const kTutorialStateReported = @"Reported"; // as inappropriate
static NSString *const kTutorialDictionaryStepsKey = @"steps";
static NSString *const kCommentsKey = @"comments";
static NSString *const kAuthorKey = @"author";

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
                            @"reportedByUser" : KZProperty(reportedByUser),
                            @"section" : KZCall(sectionFromString:, section),
                          }];
  
  if (includeAuthor) {
    AssertTrueOr(dictionary[kAuthorKey], ;);
    [mapping addEntriesFromDictionary:@{
                                       kAuthorKey : KZCall(authorFromDictionary:, createdBy)
                                       }];
  }
  
  if (dictionary[kCommentsKey]) {
    [mapping addEntriesFromDictionary:@{ kCommentsKey : KZCall(commentsFromCommentsFeedDictionary:, hasComments) }];
  }
  
  [KZPropertyMapper mapValuesFrom:dictionary toInstance:self usingMapping:mapping];
  
  if (dictionary[kTutorialDictionaryStepsKey]) {
    if (self.consistsOf.count) {
      [self deleteLocalTutorialSteps];
    }
    
    NSDictionary *stepsMapping = @{
                                   kTutorialDictionaryStepsKey : KZCall(tutorialStepsFromDictionariesArray:, consistsOf)
                                   };
    [KZPropertyMapper mapValuesFrom:dictionary toInstance:self usingMapping:stepsMapping];
  }
    
  AssertTrueOrReturn(self.state.length); // tutorial won't be visible anywhere if state is not set
  AssertTrueOr(self.createdAt, self.createdAt = [NSDate new];);
  AssertTrueOr(self.title.length, self.title = @"";);
}

- (void)deleteLocalTutorialSteps
{
  for (TutorialStep *step in self.consistsOf) {
    if (step.serverID.integerValue == 0) {
      [self.managedObjectContext deleteObject:step];
    }
  }
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
  return [[UsersHelper new] userFromDictionary:authorDictionary inContext:self.managedObjectContext];
}

- (NSOrderedSet *)tutorialStepsFromDictionariesArray:(NSArray *)stepsDictionaries
{
  return [[TutorialStepHelper new] tutorialStepsFromDictionariesArray:stepsDictionaries inContext:self.managedObjectContext];
}

#pragma mark - class methods

+ (nonnull Tutorial *)findFirstByServerID:(nonnull NSNumber *)serverID inContext:(nonnull NSManagedObjectContext *)context {
  AssertTrueOrReturnNil(serverID);
  AssertTrueOrReturnNil(context);
  return [Tutorial MR_findFirstByAttribute:@"serverID" withValue:serverID inContext:context];
}

#pragma mark - Comments

- (NSOrderedSet *)commentsFromCommentsFeedDictionary:(nonnull id)feedObject {
  AssertTrueOrReturnNil([feedObject isKindOfClass:[NSDictionary class]]);
  NSDictionary *feedDictinary = (NSDictionary *)feedObject;
  
  // more comments should be available under nextPage feed...
  
  id data = feedDictinary[@"data"];
  AssertTrueOrReturnNil([data isKindOfClass:[NSArray class]]);
  NSArray *commentsDictionaries = (NSArray *)data;
  
  return [[TutorialCommentParsingHelper new] orderedSetOfCommentsFromDictionariesArray:(NSArray *)commentsDictionaries inContext:self.managedObjectContext];
}

#pragma mark - Accessors

- (BOOL)hasAnySteps
{
  return (self.consistsOf.count > 0);
}

- (BOOL)hasAnyPublishedComments
{
  NSPredicate *predicate = [NSPredicate predicateWithFormat:@"status == %lu", CommentStatusPublished];
  NSOrderedSet *publishedComments = [self.hasComments filteredOrderedSetUsingPredicate:predicate];
  return (publishedComments.count > 0);
}

#pragma mark - Cloning (public)

+ (NSArray *)entityClassNamesThatAllowOnlyShallowCopy
{
  NSArray *classesToExclude = [self entitiesClassesThatAllowOnlyShallowCopy];
  AssertTrueOrReturnNil(classesToExclude);
  NSMutableArray *namesToExclude = [NSMutableArray new];
  
  [classesToExclude enumerateObjectsUsingBlock:^(Class _Nonnull aClass, NSUInteger idx, BOOL * _Nonnull stop) {
    [namesToExclude addObject:NSStringFromClass(aClass)];
  }];
  return [namesToExclude copy];
}

#pragma mark - Cloning (private)

+ (NSArray *)entitiesClassesThatAllowOnlyShallowCopy
{
  /**
   It's crucial that all the classes that should not be deep-copied when tutorial object is cloned are listed in here!
   */
  return @[ [Section class], [User class] ];
}

#pragma mark - State

- (NSString *)stateFromString:(NSString *)state
{
  state = [self applyServerToHandsetMappingToState:state];
  
  if ([self stateIsValid:state]) {
    return state;
  }
  AssertTrueOr(NO, return kTutorialStateDraft;);
  return kTutorialStateDraft;
}

- (NSString *)applyServerToHandsetMappingToState:(NSString *)state
{
  if (!state.length) {
    return state;
  }

  // 'Submitted' on server -> 'In Review' in the app (state value is displayed as a section header)
  NSDictionary *serverToHandsetStateMapping = @{
                                                @"Submitted" : kTutorialStateInReview,
                                                @"Rejected" : kTutorialStateDraft // we just put rejected tutorials back as drafts to the user
                                                };
  if (serverToHandsetStateMapping[state]) {
    state = serverToHandsetStateMapping[state];
  }
  return state;
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
                         kTutorialStateDraft,
                         kTutorialStateInReview,
                         kTutorialStatePublished,
                         kTutorialStateReported
                        ];
  return [allStates containsObject:state];
}

- (BOOL)storedOnServer
{
  NSArray *statesStoredOnServer = @[
                                   // drafts are stored locally, never send to server
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

- (BOOL)isInReview {
  return [self.primitiveState isEqualToString:kTutorialStateInReview];
}

- (BOOL)isPublished
{
  return [self.primitiveState isEqualToString:kTutorialStatePublished];
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
    // do nothing, since draft is a default state - tutorial state will remain draft
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
