#import "Tutorial.h"
#import <KZAsserts.h>


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
                         kTutorialStateDraft,
                         kTutorialStateInReview,
                         kTutorialStatePublished
                         ];
  
  AssertTrueOrReturn([allStates containsObject:state]);
  self.primitiveState = state;
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
  
- (void)setDraft:(NSNumber *)draft
{
  self.state = kTutorialStateDraft;
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

@end
