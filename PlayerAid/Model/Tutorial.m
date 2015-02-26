#import "Tutorial.h"
#import <KZPropertyMapper.h>
#import "Section.h"
#import "User.h"


NSString *const kTutorialStateUnsaved = @"Unsaved";
static NSString *const kTutorialStateDraft = @"Draft";
static NSString *const kTutorialStateInReview = @"In Review";
NSString *const kTutorialStatePublished = @"Published";
NSString *const kTutorialDictionaryServerIDPropertyName = @"id";


@implementation Tutorial

#pragma mark - Populating with data

- (void)configureFromDictionary:(NSDictionary *)dictionary includeAuthor:(BOOL)includeAuthor
{
  AssertTrueOrReturn(dictionary.count);
  
  NSDictionary *mapping = @{
                            kTutorialDictionaryServerIDPropertyName : KZProperty(serverID),
                            @"title" : KZProperty(title),
                            @"createdOn" : KZBox(Date, createdAt),
                            @"status" : KZCall(stateFromString:, state),
                            @"image" : KZProperty(imageURL),
                            @"section" : KZCall(sectionFromString:, section)
                          };
  
  [KZPropertyMapper mapValuesFrom:dictionary toInstance:self usingMapping:mapping];
  
  AssertTrueOrReturn(self.state.length); // tutorial won't be visible anywhere if state is not set

  if (includeAuthor) {
    NSDictionary *mapping = @{
                              @"author" : KZCall(authorFromDictionary:, createdBy)
                             };
    [KZPropertyMapper mapValuesFrom:dictionary toInstance:self usingMapping:mapping];
  }
}

- (Section *)sectionFromString:(NSString *)sectionName
{
  AssertTrueOrReturnNil(sectionName.length);
  return [Section MR_findFirstByAttribute:@"name" withValue:sectionName inContext:self.managedObjectContext];
}

- (User *)authorFromDictionary:(NSDictionary *)authorDictionary
{
  AssertTrueOrReturnNil(authorDictionary.count);
  User *author = [User MR_createInContext:self.managedObjectContext];
  [author configureFromDictionary:authorDictionary];
  return author;
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
  self.state = kTutorialStateUnsaved;
}

#pragma mark - Draft

- (NSNumber *)draft
{
  return @([self primitiveDraftValue]);
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
