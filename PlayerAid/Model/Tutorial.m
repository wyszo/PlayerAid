#import "Tutorial.h"
#import <KZPropertyMapper.h>


NSString *const kTutorialStateUnsaved = @"Unsaved";
static NSString *const kTutorialStateDraft = @"Draft";
static NSString *const kTutorialStateInReview = @"In Review";
NSString *const kTutorialStatePublished = @"Published";
NSString *const kTutorialDictionaryServerIDPropertyName = @"id";


@implementation Tutorial

#pragma mark - Populating with data

- (void)configureFromDictionary:(NSDictionary *)dictionary
{
  AssertTrueOrReturn(dictionary.count);
  
  NSDictionary *mapping = @{
                            kTutorialDictionaryServerIDPropertyName : KZProperty(serverID),
                            @"title" : KZProperty(title),
                            @"createdOn" : KZBox(Date, createdAt),
                            @"status" : KZCall(stateFromString:, state)
                            // TODO: section
                          };
  
  [KZPropertyMapper mapValuesFrom:dictionary toInstance:self usingMapping:mapping];
  
  AssertTrueOrReturn(self.state.length); // tutorial won't be visible anywhere if state is not set
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
