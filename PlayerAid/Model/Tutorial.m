#import "Tutorial.h"
#import <KZAsserts.h>


NSString *const kTutorialStateUnsaved = @"Unsaved";
static NSString *const kTutorialStateDraft = @"Draft";
static NSString *const kTutorialStateInReview = @"In Review";
NSString *const kTutorialStatePublished = @"Published";


@interface Tutorial ()

@end


@implementation Tutorial

#pragma mark - State

- (void)setState:(NSString *)state
{
  NSArray *allStates = @[
                         kTutorialStateUnsaved,
                         kTutorialStateDraft,
                         kTutorialStateInReview,
                         kTutorialStatePublished
                         ];
  
  AssertTrueOrReturn([allStates containsObject:state]);
  self.primitiveState = state;
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
