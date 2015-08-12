//
//  PlayerAid
//

#import "TutorialStepHelper.h"
#import "TutorialStep.h"


@implementation TutorialStepHelper

- (NSOrderedSet *)tutorialStepsFromDictionariesArray:(NSArray *)stepsDictionaries inContext:(NSManagedObjectContext *)context
{
  if (!stepsDictionaries.count) {
    return nil;
  }
  
  NSMutableOrderedSet *mutableSet = [NSMutableOrderedSet new];
  
  [stepsDictionaries enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
    AssertTrueOrReturn([obj isKindOfClass:[NSDictionary class]]);
    NSDictionary *dictionary = (NSDictionary *)obj;
    NSNumber *stepID = [TutorialStep serverIDFromTutorialStepDictionary:dictionary];
    AssertTrueOrReturn(stepID);
    
    TutorialStep *tutorialStep = [TutorialStep MR_findFirstByAttribute:@"serverID" withValue:[stepID stringValue] inContext:context];
    if (!tutorialStep) {
      tutorialStep = [TutorialStep MR_createInContext:context];
    }
    [tutorialStep configureFromDictionary:dictionary];
    
    AssertTrueOrReturn(tutorialStep.serverID);
    [mutableSet addObject:tutorialStep];
  }];
  
  return [mutableSet copy];
}

@end
